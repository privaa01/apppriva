import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/navigation/data/temporary_journey.dart';
import 'package:priva_mobile/features/questionnaire/application/questionnaire_controller.dart';
import 'package:priva_mobile/features/questionnaire/application/result_controller.dart';

import 'questionnaire_test_fixtures.dart';
import 'result_test_fixtures.dart';

void main() {
  test('calcula una generación y elimina referencias al descartar', () async {
    final connectivity = FakeConnectivity();
    final journey = QuestionnaireController(FakeBankRepository(), connectivity);
    await journey.start();
    for (var index = 0; index < 10; index++) {
      journey.select(journey.activeAttempt!.current.question.options.first.id);
      journey.continueAttempt();
    }
    final repository = FakeResultRepository();
    final controller = ResultController(journey, repository)..initialize();
    await controller.load();
    expect(controller.phase, ResultPhase.ready);
    expect(controller.assessment, isNotNull);
    expect(repository.reads, 1);
    journey.discard(DiscardReason.background);
    expect(controller.assessment, isNull);
    controller.dispose();
    journey.dispose();
    connectivity.dispose();
  });

  test(
    'error editorial permite reintentar sin restaurar otro intento',
    () async {
      final connectivity = FakeConnectivity();
      final journey = QuestionnaireController(
        FakeBankRepository(),
        connectivity,
      );
      await journey.start();
      for (var index = 0; index < 10; index++) {
        journey.select(
          journey.activeAttempt!.current.question.options.first.id,
        );
        journey.continueAttempt();
      }
      final repository = FakeResultRepository(fail: true);
      final controller = ResultController(journey, repository)..initialize();
      await controller.load();
      expect(controller.phase, ResultPhase.error);
      repository.fail = false;
      await controller.load();
      expect(controller.phase, ResultPhase.ready);
      expect(controller.beginRestart(), isTrue);
      expect(controller.beginRestart(), isFalse);
      controller.dispose();
      journey.dispose();
      connectivity.dispose();
    },
  );
}
