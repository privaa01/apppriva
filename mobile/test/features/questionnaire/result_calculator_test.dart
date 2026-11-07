import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/questionnaire/domain/result_assessment.dart';
import 'package:priva_mobile/features/questionnaire/domain/result_calculator.dart';

import 'result_test_fixtures.dart';

void main() {
  const calculator = ResultCalculator();
  final cases = <(int, ResultLevel, String)>[
    (0, ResultLevel.low, '0'),
    (190, ResultLevel.low, '19'),
    (195, ResultLevel.low, '19,5'),
    (200, ResultLevel.medium, '20'),
    (590, ResultLevel.medium, '59'),
    (595, ResultLevel.medium, '59,5'),
    (600, ResultLevel.high, '60'),
    (1000, ResultLevel.high, '100'),
  ];
  for (final testCase in cases) {
    test('clasifica suma ${testCase.$1} sin redondear', () {
      final base = testCase.$1 ~/ 10;
      final remainder = testCase.$1 % 10;
      final values = List.filled(10, base);
      for (var index = 0; index < remainder; index++) {
        values[index]++;
      }
      final result = calculator.calculate(
        attemptWith(values),
        validResultCatalog(),
        generation: 2,
      );
      expect(result.totalPoints, testCase.$1);
      expect(result.level, testCase.$2);
      expect(result.formattedPercent, testCase.$3);
    });
  }
}
