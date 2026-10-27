import '../application/account_state.dart';
import 'account_models.dart';

abstract interface class AccountRepository {
  AccountSession? get currentSession;
  Stream<AccountSession?> get sessionChanges;
  Future<TreatmentPolicy?> loadPolicy();
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String policyVersion,
  });
  Future<void> confirmEmail({required String email, required String code});
  Future<void> resendConfirmation(String email);
  Future<AccountSession?> signIn({
    required String email,
    required String password,
  });
  Future<void> requestRecovery(String email);
  Future<void> verifyRecovery({required String email, required String code});
  Future<void> changePassword(String password);
  Future<void> signOut();
}
