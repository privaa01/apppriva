import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';

import '../account/ui_test_repository.dart';

void main() {
  testWidgets('F05-CHAT requires a valid session', (tester) async {
    final account = AccountController(UiTestRepository());
    await account.initialize();
    await tester.pumpWidget(
      PrivaApp(controller: account, initialRoute: '/chat'),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Inicia sesión para acceder a esta sección'),
      findsOneWidget,
    );
    account.dispose();
  });

  testWidgets('F05-CHAT renders local chat and answers a supported query', (
    tester,
  ) async {
    final repository = UiTestRepository()
      ..session = const AccountSession(
        userId: 'synthetic',
        emailVerified: true,
        passwordAuthenticated: true,
      );
    final account = AccountController(repository);
    await account.initialize();
    await tester.pumpWidget(
      PrivaApp(controller: account, initialRoute: '/chat'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Asistente Zyro'), findsOneWidget);
    expect(find.textContaining('No compartas contraseñas'), findsOneWidget);
    expect(find.text('Proteger una cuenta'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('zyro.input')),
      '¿Cómo protejo mi cuenta?',
    );
    await tester.ensureVisible(find.byKey(const Key('zyro.send')));
    await tester.tap(find.byKey(const Key('zyro.send')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Activa la verificación en dos pasos'),
      findsOneWidget,
    );
    expect(find.text('¿Cómo protejo mi cuenta?'), findsOneWidget);
    account.dispose();
  });

  testWidgets('F05-CHAT quick prompts answer with the approved guidance', (
    tester,
  ) async {
    final repository = UiTestRepository()
      ..session = const AccountSession(
        userId: 'synthetic',
        emailVerified: true,
        passwordAuthenticated: true,
      );
    final account = AccountController(repository);
    await account.initialize();
    await tester.pumpWidget(
      PrivaApp(controller: account, initialRoute: '/chat'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Proteger una cuenta'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mantén actualizado tu correo'), findsOneWidget);
    account.dispose();
  });
}
