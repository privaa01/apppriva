import 'package:integration_test/integration_test.dart';

import '../test/features/zyro/zyro_screen_test.dart' as screen;

/// Recorrido Android local. No usa red, proveedor ni cuentas personales.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  screen.main();
}
