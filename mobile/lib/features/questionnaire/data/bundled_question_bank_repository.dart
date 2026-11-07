import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/question.dart';
import '../domain/question_bank.dart';
import 'question_bank_repository.dart';

class BundledQuestionBankRepository implements QuestionBankRepository {
  BundledQuestionBankRepository({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;
  QuestionBank? _cache;

  @override
  Future<QuestionBank> load() async {
    final cached = _cache;
    if (cached != null) return cached;
    try {
      final raw = await _bundle.loadString(
        'assets/content/questionnaire-2.0.0.json',
      );
      final json = jsonDecode(raw) as Map<String, dynamic>;
      if (json['schemaVersion'] != 2 || json['status'] != 'approved') {
        throw const FormatException();
      }
      final rows = json['questions'] as List<dynamic>;
      final questions = rows.map((row) {
        final value = row as Map<String, dynamic>;
        final options = (value['options'] as List<dynamic>)
            .map((option) {
              final item = option as Map<String, dynamic>;
              return QuestionOption(
                id: item['id'] as String,
                text: item['text'] as String,
                vulnerabilityPercent: item['vulnerabilityPercent'] as int,
              );
            })
            .toList();
        return Question(
          id: value['id'] as String,
          version: value['version'] as int,
          topic: QuestionTopic.parse(value['topic'] as String),
          prompt: value['prompt'] as String,
          options: options,
          sourceIds: (value['sourceIds'] as List<dynamic>).cast<String>(),
        );
      }).toList();
      final bank = QuestionBank(
        contentVersion: json['contentVersion'] as String,
        reviewedOn: json['reviewedOn'] as String,
        questions: questions,
      );
      _cache = bank;
      return bank;
    } catch (_) {
      throw const QuestionBankException();
    }
  }
}
