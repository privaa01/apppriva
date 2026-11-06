import '../domain/question_bank.dart';

abstract interface class QuestionBankRepository {
  Future<QuestionBank> load();
}

class QuestionBankException implements Exception {
  const QuestionBankException();
}
