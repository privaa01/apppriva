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
    },
  );
}
