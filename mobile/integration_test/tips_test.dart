import 'package:integration_test/integration_test.dart';

import '../test/features/tips/tips_screen_test.dart' as scenarios;

/// Same public route/expansion scenarios on Android with synthetic repositories.
/// This does not claim to validate hosted Firestore configuration.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  scenarios.main();
}
