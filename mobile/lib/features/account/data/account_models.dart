class TreatmentPolicy {
  const TreatmentPolicy({
    required this.version,
    required this.body,
    required this.purposes,
    required this.isTest,
  });
  final String version;
  final String body;
  final List<String> purposes;
  final bool isTest;
  factory TreatmentPolicy.fromJson(Map<String, dynamic> row) => TreatmentPolicy(
    version: row['version'] as String,
    body: row['body'] as String,
    purposes: List<String>.from(row['purposes'] as List),
    isTest: row['is_test'] as bool,
  );
}

class AccountProfile {
  const AccountProfile({required this.id, required this.name});
  final String id;
  final String name;
  factory AccountProfile.fromJson(Map<String, dynamic> row) =>
      AccountProfile(id: row['id'] as String, name: row['name'] as String);
}
