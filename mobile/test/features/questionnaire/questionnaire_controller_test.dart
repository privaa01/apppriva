import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/navigation/data/temporary_journey.dart';
import 'package:priva_mobile/features/questionnaire/application/questionnaire_controller.dart';
import 'package:priva_mobile/features/questionnaire/domain/question_selector.dart';

import 'questionnaire_test_fixtures.dart';

void main() {
  test('exige selección, permite revisión y completa solo diez respuestas', () async {
    final connectivity = FakeConnectivity();
    final controller = QuestionnaireController(
      FakeBankRepository(),
      connectivity,
      selector: QuestionSelector(random: Random(4)),
    );
    await controller.start();
    expect(controller.phase, JourneyPhase.attempt);
    expect(controller.continueAttempt(), isFalse);
    for (var index = 0; index < 10; index++) {
      controller.select(controller.activeAttempt!.current.question.options.first.id);
      expect(controller.continueAttempt(), isTrue);
    }
    expect(controller.phase, JourneyPhase.result);
    expect(controller.completedAttempt!.questions, hasLength(10));
    controller.discard(DiscardReason.exit);
    expect(controller.phase, JourneyPhase.idle);
    expect(controller.completedAttempt, isNull);
    controller.dispose();
    connectivity.dispose();
  });

  test('pausa y reanuda el mismo intento cuando cambia la conexión', () async {
    final connectivity = FakeConnectivity();
    final controller = QuestionnaireController(FakeBankRepository(), connectivity);
    await controller.start();
    final ids = controller.activeAttempt!.questions.map((item) => item.question.id).toList();
    connectivity.setAvailable(false);
    expect(controller.questionnairePhase, QuestionnairePhase.paused);
    connectivity.setAvailable(true);
    expect(controller.questionnairePhase, QuestionnairePhase.active);
    expect(
      controller.activeAttempt!.questions.map((item) => item.question.id),
      ids,
    );
    controller.dispose();
    connectivity.dispose();
  });
}
