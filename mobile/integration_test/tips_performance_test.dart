import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/tips/data/tips_repository.dart';

import '../test/features/account/ui_test_repository.dart';
import '../test/features/tips/tips_test_fixtures.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final results = <String, List<Map<String, int>>>{};
  for (final operation in ['catalog', 'detail', 'retry', 'example']) {
    testWidgets('F04-NATIVE twenty samples: $operation', (tester) async {
      final samples = <Map<String, int>>[];
      for (var i = 0; i < 20; i++) {
        final accounts = UiTestRepository();
        final account = AccountController(accounts);
        await account.initialize();
        final tips = TestTipsRepository()
          ..latency = const Duration(milliseconds: 250);
        if (operation == 'retry') {
          tips.failure = const TipsFailure(TipsFailureKind.error);
        }
        final app = PrivaApp(
          controller: account,
          tipsRepository: tips,
          initialRoute: operation == 'detail' || operation == 'example'
              ? '/tips/passwords'
              : '/tips',
        );
        if (operation == 'retry' || operation == 'example') {
          await tester.pumpWidget(app);
          await tester.pumpAndSettle();
        }
        Finder? action;
        if (operation == 'retry') {
          tips.failure = null;
          action = find.text('Reintentar');
        } else if (operation == 'example') {
          action = find.byKey(const Key('tips.example.passwords'));
          await tester.scrollUntilVisible(
            action,
            100,
            scrollable: find.byType(Scrollable).first,
            maxScrolls: 80,
          );
          await tester.ensureVisible(action);
        }
        final clock = Stopwatch()..start();
        if (action != null) {
          await tester.tap(action);
        } else {
          await tester.pumpWidget(app);
        }
        await tester.pump();
        final feedback = clock.elapsedMilliseconds;
        await tester.pumpAndSettle();
        clock.stop();
        expect(feedback, lessThanOrEqualTo(1000));
        expect(clock.elapsedMilliseconds, lessThanOrEqualTo(15000));
        if (operation == 'catalog' || operation == 'retry') {
          expect(find.byKey(const Key('tips.open.passwords')), findsOneWidget);
        } else if (operation == 'example') {
          expect(
            find.byKey(const Key('tips.explanation.passwords')),
            findsOneWidget,
          );
        } else {
          expect(find.text('Contraseña segura.'), findsOneWidget);
        }
        samples.add({
          'feedbackMs': feedback,
          'completeMs': clock.elapsedMilliseconds,
        });
        await tester.pumpWidget(const SizedBox());
        account.dispose();
        await accounts.changes.close();
      }
      results[operation] = samples;
      binding.reportData = {
        'tipsPerformance': results,
        'profile': 'synthetic repository latency250ms; no hosted network',
      };
    });
  }
}
