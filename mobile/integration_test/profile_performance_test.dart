import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'support/profile_native_harness.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('20 server load/save samples on the selected Android network', (
    tester,
  ) async {
    final h = await NativeProfileHarness.connect();
    addTearDown(h.close);
    final original = await h.repository.loadCurrent(expectedUid: h.uid);
    final samples = <Map<String, Object>>[];
    try {
      for (var i = 0; i < 20; i++) {
        for (final operation in ['load', 'save']) {
          final clock = Stopwatch()..start();
          if (operation == 'load') {
            await h.repository.loadCurrent(expectedUid: h.uid);
          } else {
            await h.repository.updateName(
              'Prueba de rendimiento $i',
              expectedUid: h.uid,
            );
          }
          clock.stop();
          samples.add({
            'operation': operation,
            'sample': i + 1,
            'response_us': clock.elapsedMicroseconds,
          });
          expect(
            clock.elapsedMilliseconds <= 15000,
            isTrue,
            reason: 'Una muestra superó el presupuesto de respuesta; no se promedian excesos.',
          );
        }
      }
      // Data contain only operation/sample/duration, never identities or tokens.
      binding.reportData = {'profile_response_samples': samples};
    } finally {
      await h.repository.updateName(original.name, expectedUid: h.uid);
      await h.close();
    }
  }, skip: !runHostedProfileTests);
}
