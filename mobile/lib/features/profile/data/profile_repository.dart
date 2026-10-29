import 'profile_details.dart';

class ProfileFailure implements Exception {
  const ProfileFailure();
}

abstract interface class ProfileRepository {
  Future<ProfileDetails> loadCurrent({required String expectedUid});
  Future<ProfileDetails> updateName(String name, {required String expectedUid});
}
