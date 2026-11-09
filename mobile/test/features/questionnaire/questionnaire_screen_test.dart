import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/questionnaire/application/questionnaire_controller.dart';
import 'package:priva_mobile/features/questionnaire/domain/question_selector.dart';

import '../profile/profile_test_fixtures.dart';
import 'questionnaire_test_fixtures.dart';

void main() {
  for (final size in [const Size(320, 720), const Size(412, 915)]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('P08 funciona a ${size.width} y texto $scale', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final harness = await ProfileHarness.create();
        final connectivity = FakeConnectivity();
        final questionnaire = QuestionnaireController(
          FakeBankRepository(),
          connectivity,
          selector: QuestionSelector(random: Random(8)),
        );
        await tester.pumpWidget(
          PrivaApp(
            controller: harness.account,
            temporaryJourney: questionnaire,
            initialRoute: '/questionnaire',
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
          ),
        );
        expect(find.text('Antes de comenzar'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Comenzar'),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('Comenzar'));
        await tester.pumpAndSettle();
        expect(find.text('Pregunta 1 de 10'), findsOneWidget);
        expect(find.byType(InkWell), findsWidgets);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        questionnaire.dispose();
        connectivity.dispose();
        harness.dispose();
      });
    }
  }

  testWidgets('P08 pausa y reanuda sin cambiar la pregunta', (tester) async {
    final harness = await ProfileHarness.create();
    final connectivity = FakeConnectivity();
    final questionnaire = QuestionnaireController(
      FakeBankRepository(),
      connectivity,
      selector: QuestionSelector(random: Random(2)),
    );
    await tester.pumpWidget(
      PrivaApp(
        controller: harness.account,
        temporaryJourney: questionnaire,
        initialRoute: '/questionnaire',
      ),
    );
    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();
    final prompt = questionnaire.activeAttempt!.current.question.prompt;
    expect(find.text(prompt), findsOneWidget);
    connectivity.setAvailable(false);
    await tester.pump();
    expect(find.text('Cuestionario en pausa'), findsOneWidget);
    connectivity.setAvailable(true);
    await tester.pump();
    expect(find.text(prompt), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    questionnaire.dispose();
    connectivity.dispose();
    harness.dispose();
  });
}
