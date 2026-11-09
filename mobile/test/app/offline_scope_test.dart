import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/navigation/data/temporary_journey.dart';
import 'package:priva_mobile/features/questionnaire/application/questionnaire_controller.dart';
import 'package:priva_mobile/features/tips/data/tip_content.dart';
import 'package:priva_mobile/features/zyro/data/local_zyro_guide.dart';

import '../features/questionnaire/questionnaire_test_fixtures.dart';

void main() {
  test(
    'Tips and Zyro remain local while questionnaire pauses and discards',
    () async {
      expect(TipContent.ids, hasLength(4));
      expect(
        const LocalZyroGuide().answer('¿Cómo protejo mi cuenta?').kind,
        ZyroReplyKind.guidance,
      );

      final connectivity = FakeConnectivity(false);
      final questionnaire = QuestionnaireController(
        FakeBankRepository(),
        connectivity,
      );
      await questionnaire.start();
      expect(questionnaire.questionnairePhase, QuestionnairePhase.paused);
      expect(questionnaire.activeAttempt, isNotNull);

      questionnaire.discard(DiscardReason.background);
      expect(questionnaire.activeAttempt, isNull);
      expect(questionnaire.completedAttempt, isNull);
      expect(questionnaire.questionnairePhase, QuestionnairePhase.idle);
      questionnaire.dispose();
      connectivity.dispose();
    },
  );
}
