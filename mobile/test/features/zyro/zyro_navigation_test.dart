import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';

import '../account/ui_test_repository.dart';
import '../profile/profile_test_fixtures.dart';
import 'zyro_test_fixtures.dart';

void main() {
  for (final state in ['visitor', 'unverified']) {
    testWidgets('$state cannot open P07 before repository use', (tester) async {
      final auth = UiTestRepository();
      if (state == 'unverified') {
        auth.session = const AccountSession(
          userId: 'unverified',
          emailVerified: false,
          passwordAuthenticated: true,
        );
      }
      final account = AccountController(auth);
      await account.initialize();
      final zyro = ControlledZyroRepository();
      await tester.pumpWidget(
        PrivaApp(
          controller: account,
          initialRoute: '/chat',
          zyroRepository: zyro,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('¡Ingresa a tu cuenta!'), findsOneWidget);
      expect(zyro.calls, isEmpty);
      await tester.pumpWidget(const SizedBox());
      account.dispose();
      await auth.changes.close();
    });
  }

  testWidgets(
    'authenticated navigation selects Chat IA and logout discards it',
    (tester) async {
      final harness = await ProfileHarness.create();
      final zyro = ControlledZyroRepository();
      await tester.pumpWidget(
        PrivaApp(
          controller: harness.account,
          initialRoute: '/chat',
          zyroRepository: zyro,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.selected == true,
        ),
        findsOneWidget,
      );
      await tester.enterText(find.byKey(const Key('zyro.input')), 'Consulta');
      await tester.ensureVisible(find.byKey(const Key('zyro.send')));
      await tester.tap(find.byKey(const Key('zyro.send')));
      await tester.pump();
      zyro.succeed(0);
      await tester.pumpAndSettle();
      expect(find.text('Respuesta educativa'), findsOneWidget);

      await tester.tap(find.text('Tips').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chat IA').last);
      await tester.pumpAndSettle();
      expect(find.text('Respuesta educativa'), findsOneWidget);

      await harness.account.signOut();
      await tester.pumpAndSettle();
      expect(find.text('Respuesta educativa'), findsNothing);
      expect(find.text('¡Ingresa a tu cuenta!'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      harness.dispose();
    },
  );
}
