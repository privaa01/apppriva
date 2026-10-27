import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app_config.dart';
import 'app/priva_app.dart';
import 'features/account/application/account_controller.dart';
import 'features/account/data/account_repository.dart';
import 'features/account/data/secure_session_storage.dart';
import 'features/account/data/supabase_account_repository.dart';
import 'features/account/data/unavailable_account_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment();
  AccountRepository repository = UnavailableAccountRepository();
  if (config.isConfigured) {
    try {
      await Supabase.initialize(
        url: config.url,
        anonKey: config.publishableKey,
        debug: false,
        authOptions: FlutterAuthClientOptions(
          authFlowType: AuthFlowType.implicit,
          detectSessionInUri: false,
          localStorage: SecureSessionStorage(),
        ),
      );
      repository = SupabaseAccountRepository(
        Supabase.instance.client,
        allowTestPolicy: config.testMode,
      );
    } catch (_) {
      // No provider details or credentials are rendered or logged.
    }
  }
  final controller = AccountController(
    repository,
    allowTestPolicy: config.testMode,
  );
  runApp(PrivaApp(controller: controller, testMode: config.testMode));
  unawaited(controller.initialize());
}
