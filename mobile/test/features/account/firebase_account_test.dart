import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/account_errors.dart';
import 'package:priva_mobile/app/firebase_config.dart';
import 'package:priva_mobile/features/account/data/firebase_account_repository.dart';

class Token extends Fake implements IdTokenResult {
  Token(this.ready);
  final bool ready;
  @override
  String? get signInProvider => 'password';
  @override
  Map<String, dynamic>? get claims => {'priva_account_ready': ready};
}

class Identity extends Fake implements User {
  Identity({this.verified = true, this.ready = true});
  final bool verified, ready;
  @override
  String get uid => 'synthetic';
  @override
  bool get emailVerified => verified;
  @override
  String? get displayName => 'Prueba';
  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async =>
      Token(ready);
}

class Credential extends Fake implements UserCredential {
  Credential(this.user);
  @override
  final User? user;
}

class Auth extends Fake implements FirebaseAuth {
  Auth(this.user);
  User? user;
  String? resetEmail;
  String? resetFailure;
  @override
  Future<void> sendPasswordResetEmail({
    required String email,
    ActionCodeSettings? actionCodeSettings,
  }) async {
    resetEmail = email;
    if (resetFailure != null) {
      throw FirebaseAuthException(
        code: resetFailure!,
        message: "private provider details",
      );
    }
  }

  @override
  User? get currentUser => user;
  @override
  Stream<User?> idTokenChanges() => Stream.value(user);
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async => Credential(user);
  @override
  Future<void> signOut() async {
    user = null;
  }
}

void main() {
  testWidgets('native recovery shows link instructions without code fields', (
    tester,
  ) async {
    final auth = Auth(null);
    final controller = AccountController(FirebaseAccountRepository(auth));
    await controller.initialize();
    await tester.pumpWidget(
      PrivaApp(controller: controller, initialRoute: '/recovery'),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('recovery.email')),
      'test@example.test',
    );
    await tester.ensureVisible(find.byKey(const Key('recovery.submit')));
    await tester.tap(find.byKey(const Key('recovery.submit')));
    await tester.pumpAndSettle();
    expect(auth.resetEmail, 'test@example.test');
    expect(find.byKey(const Key('recovery.code')), findsNothing);
    expect(find.byKey(const Key('recovery.password')), findsNothing);
    expect(find.text('Reenviar enlace'), findsOneWidget);
    expect(controller.state.canAccessPrivate, isFalse);
    await tester.tap(find.text('Reenviar enlace'));
    await tester.pumpAndSettle();
    expect(
      find.text('Espera un minuto antes de pedir otro enlace.'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
  test('native reset sends email without granting a session', () async {
    final auth = Auth(null);
    final repo = FirebaseAccountRepository(auth);
    await repo.requestRecovery('test@example.test');
    expect(auth.resetEmail, 'test@example.test');
    expect(repo.currentSession, isNull);
    auth.resetFailure = 'user-not-found';
    await repo.requestRecovery('missing@example.test');
    auth.resetFailure = 'network-request-failed';
    await expectLater(
      repo.requestRecovery('test@example.test'),
      throwsA(isA<AccountFailure>()),
    );
  });
  test('missing Firebase configuration fails closed', () {
    expect(FirebaseConfig.fromEnvironment().isConfigured, isFalse);
    expect(
      const FirebaseConfig(
        apiKey: 'test',
        appId: '1:123:android:abc',
        projectId: 'priva-test',
        messagingSenderId: '123',
      ).isConfigured,
      isTrue,
    );
    expect(
      const FirebaseConfig(
        apiKey: 'test',
        appId: '1:999:ios:abc',
        projectId: 'priva-test',
        messagingSenderId: '123',
      ).isConfigured,
      isFalse,
    );
  });
  test('verified provisioned identity can sign in and sign out', () async {
    final repo = FirebaseAccountRepository(Auth(Identity()));
    final session = await repo.signIn(
      email: 'test@example.test',
      password: 'synthetic',
    );
    expect(session?.canAccessPrivate, isTrue);
    await repo.signOut();
    expect(repo.currentSession, isNull);
  });
  for (final user in [Identity(verified: false), Identity(ready: false)]) {
    test('rejects unverified or unprovisioned identity $user', () async {
      final auth = Auth(user);
      final repo = FirebaseAccountRepository(auth);
      await expectLater(
        repo.signIn(email: 'test@example.test', password: 'synthetic'),
        throwsA(isA<AccountFailure>()),
      );
      expect(repo.currentSession, isNull);
      expect(auth.user, isNull);
    });
  }
  test(
    'SDK events grant no access; legacy code validation stays blocked',
    () async {
      final repo = FirebaseAccountRepository(Auth(Identity()));
      expect(await repo.sessionChanges.first, isNull);
      expect(await repo.loadPolicy(), isNull);
      await repo.requestRecovery('test@example.test');
      await expectLater(
        repo.verifyRecovery(email: 'test@example.test', code: '000000'),
        throwsA(isA<AccountFailure>()),
      );
      await expectLater(
        repo.signUp(
          name: 'Prueba',
          email: 'test@example.test',
          password: 'synthetic',
          policyVersion: 'test',
        ),
        throwsA(isA<AccountFailure>()),
      );
    },
  );
}
