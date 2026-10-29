import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/account_errors.dart';
import 'package:priva_mobile/app/firebase_config.dart';
import 'package:priva_mobile/features/account/data/firebase_account_repository.dart';
import 'package:priva_mobile/features/account/data/firebase_registration_store.dart';
import 'package:priva_mobile/features/account/data/priva_treatment_policy.dart';

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
  bool deleted = false;
  bool mailFails = false;
  int verificationEmails = 0;
  @override
  String? get email => 'test@example.test';
  @override
  Future<void> reload() async {}
  @override
  Future<void> sendEmailVerification([ActionCodeSettings? settings]) async {
    verificationEmails++;
    if (mailFails) throw Exception('synthetic mail failure');
  }

  @override
  Future<void> delete() async {
    deleted = true;
  }

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
  String? signupFailure;
  Identity? created;
  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (signupFailure != null) {
      throw FirebaseAuthException(code: signupFailure!);
    }
    created = Identity(verified: false);
    user = created;
    return Credential(user);
  }

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

class Store implements AccountRegistrationStore {
  bool recorded = false;
  bool failWrite = false;
  bool loseAcknowledgement = false;
  String? name;
  @override
  Future<void> create({required String uid, required String name}) async {
    if (failWrite) throw Exception('write rejected');
    recorded = true;
    this.name = name;
    if (loseAcknowledgement) throw Exception('lost acknowledgement');
  }

  @override
  Future<bool> hasAuthorization(String uid) async => recorded;
  @override
  Future<String?> profileName(String uid) async => name ?? 'Prueba';
}

void main() {
  testWidgets(
    'native signup is available and confirmation uses an email link',
    (tester) async {
      final auth = Auth(null);
      final store = Store();
      final controller = AccountController(
        FirebaseAccountRepository(auth, registrationStore: store),
      );
      await controller.initialize();
      await tester.pumpWidget(
        PrivaApp(controller: controller, initialRoute: '/signup'),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('El registro no está disponible'),
        findsNothing,
      );
      await tester.enterText(find.byKey(const Key('signup.name')), 'Prueba');
      await tester.enterText(
        find.byKey(const Key('signup.email')),
        'test@example.test',
      );
      await tester.enterText(
        find.byKey(const Key('signup.password')),
        'synthetic-password',
      );
      await tester.ensureVisible(find.byKey(const Key('signup.policy')));
      await tester.tap(find.byKey(const Key('signup.policy')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('signup.consent')));
      await tester.tap(find.byKey(const Key('signup.consent')));
      await tester.ensureVisible(find.byKey(const Key('signup.submit')));
      await tester.tap(find.byKey(const Key('signup.submit')));
      await tester.pumpAndSettle();
      expect(store.recorded, isTrue);
      expect(auth.created?.verificationEmails, 1);
      expect(find.byKey(const Key('confirm.code')), findsNothing);
      expect(find.text('Ya verifiqué mi correo'), findsOneWidget);
      expect(controller.state.canAccessPrivate, isFalse);
      auth.user = Identity();
      await tester.ensureVisible(find.byKey(const Key('confirm.submit')));
      await tester.tap(find.byKey(const Key('confirm.submit')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('signin.submit')), findsOneWidget);
      expect(controller.state.canAccessPrivate, isFalse);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  test('registration records consent and sends verification without granting access', () async {
    final auth = Auth(null);
    final store = Store();
    final repo = FirebaseAccountRepository(auth, registrationStore: store);
    final controller = AccountController(repo);
    await controller.initialize();
    expect(controller.policy?.body, contains('priva202611@gmail.com'));
    expect(controller.policy?.isTest, isFalse);
    expect(
      await controller.register(
        name: 'Prueba',
        email: 'test@example.test',
        password: 'synthetic-password',
        accepted: false,
      ),
      isFalse,
    );
    expect(auth.created, isNull);
    expect(
      await controller.register(
        name: 'Prueba',
        email: 'test@example.test',
        password: 'synthetic-password',
        accepted: true,
      ),
      isTrue,
    );
    expect(store.recorded, isTrue);
    expect(store.name, 'Prueba');
    expect(auth.created?.verificationEmails, 1);
    expect(controller.state.canAccessPrivate, isFalse);
    expect(await controller.confirm(''), isFalse);
    controller.dispose();
  });
  test(
    'repeated signup does not disclose account existence or overwrite evidence',
    () async {
      final auth = Auth(null)..signupFailure = 'email-already-in-use';
      final store = Store();
      final repo = FirebaseAccountRepository(auth, registrationStore: store);
      await repo.signUp(
        name: 'Prueba',
        email: 'test@example.test',
        password: 'synthetic-password',
        policyVersion: privaPolicyVersion,
      );
      expect(store.recorded, isFalse);
      expect(repo.currentSession, isNull);
    },
  );
  test('evidence failure compensates identity and denies access', () async {
    final auth = Auth(null);
    final store = Store()..failWrite = true;
    final repo = FirebaseAccountRepository(auth, registrationStore: store);
    await expectLater(
      repo.signUp(
        name: 'Prueba',
        email: 'test@example.test',
        password: 'synthetic-password',
        policyVersion: privaPolicyVersion,
      ),
      throwsA(isA<AccountFailure>()),
    );
    expect(auth.created?.deleted, isTrue);
    expect(auth.currentUser, isNull);
    expect(repo.currentSession, isNull);
  });
  test('lost write acknowledgement preserves recorded identity', () async {
    final auth = Auth(null);
    final store = Store()..loseAcknowledgement = true;
    final repo = FirebaseAccountRepository(auth, registrationStore: store);
    await repo.signUp(
      name: 'Prueba',
      email: 'test@example.test',
      password: 'synthetic-password',
      policyVersion: privaPolicyVersion,
    );
    expect(store.recorded, isTrue);
    expect(auth.created?.deleted, isFalse);
    expect(auth.created?.verificationEmails, 1);
    expect(repo.currentSession, isNull);
  });
  test(
    'verification requires actual Firebase verified state and then signs out',
    () async {
      final auth = Auth(Identity());
      final repo = FirebaseAccountRepository(
        auth,
        registrationStore: Store()..recorded = true,
      );
      await repo.confirmEmail(email: 'test@example.test', code: '');
      expect(auth.currentUser, isNull);
      expect(repo.currentSession, isNull);
    },
  );
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
    final repo = FirebaseAccountRepository(
      Auth(Identity()),
      registrationStore: Store()..recorded = true,
    );
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
      final repo = FirebaseAccountRepository(
        auth,
        registrationStore: Store()..recorded = user.ready,
      );
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
