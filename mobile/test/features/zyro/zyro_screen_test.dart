import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';

import '../account/ui_test_repository.dart';

void main() {
  testWidgets('F05-CHAT requires a valid session', (tester) async {
    final repository = UiTestRepository();
    final account = AccountController(repository);
    await account.initialize();
    await tester.pumpWidget(
      PrivaApp(controller: account, initialRoute: '/chat'),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Inicia sesión para acceder a esta sección'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
    account.dispose();
    await repository.changes.close();
  });

  testWidgets('F05-CHAT answers account protection locally', (tester) async {
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
    expect(find.text('¿Cómo protejo mi cuenta?'), findsOneWidget);
    expect(find.text('¿Cómo creo una contraseña segura?'), findsOneWidget);
    expect(find.text('¿Qué hago con un enlace sospechoso?'), findsOneWidget);
    expect(find.text('¿Cómo cuido mi privacidad en redes?'), findsOneWidget);
    expect(find.text('¿Qué hago si entraron a mi cuenta?'), findsOneWidget);
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
    expect(find.text('¿Cómo protejo mi cuenta?'), findsNWidgets(2));
    await tester.pumpWidget(const SizedBox());
    account.dispose();
    await repository.changes.close();
  });

  testWidgets('F05-CHAT asks a categorized question', (tester) async {
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

    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('zyro.askSelected')))
          .onPressed,
      isNull,
    );
    await tester.ensureVisible(find.byKey(const Key('zyro.category')));
    await tester.tap(find.byKey(const Key('zyro.category')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contraseñas y verificación').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('zyro.question')));
    await tester.tap(find.byKey(const Key('zyro.question')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.text('¿Cómo activo la verificación en dos pasos?').last,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('zyro.askSelected')));
    await tester.tap(find.byKey(const Key('zyro.askSelected')));
    await tester.pumpAndSettle();

    expect(
      find.text('¿Cómo activo la verificación en dos pasos?'),
      findsNWidgets(2),
    );
    expect(find.textContaining('Usa una contraseña larga'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    account.dispose();
    await repository.changes.close();
  });
}
