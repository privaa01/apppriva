import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:priva_mobile/features/tips/data/firestore_tips_repository.dart';
import 'package:priva_mobile/features/tips/data/tip_content.dart';
import 'package:priva_mobile/features/tips/data/tips_repository.dart';

import 'tips_test_fixtures.dart';

void main() {
  test('F04-RECOVERY production adapter explicitly requests server-only document reads', () async {
    final payload = approvedTipsPayload();
    final paths = <String>[];
    final sources = <Source>[];
    final repo = FirestoreTipsRepository.withServerReader((
      collection,
      id,
      options,
    ) async {
      expect(collection, 'educational_tips');
      paths.add(id);
      sources.add(options.source);
      return Map<String, dynamic>.from(payload[id] as Map);
    });
    expect(await repo.loadCatalog(), hasLength(4));
    expect(paths, TipContent.ids);
    expect(sources, everyElement(Source.server));
  });
  test(
    'F04-RECOVERY catalog reads four fixed IDs; detail reads only requested ID',
    () async {
      final data = approvedTipsPayload();
      final calls = <String>[];
      final repo = FirestoreTipsRepository.withReader((id) async {
        calls.add(id);
        return Map<String, dynamic>.from(data[id] as Map);
      });
      expect(
        (await repo.loadCatalog()).map((e) => e.categoryId),
        TipContent.ids,
      );
      expect(calls, TipContent.ids);
      calls.clear();
      expect((await repo.loadDetail('links')).categoryId, 'links');
      expect(calls, ['links']);
      await expectLater(
        repo.loadDetail('arbitrary'),
        throwsA(isA<TipsFailure>()),
      );
      expect(calls, ['links']);
    },
  );
  for (final kind in ['missing', 'invalid', 'denied', 'network']) {
    test(
      'F04-RECOVERY $kind maps safely and rejects partial catalog',
      () async {
        final data = approvedTipsPayload();
        final repo = FirestoreTipsRepository.withReader((id) async {
          if (id != 'links') return Map<String, dynamic>.from(data[id] as Map);
          return switch (kind) {
            'missing' => null,
            'invalid' => {'schemaVersion': 2},
            'denied' => throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'permission-denied',
            ),
            _ => throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'unavailable',
            ),
          };
        });
        await expectLater(
          repo.loadCatalog(),
          throwsA(
            isA<TipsFailure>().having(
              (e) => e.kind,
              'kind',
              kind == 'network'
                  ? TipsFailureKind.error
                  : TipsFailureKind.unavailable,
            ),
          ),
        );
      },
    );
  }
  test(
    'F04-RECOVERY Core initialization can retry independently of account',
    () async {
      var calls = 0;
      final repo = DeferredTipsRepository(() async {
        if (++calls == 1) throw const TipsFailure(TipsFailureKind.unavailable);
        return TestTipsRepository();
      });
      await expectLater(repo.loadCatalog(), throwsA(isA<TipsFailure>()));
      expect(await repo.loadCatalog(), hasLength(4));
      expect(calls, 2);
    },
  );
}
