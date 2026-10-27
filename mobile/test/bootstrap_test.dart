import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/main.dart' as app;

void main() {
  testWidgets(
    'missing deployment configuration shows safe sign-in and blocks registration',
    (tester) async {
      await app.main();
      await tester.pumpAndSettle();
      expect(find.text('Iniciar sesión'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
}
