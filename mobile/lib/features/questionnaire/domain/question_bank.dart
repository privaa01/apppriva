import 'question.dart';

class QuestionBank {
  QuestionBank({
    required this.contentVersion,
    required this.reviewedOn,
    required List<Question> questions,
  }) : questions = List.unmodifiable(questions) {
    final ids = questions.map((question) => question.id).toSet();
    if (contentVersion != 'question-bank-es-CO-2.0.1' ||
        reviewedOn != '2026-11-09' ||
        questions.length != 67 ||
        ids.length != 67 ||
        QuestionTopic.values.any(
          (topic) => !questions.any((question) => question.topic == topic),
        )) {
      throw const FormatException('Banco de preguntas no válido.');
    }
  }

  final String contentVersion;
  final String reviewedOn;
  final List<Question> questions;
}

class AttemptQuestion {
  const AttemptQuestion({required this.question, this.selectedOptionId});
  final Question question;
  final String? selectedOptionId;

  AttemptQuestion select(String optionId) {
    if (!question.options.any((option) => option.id == optionId)) {
      throw ArgumentError.value(optionId, 'optionId');
    }
    return AttemptQuestion(question: question, selectedOptionId: optionId);
  }
}

class ActiveAttempt {
  ActiveAttempt({required List<AttemptQuestion> questions, this.index = 0})
    : questions = List.unmodifiable(questions) {
    if (questions.length != 10 || index < 0 || index >= questions.length) {
      throw ArgumentError('Intento no válido.');
    }
  }
  final List<AttemptQuestion> questions;
  final int index;
  AttemptQuestion get current => questions[index];
  bool get isLast => index == questions.length - 1;

  ActiveAttempt select(String optionId) {
    final updated = [...questions];
    updated[index] = current.select(optionId);
    return ActiveAttempt(questions: updated, index: index);
  }

  ActiveAttempt next() {
    if (current.selectedOptionId == null || isLast) return this;
    return ActiveAttempt(questions: questions, index: index + 1);
  }

  ActiveAttempt previous() =>
      index == 0 ? this : ActiveAttempt(questions: questions, index: index - 1);
}

class CompletedAttempt {
  CompletedAttempt({required List<AttemptQuestion> questions})
    : questions = List.unmodifiable(questions) {
    if (questions.length != 10 ||
        questions.any((question) => question.selectedOptionId == null)) {
      throw ArgumentError('El intento está incompleto.');
    }
  }
  final List<AttemptQuestion> questions;
}
