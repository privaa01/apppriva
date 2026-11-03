import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:priva_mobile/app/priva_app.dart';

import '../test/features/profile/profile_test_fixtures.dart';
import '../test/features/navigation/navigation_screen_test.dart' as access;
import '../test/features/navigation/navigation_controller_test.dart' as history;
import '../test/features/navigation/navigation_profile_test.dart' as profile;
import '../test/features/navigation/temporary_journey_navigation_test.dart'
    as journey;
import '../test/features/navigation/navigation_lifecycle_test.dart'
    as lifecycle;

// Runs the same contracts rendered on Android. All identities and journeys are
// synthetic; injected lifecycle events are not evidence of pressing Android Home.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  access.main();
  history.main();
  profile.main();
  journey.main();
  lifecycle.main();
  testWidgets(
    'synthetic native sign out keeps Tips public and private history absent',
    (tester) async {
      final h = await ProfileHarness.create();
      await tester.pumpWidget(
        PrivaApp(controller: h.account, initialRoute: '/home', testMode: true),
      );
      await tester.pumpAndSettle();
      await h.account.signOut();
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('signin.submit')), findsOneWidget);
      await tester.tap(find.text('Tips'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('signin.submit')), findsNothing);
      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('signin.submit')), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      h.dispose();
    },
  );
}
