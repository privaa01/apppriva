import 'package:priva_mobile/features/questionnaire/data/result_recommendation_repository.dart';
import 'package:priva_mobile/features/questionnaire/domain/question.dart';
import 'package:priva_mobile/features/questionnaire/domain/question_bank.dart';

CompletedAttempt attemptWith(List<int> values) {
  if (values.length != 10) throw ArgumentError();
  return CompletedAttempt(
    questions: List.generate(10, (index) {
      final question = Question(
        id: 'Q${(index + 1).toString().padLeft(3, '0')}',
        version: 1,
        topic: QuestionTopic.values[index % 5],
        prompt: 'Situación sintética ${index + 1}',
        options: [
          QuestionOption(
            id: 'A',
            text: 'Respuesta sintética A',
            vulnerabilityPercent: values[index],
          ),
          const QuestionOption(
            id: 'B',
            text: 'Respuesta sintética B',
            vulnerabilityPercent: 0,
          ),
          const QuestionOption(
            id: 'C',
            text: 'Respuesta sintética C',
            vulnerabilityPercent: 100,
          ),
        ],
        sourceIds: const ['fixture'],
      );
      return AttemptQuestion(question: question, selectedOptionId: 'A');
    }),
  );
}

ResultRecommendationCatalog validResultCatalog() =>
    ResultRecommendationCatalog({
      for (final topic in QuestionTopic.values)
        topic: List.generate(3, (index) => '${topic.name} action $index'),
    });

class FakeResultRepository implements ResultRecommendationRepository {
  FakeResultRepository({this.fail = false});
  bool fail;
  int reads = 0;
  @override
  Future<ResultRecommendationCatalog> load() async {
    reads++;
    if (fail) throw const ResultRecommendationException();
    return validResultCatalog();
  }
}
