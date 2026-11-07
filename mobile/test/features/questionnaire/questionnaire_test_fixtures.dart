import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:priva_mobile/features/questionnaire/application/questionnaire_connectivity.dart';
import 'package:priva_mobile/features/questionnaire/data/question_bank_repository.dart';
import 'package:priva_mobile/features/questionnaire/domain/question.dart';
import 'package:priva_mobile/features/questionnaire/domain/question_bank.dart';

QuestionBank validBank() => QuestionBank(
      contentVersion: 'question-bank-es-CO-2.0.0',
      reviewedOn: '2026-11-07',
      questions: List.generate(67, (index) {
        final number = index + 1;
        return Question(
          id: 'Q${number.toString().padLeft(3, '0')}',
          version: 1,
          topic: QuestionTopic.values[index % QuestionTopic.values.length],
          prompt: 'Situación ficticia $number',
          options: const [
            QuestionOption(id: 'A', text: 'Opción A', vulnerabilityPercent: 5),
            QuestionOption(id: 'B', text: 'Opción B', vulnerabilityPercent: 40),
            QuestionOption(id: 'C', text: 'Opción C', vulnerabilityPercent: 90),
          ],
          sourceIds: const ['F04'],
        );
      }),
    );

class FakeBankRepository implements QuestionBankRepository {
  FakeBankRepository({QuestionBank? bank}) : bank = bank ?? validBank();
  final QuestionBank bank;
  final completer = Completer<void>();
  bool wait = false;
  int reads = 0;
  @override
  Future<QuestionBank> load() async {
    reads++;
    if (wait) await completer.future;
    return bank;
  }
}

class FakeConnectivity extends ChangeNotifier
    implements QuestionnaireConnectivity {
  FakeConnectivity([this._available = true]);
  bool _available;
  @override
  bool get available => _available;
  @override
  Future<void> initialize() async {}
  void setAvailable(bool value) {
    _available = value;
    notifyListeners();
  }
}
