import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:priva_mobile/features/navigation/data/temporary_journey.dart';
import 'package:priva_mobile/features/questionnaire/application/questionnaire_connectivity.dart';
import 'package:priva_mobile/features/questionnaire/application/questionnaire_controller.dart';
import 'package:priva_mobile/features/questionnaire/data/bundled_question_bank_repository.dart';
import 'package:priva_mobile/features/questionnaire/domain/question_selector.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('recorrido sintético completa diez respuestas solo en RAM', (_) async {
    final connectivity = AlwaysAvailableConnectivity();
    final controller = QuestionnaireController(
      BundledQuestionBankRepository(),
      connectivity,
      selector: QuestionSelector(random: Random(6)),
    );
    await controller.start();
    expect(controller.phase, JourneyPhase.attempt);
    for (var index = 0; index < 10; index++) {
      controller.select(controller.activeAttempt!.current.question.options.first.id);
      expect(controller.continueAttempt(), isTrue);
    }
    expect(controller.phase, JourneyPhase.result);
    expect(controller.completedAttempt!.questions, hasLength(10));
    controller.discard(DiscardReason.exit);
    expect(controller.completedAttempt, isNull);
    controller.dispose();
    connectivity.dispose();
  });
}
