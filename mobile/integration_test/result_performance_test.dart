import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:priva_mobile/features/navigation/data/temporary_journey.dart';
import 'package:priva_mobile/features/questionnaire/application/questionnaire_connectivity.dart';
import 'package:priva_mobile/features/questionnaire/application/questionnaire_controller.dart';
import 'package:priva_mobile/features/questionnaire/application/result_controller.dart';
import 'package:priva_mobile/features/questionnaire/data/bundled_question_bank_repository.dart';
import 'package:priva_mobile/features/questionnaire/data/bundled_result_recommendation_repository.dart';
import 'package:priva_mobile/features/questionnaire/domain/question_selector.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('veinte ciclos producen feedback y resultado dentro del límite', (
    _,
  ) async {
    final total = Stopwatch()..start();
    for (var cycle = 0; cycle < 20; cycle++) {
      final connectivity = AlwaysAvailableConnectivity();
      final journey = QuestionnaireController(
        BundledQuestionBankRepository(),
        connectivity,
        selector: QuestionSelector(random: Random(cycle)),
      );
      final result = ResultController(
        journey,
        BundledResultRecommendationRepository(),
      )..initialize();
      final feedback = Stopwatch()..start();
      await journey.start();
      feedback.stop();
      expect(feedback.elapsed, lessThan(const Duration(seconds: 1)));
      for (var index = 0; index < 10; index++) {
        journey.select(
          journey.activeAttempt!.current.question.options.first.id,
        );
        journey.continueAttempt();
      }
      await result.load();
      expect(result.phase, ResultPhase.ready);
      expect(result.beginRestart(), isTrue);
      expect(result.beginRestart(), isFalse);
      journey.discard(DiscardReason.exit);
      result.dispose();
      journey.dispose();
      connectivity.dispose();
    }
    total.stop();
    expect(total.elapsed, lessThan(const Duration(seconds: 15)));
  });
}
