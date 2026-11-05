import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/zyro/data/functions_zyro_repository.dart';
import 'package:priva_mobile/features/zyro/data/zyro_repository.dart';
import 'package:priva_mobile/features/zyro/domain/zyro_message.dart';

void main() {
  const requestId = 'f0a8695d-7e6a-4af7-937c-af82c5fb84f2';
  Map<String, Object?> response({String kind = 'general'}) => {
    'schemaVersion': 1,
    'requestId': requestId,
    'kind': kind,
    'message': 'Orientación educativa',
    'steps': kind == 'guide' ? ['Paso aprobado'] : <String>[],
    if (kind == 'guide') 'guideId': 'google-review-devices',
    if (kind == 'guide') 'guideRevision': '2026-11-05',
    'retryable': false,
    'policyVersion': 'zyro-policy-1',
  };

  test('keeps only the newest eight context items within 6000 chars', () {
    final context = List.generate(
      10,
      (index) => ZyroMessage(
        id: '$index',
        role: ZyroRole.zyro,
        text: 'mensaje-$index',
      ),
    );
    final payload = buildZyroPayload(requestId, 'consulta', context);
    final sent = payload['context']! as List;
    expect(sent, hasLength(8));
    expect((sent.first as Map)['text'], 'mensaje-2');

    final large = List.generate(
      4,
      (index) => ZyroMessage(
        id: '$index',
        role: ZyroRole.zyro,
        text: '${index}x${'a' * 2998}',
      ),
    );
    expect(
      (buildZyroPayload(requestId, 'consulta', large)['context']! as List),
      hasLength(2),
    );
  });

  test('accepts exact response and guide metadata', () {
    expect(parseZyroReply(requestId, response()).kind, ZyroKind.general);
    expect(
      parseZyroReply(requestId, response(kind: 'guide')).guideId,
      'google-review-devices',
    );
  });

  test(
    'rejects mismatches, extra fields, URLs and incoherent guide metadata',
    () {
      for (final invalid in [
        {...response(), 'requestId': 'different'},
        {...response(), 'extra': true},
        {...response(), 'schemaVersion': 2},
        {...response(), 'kind': 'unknown'},
        {...response(), 'message': 'Visita https://example.test'},
        response(kind: 'guide')..remove('guideId'),
      ]) {
        expect(
          () => parseZyroReply(requestId, invalid),
          throwsA(isA<ZyroFailure>()),
        );
      }
    },
  );
}
