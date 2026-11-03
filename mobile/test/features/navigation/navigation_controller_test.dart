import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';

import '../profile/profile_test_fixtures.dart';

void main() {
  testWidgets(
    'direct Tip detail has catalog parent and returns without a cycle',
    (tester) async {
      final h = await ProfileHarness.create();
      await h.account.signOut();
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          initialRoute: '/tips/passwords',
          destinationBuilder: (_, path) => Text('view:$path'),
        ),
      );
      await tester.pumpAndSettle();
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      expect(navigator.canPop(), isTrue);
      navigator.pop();
      await tester.pumpAndSettle();
      expect(find.text('view:/tips'), findsOneWidget);
      expect(navigator.canPop(), isFalse);
      await tester.pumpWidget(const SizedBox());
      h.dispose();
    },
  );

  testWidgets('twenty reselections and A B A do not create a navigation loop', (
    tester,
  ) async {
    final h = await ProfileHarness.create();
    await tester.pumpWidget(
      PrivaApp(
        controller: h.account,
        initialRoute: '/home',
        destinationBuilder: (_, path) => Text('view:$path'),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.tap(find.text('Inicio').first);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Tips').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inicio').first);
    await tester.pumpAndSettle();
    final context = tester.element(find.text('view:/home'));
    expect(Navigator.of(context).canPop(), isFalse);
    await tester.pumpWidget(const SizedBox());
    h.dispose();
  });
}
