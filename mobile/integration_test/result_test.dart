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

  testWidgets('calcula, repite y descarta el resultado solo en RAM', (_) async {
    final connectivity = AlwaysAvailableConnectivity();
    final journey = QuestionnaireController(
      BundledQuestionBankRepository(),
      connectivity,
      selector: QuestionSelector(random: Random(7)),
    );
    final result = ResultController(
      journey,
      BundledResultRecommendationRepository(),
    )..initialize();

    await journey.start();
    for (var index = 0; index < 10; index++) {
      journey.select(journey.activeAttempt!.current.question.options.first.id);
      expect(journey.continueAttempt(), isTrue);
    }
    await result.load();
    expect(result.phase, ResultPhase.ready);
    expect(result.assessment!.priorities, hasLength(3));

    expect(result.beginRestart(), isTrue);
    expect(result.beginRestart(), isFalse);
    journey.discard(DiscardReason.exit);
    await journey.start();
    expect(journey.completedAttempt, isNull);
    expect(journey.phase, JourneyPhase.attempt);

    result.dispose();
    journey.dispose();
    connectivity.dispose();
  });
}
