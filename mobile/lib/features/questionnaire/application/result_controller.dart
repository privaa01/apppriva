import 'package:flutter/foundation.dart';

import '../data/result_recommendation_repository.dart';
import '../domain/result_assessment.dart';
import '../domain/result_calculator.dart';
import 'questionnaire_controller.dart';

enum ResultPhase { loading, ready, error, restarting }

class ResultController extends ChangeNotifier {
  ResultController(
    this._journey,
    this._repository, [
    this._calculator = const ResultCalculator(),
  ]);

  final QuestionnaireController _journey;
  final ResultRecommendationRepository _repository;
  final ResultCalculator _calculator;
  ResultPhase phase = ResultPhase.loading;
  ResultAssessment? assessment;
  int _request = 0;
  bool _disposed = false;

  void initialize() => _journey.addListener(_journeyChanged);

  void _journeyChanged() {
    if (_journey.completedAttempt != null) return;
    _request++;
    assessment = null;
    phase = ResultPhase.error;
    if (!_disposed) notifyListeners();
  }

  Future<void> load() async {
    final completed = _journey.completedAttempt;
    final generation = _journey.generation;
    if (completed == null) {
      phase = ResultPhase.error;
      notifyListeners();
      return;
    }
    final request = ++_request;
    phase = ResultPhase.loading;
    assessment = null;
    notifyListeners();
    try {
      final catalog = await _repository.load();
      if (_disposed ||
          request != _request ||
          generation != _journey.generation) {
        return;
      }
      assessment = _calculator.calculate(
        completed,
        catalog,
        generation: generation,
      );
      phase = ResultPhase.ready;
    } catch (_) {
      if (_disposed || request != _request) return;
      phase = ResultPhase.error;
    }
    notifyListeners();
  }

  bool beginRestart() {
    if (phase != ResultPhase.ready) return false;
    phase = ResultPhase.restarting;
    assessment = null;
    _request++;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _disposed = true;
    _journey.removeListener(_journeyChanged);
    _request++;
    assessment = null;
    super.dispose();
  }
}
