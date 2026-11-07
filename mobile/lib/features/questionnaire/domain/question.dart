enum QuestionTopic {
  passwords,
  authentication,
  sharing,
  links,
  profiles,
  permissions,
  sessions;

  static QuestionTopic parse(String value) => values.firstWhere(
        (topic) => topic.name == value,
        orElse: () => throw const FormatException('Tema no válido.'),
      );
}

class QuestionOption {
  const QuestionOption({required this.id, required this.text});

  final String id;
  final String text;
}

class Question {
  Question({
    required this.id,
    required this.version,
    required this.topic,
    required this.prompt,
    required List<QuestionOption> options,
    required this.correctOptionId,
    required this.explanation,
    required this.recommendation,
    required List<String> sourceIds,
  })  : options = List.unmodifiable(options),
        sourceIds = List.unmodifiable(sourceIds) {
    if (!RegExp(r'^Q(?:00[1-9]|0[12][0-9]|030)$').hasMatch(id) ||
        version != 1 ||
        prompt.trim().isEmpty ||
        explanation.trim().isEmpty ||
        recommendation.trim().isEmpty ||
        sourceIds.isEmpty ||
        options.length != 3 ||
        options.map((option) => option.id).toSet().length != 3 ||
        !options.map((option) => option.id).toSet().containsAll({'A', 'B', 'C'}) ||
        options.any((option) => option.text.trim().isEmpty) ||
        !options.any((option) => option.id == correctOptionId)) {
      throw const FormatException('Pregunta no válida.');
    }
  }

  final String id;
  final int version;
  final QuestionTopic topic;
  final String prompt;
  final List<QuestionOption> options;
  final String correctOptionId;
  final String explanation;
  final String recommendation;
  final List<String> sourceIds;

  Question withOptions(List<QuestionOption> shuffledOptions) => Question(
        id: id,
        version: version,
        topic: topic,
        prompt: prompt,
        options: shuffledOptions,
        correctOptionId: correctOptionId,
        explanation: explanation,
        recommendation: recommendation,
        sourceIds: sourceIds,
      );
}
