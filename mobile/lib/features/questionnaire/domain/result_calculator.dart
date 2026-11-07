import '../data/result_recommendation_repository.dart';
import 'question.dart';
import 'question_bank.dart';
import 'result_assessment.dart';

class ResultCalculator {
  const ResultCalculator();

  ResultAssessment calculate(
    CompletedAttempt attempt,
    ResultRecommendationCatalog catalog, {
    required int generation,
  }) {
    final totals = {for (final topic in QuestionTopic.values) topic: 0};
    final counts = {for (final topic in QuestionTopic.values) topic: 0};
    var total = 0;
    for (final answered in attempt.questions) {
      final selected = answered.question.options.where(
        (option) => option.id == answered.selectedOptionId,
      );
      if (selected.length != 1) throw ArgumentError('Selección no válida.');
      final value = selected.first.vulnerabilityPercent;
      total += value;
      totals[answered.question.topic] =
          totals[answered.question.topic]! + value;
      counts[answered.question.topic] = counts[answered.question.topic]! + 1;
    }
    if (counts.values.any((count) => count != 2)) {
      throw ArgumentError('Cobertura de módulos no válida.');
    }
    final modules =
        QuestionTopic.values
            .map(
              (topic) => ModuleAssessment(
                topic: topic,
                points: totals[topic]!,
                actions: catalog.actions[topic]!,
              ),
            )
            .toList()
          ..sort((a, b) {
            final points = b.points.compareTo(a.points);
            return points != 0
                ? points
                : QuestionTopic.values
                      .indexOf(a.topic)
                      .compareTo(QuestionTopic.values.indexOf(b.topic));
          });
    final level = total < 200
        ? ResultLevel.low
        : total < 600
        ? ResultLevel.medium
        : ResultLevel.high;
    return ResultAssessment(
      totalPoints: total,
      level: level,
      priorities: modules.take(3).toList(),
      generation: generation,
    );
  }
}
