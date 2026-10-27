import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:priva_mobile/features/account/data/secure_session_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('secure adapter preserves SDK session while discarding excess personal metadata', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final storage = SecureSessionStorage();
    await storage.initialize();
    expect(await storage.hasAccessToken(), isFalse);
    await storage.persistSession(
      jsonEncode({
        'access_token': 'synthetic-token',
        'refresh_token': 'synthetic-refresh',
        'expires_in': 3600,
        'token_type': 'bearer',
        'provider_token': 'not-needed',
        'user': {
          'id': 'synthetic',
          'aud': 'authenticated',
          'created_at': '2026-10-27T00:00:00Z',
          'email_confirmed_at': '2026-10-27T00:00:00Z',
          'email': 'persona@example.test',
          'user_metadata': {'name': 'Persona', 'arbitrary': 'discard'},
        },
      }),
    );
    final saved =
        jsonDecode((await storage.accessToken())!) as Map<String, dynamic>;
    expect(saved.containsKey('provider_token'), isFalse);
    final user = saved['user'] as Map;
    expect(user.containsKey('email'), isFalse);
    expect(user.containsKey('user_metadata'), isFalse);
    final recovered = Session.fromJson(saved);
    expect(recovered?.user.id, 'synthetic');
    expect(recovered?.user.emailConfirmedAt, isNotNull);
    expect(recovered?.refreshToken, 'synthetic-refresh');
    await storage.removePersistedSession();
    expect(await storage.hasAccessToken(), isFalse);
  });
}
