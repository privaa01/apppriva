import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/zyro/domain/zyro_message.dart';

void main() {
  test('accepts immutable plain messages and approved guide metadata', () {
    final steps = ['Abre Seguridad', 'Revisa tus dispositivos'];
    final message = ZyroMessage(
      id: 'local-1',
      role: ZyroRole.zyro,
      text: 'Revisión de dispositivos',
      kind: ZyroKind.guide,
      steps: steps,
      guideId: 'google-review-devices',
      guideRevision: '2026-11-05',
    );
    steps.add('Mutación externa');
    expect(message.steps, hasLength(2));
    expect(() => message.steps.add('No permitido'), throwsUnsupportedError);
  });

  test('rejects empty text, oversized input, too many steps and URLs', () {
    expect(
      () => ZyroMessage(id: '1', role: ZyroRole.user, text: ' '),
      throwsFormatException,
    );
    expect(
      () => ZyroMessage(id: '1', role: ZyroRole.user, text: 'x' * 1001),
      throwsFormatException,
    );
    expect(
      () => ZyroMessage(
        id: '1',
        role: ZyroRole.zyro,
        text: 'Respuesta',
        steps: List.filled(7, 'Paso'),
      ),
      throwsFormatException,
    );
    expect(
      () => ZyroMessage(
        id: '1',
        role: ZyroRole.zyro,
        text: 'Visita https://example.test',
      ),
      throwsFormatException,
    );
  });

  test('requires guide metadata only for guide responses', () {
    expect(
      () => ZyroMessage(
        id: '1',
        role: ZyroRole.zyro,
        text: 'Guía',
        kind: ZyroKind.guide,
      ),
      throwsFormatException,
    );
    expect(
      () => ZyroMessage(
        id: '1',
        role: ZyroRole.zyro,
        text: 'General',
        guideId: 'unexpected',
      ),
      throwsFormatException,
    );
  });
}
