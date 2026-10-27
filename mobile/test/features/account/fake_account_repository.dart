import 'dart:async';

import 'package:priva_mobile/features/account/application/account_state.dart';
import 'package:priva_mobile/features/account/data/account_models.dart';
import 'package:priva_mobile/features/account/data/account_repository.dart';

class FakeAccountRepository implements AccountRepository {
  final changes = StreamController<AccountSession?>.broadcast(sync: true);
  AccountSession? session;
  TreatmentPolicy? policy = const TreatmentPolicy(
    version: 'synthetic-v1',
    body: 'Política de prueba: usa solo datos ficticios.',
    purposes: ['Saludo', 'Identificación y recuperación'],
    isTest: true,
  );
  bool fail = false;
  bool otpLogin = false;
  int signupCalls = 0;
  int recoveryCalls = 0;
  int signOutCalls = 0;
  Future<void> Function()? delay;
  @override
  AccountSession? get currentSession => session;
  @override
  Stream<AccountSession?> get sessionChanges => changes.stream;
  @override
  Future<TreatmentPolicy?> loadPolicy() async => policy;
  Future<void> operation() async {
    if (delay != null) await delay!();
    if (fail) throw StateError('synthetic provider failure');
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String policyVersion,
  }) async {
    signupCalls++;
    await operation();
  }

  @override
  Future<void> confirmEmail({
    required String email,
    required String code,
  }) async {
    await operation();
    session = const AccountSession(
      userId: 'synthetic',
      emailVerified: true,
      passwordAuthenticated: false,
    );
    changes.add(session);
  }

  @override
  Future<void> resendConfirmation(String email) => operation();
  @override
  Future<AccountSession?> signIn({
    required String email,
    required String password,
  }) async {
    await operation();
    session = AccountSession(
      userId: 'synthetic',
      emailVerified: true,
      passwordAuthenticated: !otpLogin,
      displayName: 'Mariana',
    );
    changes.add(session);
    return session;
  }

  @override
  Future<void> requestRecovery(String email) async {
    recoveryCalls++;
    await operation();
  }

  @override
  Future<void> verifyRecovery({
    required String email,
    required String code,
  }) async {
    await operation();
    session = const AccountSession(
      userId: 'synthetic',
      emailVerified: true,
      passwordAuthenticated: false,
    );
    changes.add(session);
  }

  @override
  Future<void> changePassword(String password) => operation();
  @override
  Future<void> signOut() async {
    signOutCalls++;
    session = null;
    changes.add(null);
  }

  void dispose() {
    changes.close();
  }
}
