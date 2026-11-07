import '../../navigation/data/temporary_journey.dart';
import '../data/question_bank_repository.dart';
import '../domain/question_bank.dart';
import '../domain/question_selector.dart';
import 'questionnaire_connectivity.dart';

enum QuestionnairePhase { idle, loading, active, paused, error, completed }

class QuestionnaireController extends TemporaryJourney {
  QuestionnaireController(
    this._repository,
    this._connectivity, {
    QuestionSelector? selector,
  }) : _selector = selector ?? QuestionSelector() {
    _connectivity.addListener(_connectivityChanged);
  }

  final QuestionBankRepository _repository;
  final QuestionnaireConnectivity _connectivity;
  final QuestionSelector _selector;
  QuestionnairePhase questionnairePhase = QuestionnairePhase.idle;
  ActiveAttempt? activeAttempt;
  CompletedAttempt? completedAttempt;
  int _generation = 0;
  bool _disposed = false;

  @override
  JourneyPhase get phase => switch (questionnairePhase) {
        QuestionnairePhase.completed => JourneyPhase.result,
        QuestionnairePhase.active || QuestionnairePhase.paused =>
          JourneyPhase.attempt,
        _ => JourneyPhase.idle,
      };
  @override
  int get generation => _generation;
  @override
  bool get canGoToPreviousQuestion =>
      activeAttempt != null && activeAttempt!.index > 0;

  Future<void> start() async {
    if (questionnairePhase == QuestionnairePhase.loading) return;
    final request = ++_generation;
    questionnairePhase = QuestionnairePhase.loading;
    notifyListeners();
    try {
      await _connectivity.initialize();
      final bank = await _repository.load();
      if (_disposed || request != _generation) {
        return;
      }
      activeAttempt = ActiveAttempt(
        questions: _selector
            .select(bank)
            .map((question) => AttemptQuestion(question: question))
            .toList(),
      );
      questionnairePhase = _connectivity.available
          ? QuestionnairePhase.active
          : QuestionnairePhase.paused;
    } catch (_) {
      if (_disposed || request != _generation) {
        return;
      }
      questionnairePhase = QuestionnairePhase.error;
    }
    notifyListeners();
  }

  void select(String optionId) {
    if (questionnairePhase != QuestionnairePhase.active ||
        activeAttempt == null) {
      return;
    }
    activeAttempt = activeAttempt!.select(optionId);
    notifyListeners();
  }

  bool continueAttempt() {
    final attempt = activeAttempt;
    if (questionnairePhase != QuestionnairePhase.active ||
        attempt == null ||
        attempt.current.selectedOptionId == null) {
      return false;
    }
    if (attempt.isLast) {
      completedAttempt = CompletedAttempt(questions: attempt.questions);
      activeAttempt = null;
      questionnairePhase = QuestionnairePhase.completed;
    } else {
      activeAttempt = attempt.next();
    }
    notifyListeners();
    return true;
  }

  @override
  void previousQuestion() {
    if (questionnairePhase != QuestionnairePhase.active ||
        activeAttempt == null) {
      return;
    }
    activeAttempt = activeAttempt!.previous();
    notifyListeners();
  }

  void _connectivityChanged() {
    if (activeAttempt == null) {
      return;
    }
    if (!_connectivity.available &&
        questionnairePhase == QuestionnairePhase.active) {
      questionnairePhase = QuestionnairePhase.paused;
      notifyListeners();
    } else if (_connectivity.available &&
        questionnairePhase == QuestionnairePhase.paused) {
      questionnairePhase = QuestionnairePhase.active;
      notifyListeners();
    }
  }

  @override
  void discard(DiscardReason reason) {
    _generation++;
    activeAttempt = null;
    completedAttempt = null;
    questionnairePhase = QuestionnairePhase.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _connectivity.removeListener(_connectivityChanged);
    activeAttempt = null;
    completedAttempt = null;
    super.dispose();
  }
}
