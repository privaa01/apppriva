import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';
import 'package:priva_mobile/features/profile/data/profile_details.dart';
import 'package:priva_mobile/features/profile/data/profile_repository.dart';
import 'package:priva_mobile/features/profile/data/deletion_contact_service.dart';

import '../account/fake_account_repository.dart';

class MemoryProfileRepository implements ProfileRepository {
  String name = 'Persona de prueba';
  int loads = 0;
  int writes = 0;
  Future<ProfileDetails> Function(String)? loader;
  Future<ProfileDetails> Function(String, String)? saver;
  @override
  Future<ProfileDetails> loadCurrent({required String expectedUid}) async {
    loads++;
    if (loader != null) return loader!(expectedUid);
    return ProfileDetails(
      uid: expectedUid,
      name: name,
      email: 'owner@example.test',
    );
  }

  @override
  Future<ProfileDetails> updateName(
    String value, {
    required String expectedUid,
  }) async {
    writes++;
    if (saver != null) return saver!(value, expectedUid);
    name = value;
    return ProfileDetails(
      uid: expectedUid,
      name: name,
      email: 'owner@example.test',
    );
  }
}

class FakeDeletionContact implements DeletionContactService {
  int opened = 0;
  int copied = 0;
  bool available = true;
  bool copySucceeds = true;
  @override
  Future<bool> openDraft() async {
    opened++;
    return available;
  }

  @override
  Future<bool> copyAddress() async {
    copied++;
    return copySucceeds;
  }
}

class ProfileHarness {
  ProfileHarness(this.auth, this.account, this.repository);
  final FakeAccountRepository auth;
  final AccountController account;
  final MemoryProfileRepository repository;
  static Future<ProfileHarness> create() async {
    final auth = FakeAccountRepository()
      ..session = const AccountSession(
        userId: 'synthetic',
        emailVerified: true,
        passwordAuthenticated: true,
        displayName: 'Old session name',
      );
    final account = AccountController(auth, allowTestPolicy: true);
    await account.initialize();
    return ProfileHarness(auth, account, MemoryProfileRepository());
  }

  void dispose() {
    account.dispose();
    auth.dispose();
  }
}
