import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/navigation/application/navigation_controller.dart';
import 'package:priva_mobile/features/profile/data/profile_details.dart';

import '../test/features/profile/profile_test_fixtures.dart';
import '../test/features/navigation/temporary_journey_navigation_test.dart'
    show SyntheticJourney;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'synthetic navigation monotonic timing, 20 samples per operation',
    (tester) async {
      final h = await ProfileHarness.create();
      final journey = SyntheticJourney();
      final samples = <String, List<int>>{};
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          initialRoute: '/home',
          testMode: true,
          temporaryJourney: journey,
          profileRepository: h.repository,
        ),
      );
      await tester.pumpAndSettle();
      Future<void> measure(
        String scenario,
        String label, {
        bool card = false,
      }) async {
        final target = card
            ? find.byKey(const ValueKey('home./tips'))
            : find.widgetWithText(TextButton, label);
        await tester.ensureVisible(target);
        final watch = Stopwatch()..start();
        await tester.tap(target);
        await tester.pump();
        final feedback = watch.elapsedMicroseconds;
        await tester.pumpAndSettle();
        watch.stop();
        samples.putIfAbsent('$scenario.feedback_us', () => []).add(feedback);
        samples
            .putIfAbsent('$scenario.resolved_us', () => [])
            .add(watch.elapsedMicroseconds);
        expect(feedback, lessThanOrEqualTo(1000000), reason: scenario);
        expect(
          watch.elapsedMicroseconds,
          lessThanOrEqualTo(15000000),
          reason: scenario,
        );
      }

      NavigationController nav() =>
          NavigationScope.maybeOf(tester.element(find.byType(Scaffold).first))!;
      BuildContext context() => tester.element(find.byType(Scaffold).first);
      for (var i = 0; i < 20; i++) {
        await measure('new_section', 'Tips');
        await measure('existing_section', 'Inicio');
        await measure('reselection', 'Inicio');
        await measure('new_section_card', 'Tips', card: true);
        await measure('existing_after_card', 'Inicio');
        await nav().navigate(context(), '/questionnaire');
        await tester.pumpAndSettle();
        journey.start();
        await tester.tap(find.widgetWithText(TextButton, 'Tips'));
        await tester.pumpAndSettle();
        // Human dwell time is intentionally excluded.
        await measure('confirmed_exit', 'Salir');
        await measure('existing_after_exit', 'Inicio');
      }
      for (final failure in [false, true]) {
        h.repository.loader = (uid) async {
          await Future<void>.delayed(const Duration(milliseconds: 200));
          if (failure) {
            throw const FormatException('Synthetic unavailable profile');
          }
          return ProfileDetails(
            uid: uid,
            name: 'Persona sintética',
            email: 'owner@example.test',
          );
        };
        for (var i = 0; i < 20; i++) {
          await measure(
            failure ? 'profile_error_simulated' : 'profile_delay_simulated',
            'Perfil',
          );
          await measure(
            failure ? 'return_from_profile_error' : 'return_from_profile_delay',
            'Inicio',
          );
        }
      }
      await h.account.signOut();
      await tester.pumpAndSettle();
      for (var i = 0; i < 20; i++) {
        await measure('denied', 'Perfil');
      }
      binding.reportData = {
        'scope':
            'synthetic navigation; no provider latency or participant data',
        'samples': samples,
      };
      debugPrint(jsonEncode(binding.reportData));
      await tester.pumpWidget(const SizedBox());
      journey.dispose();
      h.dispose();
    },
  );
}
