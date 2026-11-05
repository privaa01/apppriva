import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/tips/data/bundled_tips_repository.dart';
import 'package:priva_mobile/features/tips/data/tip_content.dart';
import 'package:priva_mobile/features/tips/data/tips_repository.dart';

import 'tips_test_fixtures.dart';

class _MemoryBundle extends CachingAssetBundle {
  _MemoryBundle(this.value);

  final String value;
  int reads = 0;

  @override
  Future<ByteData> load(String key) async {
    reads += 1;
    final bytes = Uint8List.fromList(utf8.encode(value));
    return ByteData.sublistView(bytes);
  }
}

void main() {
  test('F04-BUNDLED loads the four approved categories in fixed order', () async {
    final bundle = _MemoryBundle(jsonEncode(approvedTipsPayload()));
    final repository = BundledTipsRepository(bundle);

    expect(
      (await repository.loadCatalog()).map((tip) => tip.categoryId),
      TipContent.ids,
    );
    expect((await repository.loadDetail('links')).categoryId, 'links');
    expect(bundle.reads, 1, reason: 'the packaged content is decoded once');
  });

  test('F04-BUNDLED rejects unknown routes without reading an asset', () async {
    final bundle = _MemoryBundle(jsonEncode(approvedTipsPayload()));
    final repository = BundledTipsRepository(bundle);

    await expectLater(
      repository.loadDetail('arbitrary'),
      throwsA(
        isA<TipsFailure>().having(
          (failure) => failure.kind,
          'kind',
          TipsFailureKind.unavailable,
        ),
      ),
    );
    expect(bundle.reads, 0);
  });

  for (final payload in <String>[
    '{}',
    '{"passwords":{"schemaVersion":2}}',
    'not-json',
  ]) {
    test('F04-BUNDLED rejects missing or invalid packaged content', () async {
      final repository = BundledTipsRepository(_MemoryBundle(payload));
      await expectLater(
        repository.loadCatalog(),
        throwsA(
          isA<TipsFailure>().having(
            (failure) => failure.kind,
            'kind',
            TipsFailureKind.unavailable,
          ),
        ),
      );
    });
  }
}
