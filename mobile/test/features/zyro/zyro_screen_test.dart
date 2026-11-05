import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/zyro/domain/zyro_message.dart';

import '../profile/profile_test_fixtures.dart';
import 'zyro_test_fixtures.dart';

void main() {
  testWidgets('P07 sends once, restores failed draft and retries safely', (
    tester,
  ) async {
    final harness = await ProfileHarness.create();
    final repository = ControlledZyroRepository();
    await tester.pumpWidget(
      PrivaApp(
        controller: harness.account,
        initialRoute: '/chat',
        zyroRepository: repository,
      ),
    );
    expect(find.text('Asistente Zyro'), findsOneWidget);
    expect(find.textContaining('No compartas contraseñas'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('zyro.input')),
      'Revisar dispositivos de Google',
    );
    await tester.ensureVisible(find.byKey(const Key('zyro.send')));
    await tester.tap(find.byKey(const Key('zyro.send')));
    await tester.tap(find.byKey(const Key('zyro.send')));
    await tester.pump();
    expect(repository.calls, hasLength(1));
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('zyro.input')))
          .focusNode!
          .hasFocus,
      isTrue,
    );
    repository.fail(0);
    await tester.pumpAndSettle();
    expect(find.text('Revisar dispositivos de Google'), findsWidgets);
    expect(find.byKey(const Key('zyro.retry')), findsOneWidget);

    await tester.tap(find.byKey(const Key('zyro.retry')));
    await tester.pump();
    repository.succeed(
      1,
      kind: ZyroKind.guide,
      steps: const ['Abre Seguridad', 'Revisa los dispositivos'],
    );
    await tester.pumpAndSettle();
    expect(repository.calls[1].requestId, repository.calls[0].requestId);
    expect(find.text('Pasos de la guía verificada'), findsOneWidget);
    expect(find.text('1. Abre Seguridad'), findsOneWidget);
    expect(find.text('Revisión 2026-11-05'), findsOneWidget);
    expect(
      (tester.widget<TextField>(find.byKey(const Key('zyro.input'))).controller)
          ?.text,
      isEmpty,
    );

    await tester.enterText(
      find.byKey(const Key('zyro.input')),
      'Otra consulta',
    );
    await tester.ensureVisible(find.byKey(const Key('zyro.send')));
    await tester.tap(find.byKey(const Key('zyro.send')));
    await tester.pump();
    repository.succeed(
      2,
      kind: ZyroKind.limit,
      text: 'No puedo orientar sobre esa solicitud.',
    );
    await tester.pumpAndSettle();
    expect(find.text('Límite de orientación'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    harness.dispose();
  });

  for (final size in [const Size(320, 720), const Size(412, 915)]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('P07 ${size.width} text $scale remains operable', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final semantics = tester.ensureSemantics();
        final harness = await ProfileHarness.create();
        final repository = ControlledZyroRepository();
        await tester.pumpWidget(
          PrivaApp(
            controller: harness.account,
            initialRoute: '/chat',
            zyroRepository: repository,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.byKey(const Key('zyro.input')),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.byKey(const Key('zyro.input')),
          'Consulta sintética',
        );
        expect(find.byKey(const Key('zyro.send')), findsOneWidget);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        if (size == const Size(412, 915) && scale == 1.0) {
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        }
        await tester.pumpWidget(const SizedBox());
        harness.dispose();
        semantics.dispose();
      });
    }
  }
}
