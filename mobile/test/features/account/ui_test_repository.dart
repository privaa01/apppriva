import 'dart:async';

import 'package:priva_mobile/app/account_errors.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';
import 'package:priva_mobile/features/account/data/account_models.dart';
import 'package:priva_mobile/features/account/data/account_repository.dart';

class UiTestRepository implements AccountRepository {
  final changes = StreamController<AccountSession?>.broadcast(sync: true);
  AccountSession? session;
  bool rejectSignIn = false;
  int signups = 0;
  int recoveries = 0;
  @override
  AccountSession? get currentSession => session;
  @override
  Stream<AccountSession?> get sessionChanges => changes.stream;
  @override
  Future<TreatmentPolicy?> loadPolicy() async => const TreatmentPolicy(
    version: 'approved-test',
    body: 'Política para las pruebas sintéticas de cuenta.',
    purposes: ['Identificar la cuenta', 'Recuperar acceso'],
    isTest: false,
  );
  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String policyVersion,
  }) async {
    signups++;
  }

  @override
  Future<void> confirmEmail({
    required String email,
    required String code,
  }) async {
    if (code != '123456') throw const AccountFailure();
  }

  @override
  Future<void> resendConfirmation(String email) async {}
  @override
  Future<AccountSession?> signIn({
    required String email,
    required String password,
  }) async {
    if (rejectSignIn) throw const AccountFailure();
    session = const AccountSession(
      userId: 'synthetic-user',
      emailVerified: true,
      passwordAuthenticated: true,
      displayName: 'Persona',
    );
    changes.add(session);
    return session;
  }

  @override
  Future<void> requestRecovery(String email) async {
    recoveries++;
  }

  @override
  Future<void> verifyRecovery({
    required String email,
    required String code,
  }) async {
    if (code != '123456') throw const AccountFailure();
  }

  @override
  Future<void> changePassword(String password) async {}
  @override
  Future<void> signOut() async {
    session = null;
    changes.add(null);
  }
}
