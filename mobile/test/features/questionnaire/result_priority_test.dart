import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/questionnaire/domain/question.dart';
import 'package:priva_mobile/features/questionnaire/domain/result_calculator.dart';

import 'result_test_fixtures.dart';

void main() {
  test('ordena tres módulos por suma y desempata por orden aprobado', () {
    final result = const ResultCalculator().calculate(
      attemptWith([50, 60, 70, 40, 30, 50, 40, 30, 20, 10]),
      validResultCatalog(),
      generation: 1,
    );
    expect(result.priorities.map((module) => module.topic), [
      QuestionTopic.passwords,
      QuestionTopic.access,
      QuestionTopic.networks,
    ]);
    expect(result.priorities.map((module) => module.points), [100, 100, 100]);
  });
}
