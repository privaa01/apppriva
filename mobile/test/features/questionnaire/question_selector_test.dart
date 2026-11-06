import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/questionnaire/domain/question_selector.dart';

import 'questionnaire_test_fixtures.dart';

void main() {
  test('selecciona diez IDs, cubre siete temas y limita dos por tema', () {
    for (var seed = 0; seed < 25; seed++) {
      final selected = QuestionSelector(random: Random(seed)).select(validBank());
      expect(selected, hasLength(10));
      expect(selected.map((question) => question.id).toSet(), hasLength(10));
      final counts = <Object, int>{};
      for (final question in selected) {
        counts[question.topic] = (counts[question.topic] ?? 0) + 1;
        expect(
          question.options.any((option) => option.id == question.correctOptionId),
          isTrue,
        );
      }
      expect(counts, hasLength(7));
      expect(counts.values.every((count) => count <= 2), isTrue);
    }
  });
}
