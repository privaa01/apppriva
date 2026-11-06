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

  testWidgets('veinte ciclos resuelven el intento dentro del límite', (_) async {
    final total = Stopwatch()..start();
    for (var cycle = 0; cycle < 20; cycle++) {
      final connectivity = AlwaysAvailableConnectivity();
      final controller = QuestionnaireController(
        BundledQuestionBankRepository(),
        connectivity,
        selector: QuestionSelector(random: Random(cycle)),
      );
      final feedback = Stopwatch()..start();
      await controller.start();
      controller.select(controller.activeAttempt!.current.question.options.first.id);
      feedback.stop();
      expect(feedback.elapsed, lessThan(const Duration(seconds: 1)));
      controller.select(controller.activeAttempt!.current.question.options.first.id);
      controller.discard(DiscardReason.background);
      expect(controller.activeAttempt, isNull);
      controller.dispose();
      connectivity.dispose();
    }
    total.stop();
    expect(total.elapsed, lessThan(const Duration(seconds: 15)));
  });
}
