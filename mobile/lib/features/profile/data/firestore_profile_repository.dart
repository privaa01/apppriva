import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../account/data/firebase_registration_store.dart';
import 'profile_details.dart';
import 'profile_repository.dart';

abstract interface class ProfileDocuments {
  Future<String?> readName(String uid);
  Future<String> updateName(
    String uid,
    String name,
    Future<void> Function() validate,
  );
}

class FirestoreProfileRepository implements ProfileRepository {
  FirestoreProfileRepository(FirebaseAuth auth, FirebaseFirestore database)
    : this.withStores(
        auth,
        FirestoreProfileDocuments(database),
        FirestoreRegistrationStore(database),
      );
  FirestoreProfileRepository.withStores(
    this.auth,
    this.documents,
    this.authorization,
  );
  final FirebaseAuth auth;
  final ProfileDocuments documents;
  final AccountRegistrationStore authorization;

  void _checkIdentity(String uid) {
    final current = auth.currentUser;
    if (current == null ||
        current.uid != uid ||
        !current.emailVerified ||
        current.email?.trim().isNotEmpty != true) {
      throw const ProfileFailure();
    }
  }

  Future<User> _authorize(String expectedUid) async {
    _checkIdentity(expectedUid);
    final user = auth.currentUser!;
    final token = await user.getIdTokenResult();
    if (token.signInProvider != 'password' ||
        !await authorization.hasAuthorization(expectedUid)) {
      throw const ProfileFailure();
    }
    _checkIdentity(expectedUid);
    return user;
  }

  @override
  Future<ProfileDetails> loadCurrent({required String expectedUid}) async {
    try {
      final user = await _authorize(expectedUid);
      final name = await documents.readName(user.uid);
      _checkIdentity(expectedUid);
      if (name == null || name.trim().isEmpty) throw const ProfileFailure();
      return ProfileDetails(uid: user.uid, name: name, email: user.email!);
    } catch (_) {
      throw const ProfileFailure();
    }
  }

  @override
  Future<ProfileDetails> updateName(
    String name, {
    required String expectedUid,
  }) async {
    final normalized = name.trim();
    if (normalized.isEmpty) throw const ProfileFailure();
    try {
      final user = await _authorize(expectedUid);
      final confirmed = await documents.updateName(
        user.uid,
        normalized,
        () async {
          await _authorize(expectedUid);
        },
      );
      _checkIdentity(expectedUid);
      return ProfileDetails(uid: user.uid, name: confirmed, email: user.email!);
    } catch (_) {
      throw const ProfileFailure();
    }
  }
}

class FirestoreProfileDocuments implements ProfileDocuments {
  FirestoreProfileDocuments(this.database);
  final FirebaseFirestore database;
  @override
  Future<String?> readName(String uid) async {
    final row = await database
        .collection('profiles')
        .doc(uid)
        .get(const GetOptions(source: Source.server));
    return row.data()?['name'] as String?;
  }

  @override
  Future<String> updateName(
    String uid,
    String name,
    Future<void> Function() validate,
  ) {
    final ref = database.collection('profiles').doc(uid);
    return database.runTransaction((transaction) async {
      await validate();
      final row = await transaction.get(ref);
      if (!row.exists || row.data()?['name'] is! String) {
        throw const ProfileFailure();
      }
      await validate();
      transaction.update(ref, {'name': name});
      return name;
    });
  }
}
