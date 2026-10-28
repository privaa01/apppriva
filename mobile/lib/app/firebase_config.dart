import 'package:firebase_core/firebase_core.dart';

/// Public app identifiers only. Never accepts an administrative credential.
class FirebaseConfig {
  const FirebaseConfig({
    required this.apiKey,
    required this.appId,
    required this.projectId,
    required this.messagingSenderId,
  });
  final String apiKey;
  final String appId;
  final String projectId;
  final String messagingSenderId;

  factory FirebaseConfig.fromEnvironment() => const FirebaseConfig(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_APP_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
  );

  bool get isConfigured =>
      RegExp(r'^[a-z][a-z0-9-]{4,28}[a-z0-9]$').hasMatch(projectId) &&
      RegExp(r'^1:[0-9]+:android:[a-zA-Z0-9]+$').hasMatch(appId) &&
      RegExp(r'^[0-9]+$').hasMatch(messagingSenderId) &&
      appId.split(':')[1] == messagingSenderId &&
      apiKey.trim().isNotEmpty;

  FirebaseOptions get options => FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
  );
}
