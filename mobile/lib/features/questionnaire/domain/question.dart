enum QuestionTopic {
  passwords,
  access,
  networks,
  phishing,
  devices;

  static QuestionTopic parse(String value) => values.firstWhere(
        (topic) => topic.name == value,
        orElse: () => throw const FormatException('Tema no válido.'),
      );
}

class QuestionOption {
  const QuestionOption({
    required this.id,
    required this.text,
    required this.vulnerabilityPercent,
  });

  final String id;
  final String text;
  final int vulnerabilityPercent;
}

class Question {
  Question({
    required this.id,
    required this.version,
    required this.topic,
    required this.prompt,
    required List<QuestionOption> options,
    required List<String> sourceIds,
  })  : options = List.unmodifiable(options),
        sourceIds = List.unmodifiable(sourceIds) {
    if (!RegExp(r'^Q(?:00[1-9]|0[1-5][0-9]|06[0-7])$').hasMatch(id) ||
        version != 1 ||
        prompt.trim().isEmpty ||
        sourceIds.isEmpty ||
        options.length != 3 ||
        options.map((option) => option.id).toSet().length != 3 ||
        !options.map((option) => option.id).toSet().containsAll({'A', 'B', 'C'}) ||
        options.any(
          (option) =>
              option.text.trim().isEmpty ||
              option.vulnerabilityPercent < 0 ||
              option.vulnerabilityPercent > 100,
        )) {
      throw const FormatException('Pregunta no válida.');
    }
  }

  final String id;
  final int version;
  final QuestionTopic topic;
  final String prompt;
  final List<QuestionOption> options;
  final List<String> sourceIds;

  Question withOptions(List<QuestionOption> shuffledOptions) => Question(
        id: id,
        version: version,
        topic: topic,
        prompt: prompt,
        options: shuffledOptions,
        sourceIds: sourceIds,
      );
}
