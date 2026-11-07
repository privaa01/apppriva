import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/navigation/application/navigation_controller.dart';
import 'package:priva_mobile/features/questionnaire/application/questionnaire_controller.dart';
import 'package:priva_mobile/features/questionnaire/application/result_controller.dart';
import 'package:priva_mobile/features/questionnaire/presentation/result_screen.dart';

import '../profile/profile_test_fixtures.dart';
import 'questionnaire_test_fixtures.dart';
import 'result_test_fixtures.dart';

void main() {
  for (final size in [const Size(320, 720), const Size(412, 915)]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('P09 funciona a ${size.width} y texto $scale', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final harness = await ProfileHarness.create();
        final connectivity = FakeConnectivity();
        final journey = QuestionnaireController(
          FakeBankRepository(),
          connectivity,
        );
        await journey.start();
        for (var index = 0; index < 10; index++) {
          journey.select(
            journey.activeAttempt!.current.question.options.first.id,
          );
          journey.continueAttempt();
        }
        final result = ResultController(journey, FakeResultRepository())
          ..initialize();
        await result.load();
        expect(result.phase, ResultPhase.ready);
        final navigation = NavigationController(harness.account, journey);
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData().copyWith(
                textScaler: TextScaler.linear(scale),
              ),
              child: ResultScreen(
                account: harness.account,
                questionnaire: journey,
                controller: result,
                navigation: navigation,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.textContaining('Nivel '), findsOneWidget);
        expect(find.text('Prioridades para mejorar'), findsOneWidget);
        expect(
          find.textContaining('No mide la probabilidad real'),
          findsOneWidget,
        );
        await tester.scrollUntilVisible(
          find.byKey(const Key('result.repeat')),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.byKey(const Key('result.repeat')), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        result.dispose();
        navigation.dispose();
        journey.dispose();
        connectivity.dispose();
        harness.dispose();
      });
    }
  }
}
