import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/navigation/data/temporary_journey.dart';

import '../profile/profile_test_fixtures.dart';
import 'temporary_journey_navigation_test.dart' show SyntheticJourney;

void main() {
  testWidgets(
    'background discards synthetic state, keeps account and rejects stale dialog',
    (tester) async {
      final h = await ProfileHarness.create();
      final journey = SyntheticJourney()..start();
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          temporaryJourney: journey,
          initialRoute: '/questionnaire',
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tips').first);
      await tester.pumpAndSettle();
      expect(find.text('¿Quieres salir?'), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      expect(journey.phase, JourneyPhase.attempt);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pumpAndSettle();
      expect(journey.phase, JourneyPhase.idle);
      expect(journey.discarded, 1);
      expect(h.account.state.canAccessPrivate, isTrue);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(journey.phase, JourneyPhase.idle);
      expect(find.text('¿Quieres salir?'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      journey.dispose();
      h.dispose();
    },
  );
}
