import 'features/tips/data/bundled_tips_repository.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'features/account/data/firebase_registration_store.dart';

import 'app/firebase_config.dart';
import 'features/profile/data/profile_repository.dart';
import 'features/profile/data/firestore_profile_repository.dart';
import 'app/priva_app.dart';
import 'features/account/application/account_controller.dart';
import 'features/account/data/account_repository.dart';
import 'features/account/data/firebase_account_repository.dart';
import 'features/account/data/unavailable_account_repository.dart';
import 'features/accessibility/application/text_scale_controller.dart';
import 'features/accessibility/data/shared_preferences_text_scale.dart';
import 'features/accessibility/data/text_scale_preferences.dart';
import 'features/connectivity/application/connectivity_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = FirebaseConfig.fromEnvironment();
  Future<FirebaseFirestore> openDatabase() async {
    if (!config.isConfigured) {
      throw StateError('Firebase is not configured');
    }
    final app = Firebase.apps.isEmpty
        ? await Firebase.initializeApp(options: config.options)
              .timeout(const Duration(seconds: 15))
        : Firebase.app();
    final database = FirebaseFirestore.instanceFor(app: app);
    database.settings = const Settings(persistenceEnabled: false);
    return database;
  }

  final tipsRepository = BundledTipsRepository(rootBundle);
  ProfileRepository? profileRepository;
  AccountRepository repository = UnavailableAccountRepository();
  if (config.isConfigured) {
    try {
      final database = await openDatabase();
      profileRepository = FirestoreProfileRepository(
        FirebaseAuth.instance,
        database,
      );
      repository = FirebaseAccountRepository(
        FirebaseAuth.instance,
        registrationStore: FirestoreRegistrationStore(database),
      );
    } catch (_) {
      // No provider details or credentials are rendered or logged.
    }
  }
  final controller = AccountController(repository, allowTestPolicy: false);
  TextScalePreferences textScalePreferences;
  try {
    textScalePreferences = await SharedPreferencesTextScale.create();
  } catch (_) {
    // Platform channels are unavailable in some safe bootstrap environments.
    textScalePreferences = MemoryTextScalePreferences();
  }
  final textScale = TextScaleController(textScalePreferences);
  await textScale.initialize();
  final connectivity = ConnectivityController();
  await connectivity.initialize();
  runApp(
    PrivaApp(
      controller: controller,
      textScaleController: textScale,
      connectivityController: connectivity,
      testMode: false,
      profileRepository: profileRepository,
      tipsRepository: tipsRepository,
    ),
  );
  unawaited(controller.initialize());
}
