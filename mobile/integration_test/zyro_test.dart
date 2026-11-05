import 'package:integration_test/integration_test.dart';

import '../test/features/zyro/zyro_navigation_test.dart' as navigation;
import '../test/features/zyro/zyro_screen_test.dart' as screen;

/// Recorrido Android con repositorios y mensajes sintéticos. No llama Vertex,
/// no usa cuentas personales y no acredita configuración hospedada.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  screen.main();
  navigation.main();
}
