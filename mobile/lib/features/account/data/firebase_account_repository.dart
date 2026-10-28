import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/account_errors.dart';
import '../application/account_state.dart';
import 'unavailable_account_repository.dart';

/// Partial migration. Enrollment and code recovery deliberately remain disabled
/// until server-side authorization evidence and email-code flows are validated.
class FirebaseAccountRepository extends UnavailableAccountRepository {
  FirebaseAccountRepository(this.auth);
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
          token.claims?['priva_account_ready'] != true) {
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
      // A server-issued claim is required until the provisioning design can
      // prove authorization evidence. User-editable displayName is no authority.
      if (token.signInProvider != 'password' ||
          token.claims?['priva_account_ready'] != true ||
          auth.currentUser?.uid != user.uid) {
        throw const AccountFailure();
      }
      return _session = AccountSession(
        userId: user.uid,
        emailVerified: true,
        passwordAuthenticated: true,
        displayName: user.displayName,
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
  Future<void> signOut() async {
    _session = null;
    try {
      await auth.signOut();
    } catch (_) {
      throw const AccountFailure();
    }
  }
}
