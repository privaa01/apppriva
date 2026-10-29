import 'package:cloud_firestore/cloud_firestore.dart';

import 'priva_treatment_policy.dart';

abstract interface class AccountRegistrationStore {
  Future<void> create({required String uid, required String name});
  Future<bool> hasAuthorization(String uid);
  Future<String?> profileName(String uid);
}

class FirestoreRegistrationStore implements AccountRegistrationStore {
  FirestoreRegistrationStore(this.database);
  final FirebaseFirestore database;

  @override
  Future<void> create({required String uid, required String name}) async {
    final batch = database.batch();
    batch.set(database.collection('profiles').doc(uid), {'name': name});
    batch.set(database.collection('authorization_evidence').doc(uid), {
      'user_id': uid,
      'policy_version': privaPolicyVersion,
      'purposes': privaPolicyPurposes,
      'action': 'account_signup',
      'accepted': true,
      'authorized_at': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  @override
  Future<bool> hasAuthorization(String uid) async {
    // Never accept a local cached consent record as server authorization.
    final row = await database
        .collection('authorization_evidence')
        .doc(uid)
        .get(const GetOptions(source: Source.server));
    final data = row.data();
    return data != null &&
        data['user_id'] == uid &&
        data['policy_version'] == privaPolicyVersion &&
        data['accepted'] == true &&
        data['action'] == 'account_signup' &&
        data['authorized_at'] is Timestamp &&
        data['purposes'] is List &&
        (data['purposes'] as List).length == privaPolicyPurposes.length &&
        privaPolicyPurposes.every(
          (p) => (data['purposes'] as List).contains(p),
        );
  }

  @override
  Future<String?> profileName(String uid) async {
    final row = await database
        .collection('profiles')
        .doc(uid)
        .get(const GetOptions(source: Source.server));
    return row.data()?['name'] as String?;
  }
}
