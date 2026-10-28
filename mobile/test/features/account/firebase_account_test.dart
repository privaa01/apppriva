import 'package:firebase_auth/firebase_auth.dart';
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
    'SDK event never grants access and code recovery stays blocked',
    () async {
      final repo = FirebaseAccountRepository(Auth(Identity()));
      expect(await repo.sessionChanges.first, isNull);
      expect(await repo.loadPolicy(), isNull);
      await expectLater(
        repo.requestRecovery('test@example.test'),
        throwsA(isA<AccountFailure>()),
      );
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
