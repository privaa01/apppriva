import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';

import 'support/real_backend.dart';

void main() {
  test('real registration requires consent, confirms via delivered local code, then password login', () async {
    final b = RealBackend();
    await b.start();
    addTearDown(b.close);
    expect(
      await b.controller.register(
        name: 'Persona',
        email: b.email,
        password: RealBackend.password,
        accepted: false,
      ),
      isFalse,
    );
    expect((await b.control('counts'))['accounts'], 0);
    await b.signup();
    expect(b.controller.state.phase, AccountPhase.pendingVerification);
    expect(b.controller.state.canAccessPrivate, isFalse);
    expect(
      await b.controller.signIn(email: b.email, password: RealBackend.password),
      isFalse,
    );
    await b.controller.register(
      name: 'Persona sintética',
      email: b.email,
      password: RealBackend.password,
      accepted: true,
    ); // Retry may be rate limited but cannot duplicate identity.
    final counts = await b.control('counts');
    expect(counts['accounts'], 1);
    expect(counts['profiles'], 1);
    expect(counts['evidence'], 1);
    expect(await b.controller.confirm(await b.code()), isTrue);
    await b.login();
    expect(b.controller.state.canAccessPrivate, isTrue);
  });
  test(
    'lost signup acknowledgement can be retried without duplicate records',
    () async {
      final b = RealBackend();
      await b.start();
      addTearDown(b.close);
      await b.control('lose-next-signup');
      expect(
        await b.controller.register(
          name: 'Persona',
          email: b.email,
          password: RealBackend.password,
          accepted: true,
        ),
        isFalse,
      );
      await b.controller.register(
        name: 'Persona',
        email: b.email,
        password: RealBackend.password,
        accepted: true,
      );
      final counts = await b.control('counts');
      expect(counts['accounts'], 1);
      expect(counts['profiles'], 1);
      expect(counts['evidence'], 1);
      expect(b.controller.state.canAccessPrivate, isFalse);
    },
  );
  test(
    'real authorization failure rolls back account, profile and evidence',
    () async {
      final b = RealBackend();
      await b.start();
      addTearDown(b.close);
      await b.control('fail-evidence');
      try {
        expect(
          await b.controller.register(
            name: 'Persona',
            email: b.email,
            password: RealBackend.password,
            accepted: true,
          ),
          isFalse,
        );
        final counts = await b.control('counts');
        expect(counts['accounts'], 0);
        expect(counts['profiles'], 0);
        expect(counts['evidence'], 0);
      } finally {
        await b.control('restore-evidence');
      }
    },
  );
}
