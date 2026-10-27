// Host entry point: exercises actual local Auth/PostgREST plus Flutter widgets.
// Native-device delivery validation remains a separate acceptance requirement.
import 'package:flutter_test/flutter_test.dart';

import '../integration_test/account_access_test.dart' as access;
import '../integration_test/account_recovery_test.dart' as recovery;
import '../integration_test/account_permissions_test.dart' as permissions;
import '../integration_test/account_performance_test.dart' as performance;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  access.main();
  recovery.main();
  permissions.main();
  performance.main();
}
