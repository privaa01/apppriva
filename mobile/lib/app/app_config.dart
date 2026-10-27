class AppConfig {
  const AppConfig({
    required this.url,
    required this.publishableKey,
    this.testMode = false,
  });
  final String url;
  final String publishableKey;
  final bool testMode;

  factory AppConfig.fromEnvironment() => const AppConfig(
    url: String.fromEnvironment('SUPABASE_URL'),
    publishableKey: String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
    testMode: bool.fromEnvironment('PRIVA_TEST_MODE'),
  );

  bool get isConfigured {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        uri.host.isEmpty ||
        publishableKey.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      return false;
    }
    final local = {
      'localhost',
      '127.0.0.1',
      '10.0.2.2',
      '::1',
    }.contains(uri.host);
    if (testMode) return local && {'http', 'https'}.contains(uri.scheme);
    return uri.scheme == 'https';
  }
}
