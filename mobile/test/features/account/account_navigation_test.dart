import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';

import 'ui_test_repository.dart';

void main() {
  for (final path in [
    '/tips',
    '/tips/passwords',
    '/tips/sharing',
    '/tips/links',
    '/tips/profiles',
  ]) {
    testWidgets('visitor can reach public $path', (tester) async {
      final repo = UiTestRepository();
      final controller = AccountController(repo);
      await controller.initialize();
      await tester.pumpWidget(
        PrivaApp(
          controller: controller,
          initialRoute: path,
          destinationBuilder: (context, path) => Text('Destino:$path'),
        ),
      );
      expect(find.text('Destino:$path'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      await repo.changes.close();
    });
  }
  testWidgets('direct private route denied for visitor and OTP session', (
    tester,
  ) async {
    final repo = UiTestRepository()
      ..session = const AccountSession(
        userId: 'synthetic',
        emailVerified: true,
        passwordAuthenticated: false,
      );
    final controller = AccountController(repo);
    await controller.initialize();
    await tester.pumpWidget(
      PrivaApp(
        controller: controller,
        initialRoute: '/profile',
        destinationBuilder: (context, path) => Text('Privado:$path'),
      ),
    );
    expect(find.text('Privado:/profile'), findsNothing);
    expect(find.byKey(const Key('signin.submit')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
    await repo.changes.close();
  });
  testWidgets('private page disappears after session invalidation', (
    tester,
  ) async {
    final repo = UiTestRepository()
      ..session = const AccountSession(
        userId: 'synthetic',
        emailVerified: true,
        passwordAuthenticated: true,
      );
    final controller = AccountController(repo);
    await controller.initialize();
    await tester.pumpWidget(
      PrivaApp(
        controller: controller,
        initialRoute: '/profile',
        destinationBuilder: (context, path) => Text('Privado:$path'),
      ),
    );
    expect(find.text('Privado:/profile'), findsOneWidget);
    await repo.signOut();
    await tester.pumpAndSettle();
    expect(find.text('Privado:/profile'), findsNothing);
    expect(find.byKey(const Key('signin.submit')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
    await repo.changes.close();
  });
}
