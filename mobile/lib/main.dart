import 'features/tips/data/bundled_tips_repository.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import 'features/zyro/data/functions_zyro_repository.dart';

import 'features/account/data/firebase_registration_store.dart';

import 'app/firebase_config.dart';
import 'features/profile/data/profile_repository.dart';
import 'features/profile/data/firestore_profile_repository.dart';
import 'app/priva_app.dart';
import 'features/account/application/account_controller.dart';
import 'features/account/data/account_repository.dart';
import 'features/account/data/firebase_account_repository.dart';
import 'features/account/data/unavailable_account_repository.dart';

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
  FunctionsZyroRepository? zyroRepository;
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
      try {
        await FirebaseAppCheck.instance.activate(
          providerAndroid: kReleaseMode
              ? const AndroidPlayIntegrityProvider()
              : const AndroidDebugProvider(),
        );
        zyroRepository = FunctionsZyroRepository(
          FirebaseFunctions.instanceFor(region: 'us-central1'),
        );
      } catch (_) {
        // Authentication remains available; Zyro fails closed without App Check.
      }
    } catch (_) {
      // No provider details or credentials are rendered or logged.
    }
  }
  final controller = AccountController(repository, allowTestPolicy: false);
  runApp(
    PrivaApp(
      controller: controller,
      testMode: false,
      profileRepository: profileRepository,
      tipsRepository: tipsRepository,
      zyroRepository: zyroRepository,
    ),
  );
  unawaited(controller.initialize());
}
