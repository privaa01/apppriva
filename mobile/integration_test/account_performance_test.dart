import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/real_backend.dart';

void main() {
  test(
    'slow real response produces a bounded notice and late login is revoked',
    () async {
      final b = RealBackend();
      await b.start();
      addTearDown(b.close);
      await b.verified();
      await b.control('delay-next-auth');
      final elapsed = Stopwatch()..start();
      expect(
        await b.controller.signIn(
          email: b.email,
          password: RealBackend.password,
        ),
        isFalse,
      );
      expect(elapsed.elapsedMilliseconds, lessThan(15500));
      expect(b.controller.state.canAccessPrivate, isFalse);
      expect(b.controller.state.error, isNotNull);
      await Future<void>.delayed(const Duration(seconds: 2));
      expect(b.controller.state.canAccessPrivate, isFalse);
      expect(b.repository.currentSession, isNull);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    '20 real local registrations meet feedback and response budgets',
    () async {
      final results = <Map<String, Object>>[];
      for (var sample = 1; sample <= 20; sample++) {
        final b = RealBackend();
        await b.start();
        try {
          final elapsed = Stopwatch()..start();
          final action = b.controller.register(
            name: 'Persona sintética',
            email: b.email,
            password: RealBackend.password,
            accepted: true,
          );
          final feedback = elapsed.elapsedMicroseconds;
          expect(b.controller.state.busy, isTrue);
          expect(feedback, lessThanOrEqualTo(1000000));
          final ok = await action;
          final response = elapsed.elapsedMicroseconds;
          expect(ok, isTrue);
          expect(response, lessThanOrEqualTo(15000000));
          results.add({
            'operation': 'registration',
            'profile': 'local_headless',
            'sample': sample,
            'feedback_us': feedback,
            'response_us': response,
            'passed': ok,
          });
        } finally {
          await b.close();
        }
      }
      const path = String.fromEnvironment('PRIVA_METRICS_PATH');
      if (path.isEmpty) {
        throw StateError('Metrics path must be supplied by local runner');
      }
      await File(path).writeAsString(jsonEncode(results));
    },
  );
}
