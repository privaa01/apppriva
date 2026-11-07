import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/questionnaire/data/bundled_result_recommendation_repository.dart';
import 'package:priva_mobile/features/questionnaire/data/result_recommendation_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('carga cinco módulos con tres acciones y cachea en RAM', () async {
    final repository = BundledResultRecommendationRepository();
    final first = await repository.load();
    final second = await repository.load();
    expect(identical(first, second), isTrue);
    expect(first.actions, hasLength(5));
    expect(
      first.actions.values.every((actions) => actions.length == 3),
      isTrue,
    );
  });

  test('rechaza el catálogo completo si está incompleto', () async {
    final repository = BundledResultRecommendationRepository(
      bundle: _StringBundle(
        '{"schemaVersion":1,"status":"approved","modules":[]}',
      ),
    );
    await expectLater(
      repository.load(),
      throwsA(isA<ResultRecommendationException>()),
    );
  });

  test(
    'rechaza campos adicionales aunque el catálogo parezca válido',
    () async {
      final valid = await rootBundle.loadString(
        'assets/content/result-recommendations-1.0.0.json',
      );
      final repository = BundledResultRecommendationRepository(
        bundle: _StringBundle(valid.replaceFirst('{', '{"extra":true,')),
      );
      await expectLater(
        repository.load(),
        throwsA(isA<ResultRecommendationException>()),
      );
    },
  );
}

class _StringBundle extends CachingAssetBundle {
  _StringBundle(this.value);
  final String value;
  @override
  Future<String> loadString(String key, {bool cache = true}) async => value;
  @override
  Future<ByteData> load(String key) => throw UnimplementedError();
}
