import 'package:flutter/foundation.dart';

enum JourneyPhase { idle, attempt, result }

enum DiscardReason { exit, background, session, dispose }

/// No answers, score or content may cross this navigation boundary.
abstract class TemporaryJourney extends ChangeNotifier {
  JourneyPhase get phase;
  int get generation;
  bool get canGoToPreviousQuestion;
  void previousQuestion();
  void discard(DiscardReason reason);
}

class EmptyTemporaryJourney extends TemporaryJourney {
  @override
  JourneyPhase get phase => JourneyPhase.idle;
  @override
  int get generation => 0;
  @override
  bool get canGoToPreviousQuestion => false;
  @override
  void previousQuestion() {}
  @override
  void discard(DiscardReason reason) {}
}
