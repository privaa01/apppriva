import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/main.dart' as app;

void main() {
  testWidgets(
    'unavailable native Firebase plugin shows safe sign-in without crashing',
    (tester) async {
      await tester.runAsync(app.main);
      await tester.pumpAndSettle();
      expect(find.text('Iniciar sesión'), findsWidgets);
      expect(tester.takeException(), isNull);
      await tester.enterText(
        find.byKey(const Key('signin.email')),
        'synthetic@example.test',
      );
      await tester.enterText(
        find.byKey(const Key('signin.password')),
        'Synthetic123!',
      );
      await tester.ensureVisible(find.byKey(const Key('signin.submit')));
      await tester.tap(find.byKey(const Key('signin.submit')));
      await tester.pumpAndSettle();
      expect(find.textContaining('AC-09'), findsOneWidget);
    },
  );
}
