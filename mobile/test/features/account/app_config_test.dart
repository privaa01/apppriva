import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/app_config.dart';

void main() {
  test('missing configuration fails closed', () {
    expect(const AppConfig(url: '', publishableKey: '').isConfigured, isFalse);
  });
  test('production requires HTTPS', () {
    expect(
      const AppConfig(
        url: 'http://project.example',
        publishableKey: 'public',
      ).isConfigured,
      isFalse,
    );
  });
  test('local synthetic mode cannot target external project', () {
    expect(
      const AppConfig(
        url: 'https://project.example',
        publishableKey: 'public',
        testMode: true,
      ).isConfigured,
      isFalse,
    );
  });
  test('local synthetic endpoint is supported', () {
    expect(
      const AppConfig(
        url: 'http://127.0.0.1:54321',
        publishableKey: 'public',
        testMode: true,
      ).isConfigured,
      isTrue,
    );
  });
  test('embedded credentials are rejected', () {
    expect(
      const AppConfig(
        url: 'https://secret@project.example',
        publishableKey: 'public',
      ).isConfigured,
      isFalse,
    );
  });
}
