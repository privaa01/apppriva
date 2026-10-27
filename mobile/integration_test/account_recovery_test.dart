import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';

import 'support/real_backend.dart';

void main() {
  test('real recovery uses email code, rejects wrong/reused code and requires fresh login', () async {
    final b = RealBackend();
    await b.start();
    addTearDown(b.close);
    await b.verified();
    expect(await b.controller.requestRecovery(b.email), isTrue);
    final code = await b.code();
    expect(
      await b.controller.verifyRecovery(code == '000000' ? '111111' : '000000'),
      isFalse,
    );
    expect(await b.controller.verifyRecovery(code), isTrue);
    expect(b.controller.state.phase, AccountPhase.recovering);
    expect(b.controller.state.canAccessPrivate, isFalse);
    expect(await b.controller.changePassword('short'), isFalse);
    await expectLater(
      b.repository.changePassword('12345678901'),
      throwsA(anything),
    );
    expect(await b.controller.changePassword('UpdatedSynthetic456!'), isTrue);
    expect(b.repository.currentSession, isNull);
    expect(
      await b.controller.signIn(email: b.email, password: RealBackend.password),
      isFalse,
    );
    expect(
      await b.controller.signIn(
        email: b.email,
        password: 'UpdatedSynthetic456!',
      ),
      isTrue,
    );
    await b.controller.signOut();
    await expectLater(
      b.repository.verifyRecovery(email: b.email, code: code),
      throwsA(anything),
    );
  });
  test(
    'real provider enforces 600-second expiration and 60-second resend',
    () async {
      final b = RealBackend();
      await b.start();
      addTearDown(b.close);
      await b.verified();
      await b.repository.requestRecovery(b.email);
      final code = await b.code();
      await expectLater(
        b.repository.requestRecovery(b.email),
        throwsA(anything),
      );
      await b.control('expire-code');
      await expectLater(
        b.repository.verifyRecovery(email: b.email, code: code),
        throwsA(anything),
      );
      expect(b.controller.state.canAccessPrivate, isFalse);
    },
  );
}
