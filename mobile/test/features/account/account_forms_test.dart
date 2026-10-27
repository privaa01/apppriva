import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/app/account_errors.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';

import 'ui_test_repository.dart';

void main() {
  testWidgets('P11 keeps navigation and errors never expose account status', (
    tester,
  ) async {
    final repo = UiTestRepository()..rejectSignIn = true;
    final controller = AccountController(repo);
    await controller.initialize();
    await tester.pumpWidget(PrivaApp(controller: controller));
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Tips'), findsOneWidget);
    expect(find.text('Chat IA'), findsOneWidget);
    expect(find.text('Cuestionario'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('signin.email')),
      'persona@example.test',
    );
    await tester.enterText(
      find.byKey(const Key('signin.password')),
      'ContrasenaPrueba123',
    );
    await tester.ensureVisible(find.byKey(const Key('signin.submit')));
    await tester.tap(find.byKey(const Key('signin.submit')));
    await tester.pumpAndSettle();
    expect(find.text(signInFailureMessage), findsOneWidget);
    expect(find.textContaining('email_not_confirmed'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
    await repo.changes.close();
  });

  testWidgets(
    'P10 validates required fields, has no phone, and policy precedes consent',
    (tester) async {
      final repo = UiTestRepository();
      final controller = AccountController(repo);
      await controller.initialize();
      await tester.pumpWidget(
        PrivaApp(controller: controller, initialRoute: '/signup'),
      );
      expect(find.byKey(const Key('signup.name')), findsOneWidget);
      expect(find.textContaining('Teléfono'), findsNothing);
      expect(find.textContaining('teléfono'), findsNothing);
      await tester.ensureVisible(find.byKey(const Key('signup.submit')));
      await tester.tap(find.byKey(const Key('signup.submit')));
      await tester.pumpAndSettle();
      expect(repo.signups, 0);
      final tile = tester.widget<CheckboxListTile>(
        find.byKey(const Key('signup.consent')),
      );
      expect(tile.onChanged, isNull);
      await tester.ensureVisible(find.byKey(const Key('signup.policy')));
      await tester.tap(find.byKey(const Key('signup.policy')));
      await tester.pumpAndSettle();
      expect(
        find.text('Política para las pruebas sintéticas de cuenta.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<CheckboxListTile>(find.byKey(const Key('signup.consent')))
            .onChanged,
        isNotNull,
      );
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      await repo.changes.close();
    },
  );

  testWidgets('large text and keyboard preserve operable sign in', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repo = UiTestRepository();
    final controller = AccountController(repo);
    await controller.initialize();
    await tester.pumpWidget(
      PrivaApp(
        controller: controller,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('signin.email')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('signin.submit')));
    expect(find.byKey(const Key('signin.submit')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
    await repo.changes.close();
  });
}
