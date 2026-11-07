import 'question.dart';

enum ResultLevel { low, medium, high }

class ModuleAssessment {
  ModuleAssessment({
    required this.topic,
    required this.points,
    required List<String> actions,
  }) : actions = List.unmodifiable(actions) {
    if (points < 0 || points > 200 || actions.length != 3) {
      throw ArgumentError('Evaluación de módulo no válida.');
    }
  }
  final QuestionTopic topic;
  final int points;
  final List<String> actions;
}

class ResultAssessment {
  ResultAssessment({
    required this.totalPoints,
    required this.level,
    required List<ModuleAssessment> priorities,
    required this.generation,
  }) : priorities = List.unmodifiable(priorities) {
    if (totalPoints < 0 ||
        totalPoints > 1000 ||
        priorities.length != 3 ||
        generation < 0) {
      throw ArgumentError('Resultado no válido.');
    }
  }
  final int totalPoints;
  final ResultLevel level;
  final List<ModuleAssessment> priorities;
  final int generation;

  double get percent => totalPoints / 10;
  String get formattedPercent => totalPoints % 10 == 0
      ? '${totalPoints ~/ 10}'
      : '${totalPoints ~/ 10},${totalPoints % 10}';
}
