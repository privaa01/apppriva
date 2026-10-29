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
    implements EmailLinkRecovery, EmailLinkVerification {
  FirebaseAccountRepository(this.auth, {this.registrationStore});
  final AccountRegistrationStore? registrationStore;
  final FirebaseAuth auth;
  AccountSession? _session;

  @override
  AccountSession? get currentSession => _session;

  @override
  Stream<AccountSession?> get sessionChanges => auth.idTokenChanges().asyncMap((
    user,
  ) async {
    // Events may revoke access but cannot establish a new private session.
    final existing = _session;
    if (existing == null) return null;
    try {
      if (user == null || !user.emailVerified || user.uid != existing.userId) {
        _session = null;
        return null;
      }
      final token = await user.getIdTokenResult();
      if (token.signInProvider != 'password' ||
          await registrationStore?.hasAuthorization(user.uid) != true) {
        _session = null;
      }
    } catch (_) {
      _session = null;
    }
    return _session;
  });

  @override
  Future<AccountSession?> signIn({
    required String email,
    required String password,
  }) async {
    _session = null;
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user == null || !user.emailVerified) throw const AccountFailure();
      final token = await user.getIdTokenResult(true);
      // Evidence is checked against the server; editable identity metadata is not authority.
      if (token.signInProvider != 'password' ||
          await registrationStore?.hasAuthorization(user.uid) != true ||
          auth.currentUser?.uid != user.uid) {
        throw const AccountFailure();
      }
      return _session = AccountSession(
        userId: user.uid,
        emailVerified: true,
        passwordAuthenticated: true,
        displayName: await registrationStore!.profileName(user.uid),
      );
    } catch (_) {
      _session = null;
      try {
        await auth.signOut();
      } catch (_) {
        // No raw provider exceptions or credentials leave this adapter.
      }
      throw const AccountFailure();
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
      if (created == null && error.code == 'email-already-in-use') return;
      await _handleFailedSignup(created, recorded);
    } catch (_) {
      await _handleFailedSignup(created, recorded);
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
      if (user == null || user.email != email) throw const AccountFailure();
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
      if (user == null || user.email != email) throw const AccountFailure();
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
    _session = null;
    try {
      await auth.signOut();
    } catch (_) {
      throw const AccountFailure();
    }
  }
}
