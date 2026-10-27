import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/account/data/supabase_account_repository.dart';

class RealBackend {
  static const url = String.fromEnvironment('PRIVA_INTEGRATION_URL');
  static const key = String.fromEnvironment('PRIVA_INTEGRATION_KEY');
  late final SupabaseClient client;
  late final SupabaseAccountRepository repository;
  late final AccountController controller;
  final email =
      'synthetic-${DateTime.now().microsecondsSinceEpoch}@example.test';
  static const password = 'Synthetic123!';
  Future<void> start() async {
    if (url.isEmpty || key.isEmpty) {
      throw StateError('Run through mobile/tool/run_local_integration.py');
    }
    // This suite deliberately contacts only its isolated local fixture.
    HttpOverrides.global = null;
    client = SupabaseClient(
      url,
      key,
      authOptions: const AuthClientOptions(
        authFlowType: AuthFlowType.implicit,
        autoRefreshToken: false,
      ),
    );
    repository = SupabaseAccountRepository(client, allowTestPolicy: true);
    controller = AccountController(repository, allowTestPolicy: true);
    await controller.initialize();
  }

  Future<Map<String, dynamic>> control(
    String action, {
    String? forEmail,
  }) async {
    final response = await http.post(
      Uri.parse('$url/__test/$action'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'email': forEmail ?? email}),
    );
    if (response.statusCode != 200) {
      throw StateError('Local fixture operation failed');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<String> code() async => (await control('code'))['code'] as String;
  Future<void> signup() async {
    expect(
      await controller.register(
        name: 'Persona sintética',
        email: email,
        password: password,
        accepted: true,
      ),
      isTrue,
    );
  }

  Future<void> verified() async {
    await signup();
    expect(await controller.confirm(await code()), isTrue);
  }

  Future<void> login() async {
    expect(await controller.signIn(email: email, password: password), isTrue);
  }

  Future<void> close() async {
    controller.dispose();
    await client.dispose();
  }
}
