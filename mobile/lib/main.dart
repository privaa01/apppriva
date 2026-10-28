import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app/firebase_config.dart';
import 'app/priva_app.dart';
import 'features/account/application/account_controller.dart';
import 'features/account/data/account_repository.dart';
import 'features/account/data/firebase_account_repository.dart';
import 'features/account/data/unavailable_account_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = FirebaseConfig.fromEnvironment();
  AccountRepository repository = UnavailableAccountRepository();
  if (config.isConfigured) {
    try {
      await Firebase.initializeApp(options: config.options);
      repository = FirebaseAccountRepository(FirebaseAuth.instance);
    } catch (_) {
      // No provider details or credentials are rendered or logged.
    }
  }
  final controller = AccountController(repository, allowTestPolicy: false);
  runApp(PrivaApp(controller: controller, testMode: false));
  unawaited(controller.initialize());
}
