import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:priva_mobile/app/firebase_config.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/account/data/firebase_account_repository.dart';
import 'package:priva_mobile/features/account/data/firebase_registration_store.dart';
import 'package:priva_mobile/features/profile/data/firestore_profile_repository.dart';

const runHostedProfileTests = bool.fromEnvironment(
  'PRIVA_RUN_HOSTED_PROFILE_TESTS',
);

/// Uses a pre-created, verified synthetic account explicitly provided by the owner.
/// Never creates users, sends messages or weakens deployed rules.
class NativeProfileHarness {
  NativeProfileHarness(this.account, this.repository, this.database, this.uid);
  final AccountController account;
  final FirestoreProfileRepository repository;
  final FirebaseFirestore database;
  final String uid;
  bool _closed = false;
  static Future<NativeProfileHarness> connect() async {
    const email = String.fromEnvironment('PRIVA_PROFILE_TEST_EMAIL');
    const password = String.fromEnvironment('PRIVA_PROFILE_TEST_PASSWORD');
    const uid = String.fromEnvironment('PRIVA_PROFILE_TEST_UID');
    if (!runHostedProfileTests ||
        email.isEmpty ||
        password.isEmpty ||
        uid.isEmpty) {
      throw StateError(
        'Se requiere configuración segura de una cuenta sintética verificada.',
      );
    }
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: FirebaseConfig.fromEnvironment().options,
        );
      }
      final database = FirebaseFirestore.instance;
      database.settings = const Settings(persistenceEnabled: false);
      final account = AccountController(
        FirebaseAccountRepository(
          FirebaseAuth.instance,
          registrationStore: FirestoreRegistrationStore(database),
        ),
      );
      await account.initialize();
      final success = await account.signIn(email: email, password: password);
      if (!success || account.state.session?.userId != uid) {
        await account.signOut();
        account.dispose();
        throw StateError('No se pudo validar la cuenta de pruebas.');
      }
      return NativeProfileHarness(
        account,
        FirestoreProfileRepository(FirebaseAuth.instance, database),
        database,
        uid,
      );
    } catch (_) {
      throw StateError(
        'No se pudo preparar Firebase para las pruebas de perfil.',
      );
    }
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await account.signOut();
    account.dispose();
  }
}
