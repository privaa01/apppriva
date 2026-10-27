import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/account_errors.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';

import 'fake_account_repository.dart';

void main() {
  late FakeAccountRepository repo;
  late AccountController controller;
  setUp(() async {
    repo = FakeAccountRepository();
    controller = AccountController(repo, allowTestPolicy: true);
    await controller.initialize();
  });
  tearDown(() {
    controller.dispose();
    repo.dispose();
  });
  test(
    'valid registration requires authorization and stays unprivileged',
    () async {
      expect(
        await controller.register(
          name: 'Mariana',
          email: 'persona@example.test',
          password: 'Synthetic123!',
          accepted: false,
        ),
        isFalse,
      );
      expect(repo.signupCalls, 0);
      expect(
        await controller.register(
          name: 'Mariana',
          email: 'persona@example.test',
          password: 'Synthetic123!',
          accepted: true,
        ),
        isTrue,
      );
      expect(controller.state.phase, AccountPhase.pendingVerification);
      expect(controller.state.canAccessPrivate, isFalse);
    },
  );
  test('normal password login can enter protected app', () async {
    expect(
      await controller.signIn(
        email: 'persona@example.test',
        password: 'Synthetic123!',
      ),
      isTrue,
    );
    expect(controller.state.canAccessPrivate, isTrue);
  });
  test('OTP-only login cannot enter protected app', () async {
    repo.otpLogin = true;
    expect(
      await controller.signIn(
        email: 'persona@example.test',
        password: 'Synthetic123!',
      ),
      isFalse,
    );
    expect(controller.state.canAccessPrivate, isFalse);
    expect(controller.state.error, signInFailureMessage);
  });
  test('untrusted auth event alone never unlocks navigation', () async {
    repo.changes.add(
      const AccountSession(
        userId: 'other',
        emailVerified: true,
        passwordAuthenticated: true,
      ),
    );
    expect(controller.state.canAccessPrivate, isFalse);
  });
  test('recovery completes only into visitor, never automatic login', () async {
    expect(await controller.requestRecovery('persona@example.test'), isTrue);
    expect(await controller.verifyRecovery('123456'), isTrue);
    expect(controller.state.phase, AccountPhase.recovering);
    expect(await controller.changePassword('Synthetic456!'), isTrue);
    expect(controller.state.phase, AccountPhase.visitor);
    expect(repo.signOutCalls, greaterThan(0));
  });
  test('concurrent signup submission does not duplicate operation', () async {
    final pending = Completer<void>();
    repo.delay = () => pending.future;
    final one = controller.register(
      name: 'Mariana',
      email: 'persona@example.test',
      password: 'Synthetic123!',
      accepted: true,
    );
    final two = await controller.register(
      name: 'Mariana',
      email: 'persona@example.test',
      password: 'Synthetic123!',
      accepted: true,
    );
    expect(two, isFalse);
    expect(repo.signupCalls, 1);
    pending.complete();
    expect(await one, isTrue);
  });
  test(
    'late sign-in result after navigation reset cannot grant access',
    () async {
      final pending = Completer<void>();
      repo.delay = () => pending.future;
      final action = controller.signIn(
        email: 'persona@example.test',
        password: 'Synthetic123!',
      );
      controller.resetToVisitor();
      pending.complete();
      expect(await action, isFalse);
      expect(controller.state.canAccessPrivate, isFalse);
    },
  );
  test('public and protected route permissions remain separate', () {
    for (final route in [
      '/tips',
      '/tips/passwords',
      '/tips/sharing',
      '/tips/links',
      '/tips/profiles',
    ]) {
      expect(canOpenDestination(route, const AccountState()), isTrue);
    }
    for (final route in [
      '/home',
      '/profile',
      '/chat',
      '/questionnaire',
      '/results',
    ]) {
      expect(canOpenDestination(route, const AccountState()), isFalse);
    }
  });
  test('production cannot register using a synthetic policy', () async {
    final production = AccountController(repo);
    await production.initialize();
    expect(
      await production.register(
        name: 'Mariana',
        email: 'persona@example.test',
        password: 'Synthetic123!',
        accepted: true,
      ),
      isFalse,
    );
    expect(repo.signupCalls, 0);
    production.dispose();
  });
}
