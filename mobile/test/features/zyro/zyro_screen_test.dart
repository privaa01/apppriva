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

  testWidgets('F05-CHAT answers a similar free-text question', (tester) async {
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

    const question = '¿Qué debo revisar para tener una cuenta protegida?';
    await tester.enterText(find.byKey(const Key('zyro.input')), question);
    await tester.ensureVisible(find.byKey(const Key('zyro.send')));
    await tester.tap(find.byKey(const Key('zyro.send')));
    await tester.pumpAndSettle();

    expect(find.text(question), findsOneWidget);
    expect(
      find.textContaining('Activa la verificación en dos pasos'),
      findsOneWidget,
    );
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

  testWidgets(
    'F05-CHAT unknown then supported query does not duplicate messages',
    (tester) async {
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

      await tester.enterText(
        find.byKey(const Key('zyro.input')),
        '¿Qué película me recomiendas?',
      );
      await tester.ensureVisible(find.byKey(const Key('zyro.send')));
      await tester.tap(find.byKey(const Key('zyro.send')));
      await tester.pumpAndSettle();
      expect(find.text('¿Qué película me recomiendas?'), findsOneWidget);
      expect(
        find.textContaining('No tengo una guía verificada'),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const Key('zyro.input')),
        '¿Cómo protejo mi cuenta?',
      );
      await tester.ensureVisible(find.byKey(const Key('zyro.send')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('zyro.send')));
      await tester.pumpAndSettle();
      expect(find.text('¿Cómo protejo mi cuenta?'), findsNWidgets(2));
      expect(
        find.textContaining('Activa la verificación en dos pasos'),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
      account.dispose();
      await repository.changes.close();
    },
  );

  for (final size in [const Size(320, 720), const Size(412, 915)]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('F05-A11Y ${size.width} text $scale remains operable', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = UiTestRepository()
          ..session = const AccountSession(
            userId: 'synthetic',
            emailVerified: true,
            passwordAuthenticated: true,
          );
        final account = AccountController(repository);
        await account.initialize();
        await tester.pumpWidget(
          PrivaApp(
            controller: account,
            initialRoute: '/chat',
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
                viewInsets: const EdgeInsets.only(bottom: 280),
              ),
              child: child!,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.bySemanticsLabel('Zyro, asistente educativo de Priva'),
          findsOneWidget,
        );
        await tester.ensureVisible(find.byKey(const Key('zyro.input')));
        await tester.enterText(
          find.byKey(const Key('zyro.input')),
          '¿Cómo protejo mi cuenta?',
        );
        await tester.ensureVisible(find.byKey(const Key('zyro.send')));
        expect(find.byKey(const Key('zyro.send')), findsOneWidget);
        await tester.tap(find.byKey(const Key('zyro.send')));
        await tester.pumpAndSettle();
        expect(
          find.textContaining('Activa la verificación en dos pasos'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        account.dispose();
        await repository.changes.close();
      });
    }
  }
}
