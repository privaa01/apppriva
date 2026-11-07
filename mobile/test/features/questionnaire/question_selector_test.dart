import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/questionnaire/domain/question_selector.dart';

import 'questionnaire_test_fixtures.dart';

void main() {
  test('selecciona diez IDs y dos preguntas por cada módulo', () {
    for (var seed = 0; seed < 25; seed++) {
      final selected = QuestionSelector(random: Random(seed)).select(validBank());
      expect(selected, hasLength(10));
      expect(selected.map((question) => question.id).toSet(), hasLength(10));
      final counts = <Object, int>{};
      for (final question in selected) {
        counts[question.topic] = (counts[question.topic] ?? 0) + 1;
        expect(question.options.map((option) => option.vulnerabilityPercent), everyElement(inInclusiveRange(0, 100)));
        final original = validBank().questions.firstWhere(
          (candidate) => candidate.id == question.id,
        );
        expect(
          {for (final option in question.options) option.id: option.vulnerabilityPercent},
          {for (final option in original.options) option.id: option.vulnerabilityPercent},
        );
      }
      expect(counts, hasLength(5));
      expect(counts.values.every((count) => count == 2), isTrue);
    }
  });
}
