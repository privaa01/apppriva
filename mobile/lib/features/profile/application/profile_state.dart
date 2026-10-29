import '../data/profile_details.dart';

enum ProfilePhase { loading, ready, editing, saving, error, unknown }

class ProfileState {
  const ProfileState({
    this.phase = ProfilePhase.loading,
    this.profile,
    this.draft = '',
    this.message,
  });
  final ProfilePhase phase;
  final ProfileDetails? profile;
  final String draft;
  final String? message;
}
