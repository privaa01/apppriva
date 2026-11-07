import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/question.dart';
import 'result_recommendation_repository.dart';

class BundledResultRecommendationRepository
    implements ResultRecommendationRepository {
  BundledResultRecommendationRepository({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;
  ResultRecommendationCatalog? _cache;

  @override
  Future<ResultRecommendationCatalog> load() async {
    if (_cache case final cached?) return cached;
    try {
      final raw = await _bundle.loadString(
        'assets/content/result-recommendations-1.0.0.json',
      );
      final json = jsonDecode(raw) as Map<String, dynamic>;
      if (!_hasExactKeys(json, const {
            'schemaVersion',
            'contentVersion',
            'status',
            'reviewedOn',
            'modules',
          }) ||
          json['schemaVersion'] != 1 ||
          json['contentVersion'] != 'result-recommendations-es-CO-1.0.0' ||
          json['status'] != 'approved' ||
          json['reviewedOn'] != '2026-11-07') {
        throw const FormatException();
      }
      final modules = json['modules'] as List<dynamic>;
      final actions = <QuestionTopic, List<String>>{};
      for (final row in modules) {
        final item = row as Map<String, dynamic>;
        if (!_hasExactKeys(item, const {'topic', 'actions'})) {
          throw const FormatException();
        }
        final topic = QuestionTopic.parse(item['topic'] as String);
        if (actions.containsKey(topic)) throw const FormatException();
        actions[topic] = (item['actions'] as List<dynamic>).cast<String>();
      }
      final catalog = ResultRecommendationCatalog(actions);
      _cache = catalog;
      return catalog;
    } catch (_) {
      throw const ResultRecommendationException();
    }
  }

  bool _hasExactKeys(Map<String, dynamic> value, Set<String> expected) =>
      value.keys.toSet().length == expected.length &&
      value.keys.toSet().containsAll(expected);
}
