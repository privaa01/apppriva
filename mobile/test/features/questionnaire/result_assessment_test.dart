import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/questionnaire/domain/question.dart';
import 'package:priva_mobile/features/questionnaire/domain/question_bank.dart';
import 'package:priva_mobile/features/questionnaire/domain/result_assessment.dart';
import 'package:priva_mobile/features/questionnaire/domain/result_calculator.dart';

import 'result_test_fixtures.dart';

void main() {
  test('resultado exige total, tres prioridades y generación válidos', () {
    final catalog = validResultCatalog();
    final modules = catalog.actions.entries
        .take(3)
        .map(
          (entry) => ModuleAssessment(
            topic: entry.key,
            points: 50,
            actions: entry.value,
          ),
        )
        .toList();
    expect(
      () => ResultAssessment(
        totalPoints: 1001,
        level: ResultLevel.high,
        priorities: modules,
        generation: 1,
      ),
      throwsArgumentError,
    );
    expect(
      () => ResultAssessment(
        totalPoints: 100,
        level: ResultLevel.low,
        priorities: modules.take(2).toList(),
        generation: 1,
      ),
      throwsArgumentError,
    );
  });

  test('rechaza option ID ajeno y cobertura distinta de dos por módulo', () {
    final valid = attemptWith(List.filled(10, 50));
    final unknownOption = CompletedAttempt(
      questions: [
        AttemptQuestion(
          question: valid.questions.first.question,
          selectedOptionId: 'NO-EXISTE',
        ),
        ...valid.questions.skip(1),
      ],
    );
    expect(
      () => const ResultCalculator().calculate(
        unknownOption,
        validResultCatalog(),
        generation: 1,
      ),
      throwsArgumentError,
    );

    final wrongCoverage = CompletedAttempt(
      questions: valid.questions.map((answered) {
        final original = answered.question;
        return AttemptQuestion(
          question: Question(
            id: original.id,
            version: original.version,
            topic: QuestionTopic.passwords,
            prompt: original.prompt,
            options: original.options,
            sourceIds: original.sourceIds,
          ),
          selectedOptionId: answered.selectedOptionId,
        );
      }).toList(),
    );
    expect(
      () => const ResultCalculator().calculate(
        wrongCoverage,
        validResultCatalog(),
        generation: 1,
      ),
      throwsArgumentError,
    );
  });
}
