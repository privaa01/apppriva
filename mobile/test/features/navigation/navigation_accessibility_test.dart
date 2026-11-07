import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';

import '../profile/profile_test_fixtures.dart';

void main() {
  testWidgets(
    'direct protected route renders access without a selected private section',
    (tester) async {
      final h = await ProfileHarness.create();
      await h.account.signOut();
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        PrivaApp(controller: h.account, initialRoute: '/profile'),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('signin.submit')), findsOneWidget);
      for (final label in [
        'Inicio',
        'Perfil',
        'Tips',
        'Zyro',
        'Cuestionario',
      ]) {
        expect(
          tester
              .getSemantics(find.widgetWithText(TextButton, label))
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          Tristate.isFalse,
        );
      }
      semantics.dispose();
      await tester.pumpWidget(const SizedBox());
      h.dispose();
    },
  );

  for (final size in [const Size(320, 720), const Size(412, 915)]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'P01 navigation ${size.width} labels targets contrast and text $scale',
        (tester) async {
          final h = await ProfileHarness.create();
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final semantics = tester.ensureSemantics();
          await tester.pumpWidget(
            PrivaApp(
              controller: h.account,
              initialRoute: '/home',
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          for (final label in [
            'Inicio',
            'Perfil',
            'Tips',
            'Zyro',
            'Cuestionario',
          ]) {
            final buttons = find.widgetWithText(TextButton, label);
            expect(buttons.hitTestable(), findsOneWidget);
          }
          expect(
            tester
                .getSemantics(find.widgetWithText(TextButton, 'Inicio'))
                .getSemanticsData()
                .flagsCollection
                .isSelected,
            Tristate.isTrue,
          );
          semantics.dispose();
          await tester.pumpWidget(const SizedBox());
          h.dispose();
        },
      );
    }
  }
}
