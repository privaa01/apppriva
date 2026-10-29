import 'dart:async';

import 'package:flutter/material.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = FirebaseConfig.fromEnvironment();
  ProfileRepository? profileRepository;
  AccountRepository repository = UnavailableAccountRepository();
  if (config.isConfigured) {
    try {
      await Firebase.initializeApp(options: config.options)
          .timeout(const Duration(seconds: 15));
      final database = FirebaseFirestore.instance;
      database.settings = const Settings(persistenceEnabled: false);
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
  runApp(
    PrivaApp(
      controller: controller,
      testMode: false,
      profileRepository: profileRepository,
    ),
  );
  unawaited(controller.initialize());
}
