import '../../../app/account_errors.dart';
import '../application/account_state.dart';
import 'account_models.dart';
import 'account_repository.dart';

class UnavailableAccountRepository implements AccountRepository {
  @override
  AccountSession? get currentSession => null;
  @override
  Stream<AccountSession?> get sessionChanges => const Stream.empty();
  @override
  Future<TreatmentPolicy?> loadPolicy() async => null;
  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String policyVersion,
  }) async => throw const AccountFailure();
  @override
  Future<void> confirmEmail({
    required String email,
    required String code,
  }) async => throw const AccountFailure();
  @override
  Future<void> resendConfirmation(String email) async =>
      throw const AccountFailure();
  @override
  Future<AccountSession?> signIn({
    required String email,
    required String password,
  }) async => throw const AccountFailure();
  @override
  Future<void> requestRecovery(String email) async =>
      throw const AccountFailure();
  @override
  Future<void> verifyRecovery({
    required String email,
    required String code,
  }) async => throw const AccountFailure();
  @override
  Future<void> changePassword(String password) async =>
      throw const AccountFailure();
  @override
  Future<void> signOut() async {}
}
