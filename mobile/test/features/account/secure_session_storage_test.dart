import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:priva_mobile/features/account/data/secure_session_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'SDK session adapter persists then deletes using secure-storage interface',
    () async {
      FlutterSecureStorage.setMockInitialValues({});
      final storage = SecureSessionStorage();
      await storage.initialize();
      expect(await storage.hasAccessToken(), isFalse);
      await storage.persistSession('synthetic-session');
      expect(await storage.accessToken(), 'synthetic-session');
      await storage.removePersistedSession();
      expect(await storage.hasAccessToken(), isFalse);
    },
  );
}
