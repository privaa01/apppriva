import 'dart:math';

import 'question.dart';
import 'question_bank.dart';

class QuestionSelector {
  QuestionSelector({Random? random}) : _random = random ?? Random.secure();
  final Random _random;

  List<Question> select(QuestionBank bank) {
    final grouped = <QuestionTopic, List<Question>>{
      for (final topic in QuestionTopic.values)
        topic: bank.questions.where((question) => question.topic == topic).toList(),
    };
    final selected = <Question>[];
    for (final topic in QuestionTopic.values) {
      final candidates = [...grouped[topic]!]..shuffle(_random);
      selected.add(candidates.removeLast());
      grouped[topic] = candidates;
    }
    final extraTopics = QuestionTopic.values.toList()..shuffle(_random);
    for (final topic in extraTopics.take(3)) {
      selected.add(grouped[topic]!.removeLast());
    }
    selected.shuffle(_random);
    return List.unmodifiable(selected.map((question) {
      final options = [...question.options]..shuffle(_random);
      return question.withOptions(options);
    }));
  }
}
