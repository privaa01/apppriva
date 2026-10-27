import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';

import 'ui_test_repository.dart';

void main() {
  for (final route in ['/signin', '/signup', '/recovery']) {
    testWidgets('automated accessibility: $route', (tester) async {
      final semantics = tester.ensureSemantics();
      final repo = UiTestRepository();
      final controller = AccountController(repo);
      await controller.initialize();
      await tester.pumpWidget(
        PrivaApp(controller: controller, initialRoute: route),
      );
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      await repo.changes.close();
      semantics.dispose();
    });
  }
}
