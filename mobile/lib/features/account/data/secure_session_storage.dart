import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecureSessionStorage extends LocalStorage {
  SecureSessionStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _storage;
  static const _key = 'priva.auth.session.v1';
  @override
  Future<void> initialize() async {}
  @override
  Future<String?> accessToken() => _storage.read(key: _key);
  @override
  Future<bool> hasAccessToken() async => await accessToken() != null;
  @override
  Future<void> persistSession(String persistSessionString) async {
    final session = jsonDecode(persistSessionString) as Map<String, dynamic>;
    final user = session['user'] as Map<String, dynamic>;
    // Keep the SDK's tokens and only the identity state needed to reconstruct a
    // session. Names, email copies, arbitrary metadata and provider credentials
    // are not duplicated into local storage. Signed JWT content is not modified.
    final minimal = <String, dynamic>{
      for (final field in [
        'access_token',
        'refresh_token',
        'expires_in',
        'token_type',
      ])
        if (session.containsKey(field)) field: session[field],
      'user': {
        for (final field in ['id', 'aud', 'created_at', 'email_confirmed_at'])
          if (user.containsKey(field)) field: user[field],
      },
    };
    await _storage.write(key: _key, value: jsonEncode(minimal));
  }

  @override
  Future<void> removePersistedSession() => _storage.delete(key: _key);
}
