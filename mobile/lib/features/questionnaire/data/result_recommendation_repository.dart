import '../domain/question.dart';

class ResultRecommendationCatalog {
  ResultRecommendationCatalog(Map<QuestionTopic, List<String>> actions)
    : actions = Map<QuestionTopic, List<String>>.unmodifiable({
        for (final entry in actions.entries)
          entry.key: List<String>.unmodifiable(entry.value),
      }) {
    if (actions.length != QuestionTopic.values.length ||
        QuestionTopic.values.any(
          (topic) =>
              actions[topic]?.length != 3 ||
              actions[topic]!.any((action) => action.trim().isEmpty),
        )) {
      throw const FormatException('Catálogo no válido.');
    }
  }
  final Map<QuestionTopic, List<String>> actions;
}

abstract interface class ResultRecommendationRepository {
  Future<ResultRecommendationCatalog> load();
}

class ResultRecommendationException implements Exception {
  const ResultRecommendationException();
}
