import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/account_errors.dart';
import '../application/account_state.dart';
import 'unavailable_account_repository.dart';
import 'account_repository.dart';
import 'account_models.dart';
import 'priva_treatment_policy.dart';
import 'firebase_registration_store.dart';

/// Native Firebase identity with immutable Firestore authorization evidence.
class FirebaseAccountRepository extends UnavailableAccountRepository
    implements EmailLinkRecovery, EmailLinkVerification, SessionRestoration {
  FirebaseAccountRepository(this.auth, {this.registrationStore});
  final AccountRegistrationStore? registrationStore;
  final FirebaseAuth auth;
  AccountSession? _session;
  int _sessionRevision = 0;

  @override
  AccountSession? get currentSession => _session;

  @override
  Stream<AccountSession?>
  get sessionChanges => auth.idTokenChanges().asyncExpand((user) async* {
    // Skip events that precede any validated grant, including startup events.
    final existing = _session;
    if (existing == null) return;
    AccountSession? validated = existing;
    try {
      if (user == null || !user.emailVerified || user.uid != existing.userId) {
        validated = null;
      } else {
        final token = await user.getIdTokenResult();
        if (token.signInProvider != 'password' ||
            await registrationStore?.hasAuthorization(user.uid) != true) {
          validated = null;
        }
      }
    } catch (error) {
      // Network unavailability is not evidence of logout or revoked consent.
      // This can retain a prior grant only, never establish a new one.
      final transient =
          error is FirebaseException &&
          const {
            'unavailable',
            'deadline-exceeded',
            'network-request-failed',
          }.contains(error.code);
      if (!transient) validated = null;
    }
    if (!identical(_session, existing)) return;
    if (auth.currentUser?.uid != existing.userId ||
        auth.currentUser?.emailVerified != true) {
      validated = null;
    }
    _session = validated;
    yield validated;
  });

  @override
  Future<AccountSession?> restoreSession() async {
    final revision = ++_sessionRevision;
    _session = null;
    try {
      final user = await auth.authStateChanges().first;
      if (revision != _sessionRevision ||
          user == null ||
          !user.emailVerified ||
          registrationStore == null) {
        return null;
      }
      final token = await user.getIdTokenResult(true);
      if (token.signInProvider != 'password' ||
          !await registrationStore!.hasAuthorization(user.uid)) {
        return null;
      }
      final name = await registrationStore!.profileName(user.uid);
      if (revision != _sessionRevision ||
          auth.currentUser?.uid != user.uid ||
          auth.currentUser?.emailVerified != true) {
        return null;
      }
      return _session = AccountSession(
        userId: user.uid,
        emailVerified: true,
        passwordAuthenticated: true,
        displayName: name,
      );
    } catch (_) {
      if (revision == _sessionRevision) _session = null;
      // Preserve the native identity on connection errors; do not grant access.
      throw const AccountFailure();
    }
  }

  @override
  Future<AccountSession?> signIn({
    required String email,
    required String password,
  }) async {
    _sessionRevision++;
    _session = null;
    var stage = SignInIssue.credentials;
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user == null) throw const SignInFailure(SignInIssue.credentials);
      if (!user.emailVerified) {
        throw const SignInFailure(SignInIssue.verification);
      }
      stage = SignInIssue.identity;
      final token = await user.getIdTokenResult(true);
      if (token.signInProvider != 'password') {
        throw const SignInFailure(SignInIssue.identity);
      }
      if (registrationStore == null) {
        throw const SignInFailure(SignInIssue.configuration);
      }
      stage = SignInIssue.authorizationRead;
      if (!await registrationStore!.hasAuthorization(user.uid)) {
        throw const SignInFailure(SignInIssue.authorizationMissing);
      }
      stage = SignInIssue.profileRead;
      final name = await registrationStore!.profileName(user.uid);
      // Revalidate after every server read before granting the private session.
      if (auth.currentUser?.uid != user.uid ||
          auth.currentUser?.emailVerified != true) {
        throw const SignInFailure(SignInIssue.identity);
      }
      return _session = AccountSession(
        userId: user.uid,
        emailVerified: true,
        passwordAuthenticated: true,
        displayName: name,
      );
    } catch (error) {
      _session = null;
      try {
        await auth.signOut();
      } catch (_) {
        /* Remain unprivileged. */
      }
      if (error is SignInFailure) rethrow;
      if (error is FirebaseAuthException) {
        if (error.code == 'network-request-failed') {
          throw const SignInFailure(SignInIssue.network);
        }
        if (error.code == 'too-many-requests') {
          throw const SignInFailure(SignInIssue.rateLimited);
        }
        if (const {
          'operation-not-allowed',
          'invalid-api-key',
          'app-not-authorized',
          'invalid-app-id',
          'configuration-not-found',
        }.contains(error.code)) {
          throw const SignInFailure(SignInIssue.configuration);
        }
        // All invalid account/password outcomes remain indistinguishable.
        if (const {
          'invalid-credential',
          'invalid-login-credentials',
          'wrong-password',
          'user-not-found',
          'user-disabled',
          'invalid-email',
        }.contains(error.code)) {
          throw const SignInFailure(SignInIssue.credentials);
        }
        throw const SignInFailure(SignInIssue.service);
      }
      throw SignInFailure(stage);
    }
  }

  @override
  Future<TreatmentPolicy?> loadPolicy() async =>
      registrationStore == null ? null : privaTreatmentPolicy;

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String policyVersion,
  }) async {
    if (registrationStore == null ||
        policyVersion != privaPolicyVersion ||
        name.trim().isEmpty ||
        password.runes.length < 12) {
      throw const AccountFailure();
    }
    _session = null;
    User? created;
    var recorded = false;
    try {
      await auth.signOut();
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      created = result.user;
      if (created == null) throw const AccountFailure();
      try {
        await registrationStore!.create(uid: created.uid, name: name.trim());
        recorded = true;
      } catch (_) {
        // An acknowledgement may be lost after the atomic batch has committed.
        recorded = await registrationStore!.hasAuthorization(created.uid);
        if (!recorded) rethrow;
      }
      await created.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      // A repeated signup must not disclose whether another account exists.
      if (created == null && error.code == 'email-already-in-use') {
        await _completeExistingRegistration(
          name: name,
          email: email,
          password: password,
        );
        return;
      }
      await _handleFailedSignup(created, recorded);
    } catch (_) {
      await _handleFailedSignup(created, recorded);
    }
  }

  Future<void> _completeExistingRegistration({
    required String name,
    required String email,
    required String password,
  }) async {
    User? existing;
    try {
      // The caller already read and explicitly accepted the current policy.
      // Prove ownership before recording consent for an existing account.
      existing = (await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
    } catch (_) {
      try {
        await auth.signOut();
      } catch (_) {}
      return; // Same public signup outcome; no account-existence disclosure.
    }
    if (existing == null) return;
    try {
      if (!await registrationStore!.hasAuthorization(existing.uid)) {
        await registrationStore!.create(uid: existing.uid, name: name.trim());
      }
      if (!existing.emailVerified) await existing.sendEmailVerification();
    } catch (_) {
      // Never delete a pre-existing identity during reconciliation.
      try {
        await auth.signOut();
      } catch (_) {}
      throw const AccountFailure();
    }
  }

  Future<void> _handleFailedSignup(User? created, bool recorded) async {
    if (created != null && !recorded) {
      try {
        await created.delete();
      } catch (_) {
        /* Deny private access if cleanup fails. */
      }
    }
    if (!recorded) {
      try {
        await auth.signOut();
      } catch (_) {
        /* No local grant. */
      }
      throw const AccountFailure();
    }
    // Account and evidence exist; the confirmation screen supports resend.
  }

  @override
  Future<void> confirmEmail({
    required String email,
    required String code,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null ||
          user.email?.trim().toLowerCase() != email.trim().toLowerCase()) {
        throw const AccountFailure();
      }
      await user.reload();
      if (auth.currentUser?.emailVerified != true) throw const AccountFailure();
      await signOut();
    } catch (_) {
      throw const AccountFailure();
    }
  }

  @override
  Future<void> resendConfirmation(String email) async {
    try {
      final user = auth.currentUser;
      if (user == null ||
          user.email?.trim().toLowerCase() != email.trim().toLowerCase()) {
        throw const AccountFailure();
      }
      await user.sendEmailVerification();
    } catch (_) {
      throw const AccountFailure();
    }
  }

  @override
  Future<void> requestRecovery(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      // Preserve the same public outcome for an unknown email address.
      if (error.code != 'user-not-found') throw const AccountFailure();
    } catch (_) {
      throw const AccountFailure();
    }
  }

  @override
  Future<void> signOut() async {
    _sessionRevision++;
    _session = null;
    try {
      await auth.signOut();
    } catch (_) {
      throw const AccountFailure();
    }
  }
}
