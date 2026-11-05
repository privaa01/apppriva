import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';
import 'package:priva_mobile/features/tips/data/tip_content.dart';
import 'package:priva_mobile/features/tips/data/tips_repository.dart';

import '../account/ui_test_repository.dart';
import 'tips_test_fixtures.dart';

Future<void> scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    120,
    scrollable: find.byType(Scrollable).first,
    maxScrolls: 80,
  );
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
}

void main() {
  for (final identity in ['visitor', 'unverified', 'valid']) {
    for (final id in TipContent.ids) {
      testWidgets(
        'F04-ACCESS $identity can read $id, expand and return to catalog',
        (tester) async {
          final accounts = UiTestRepository();
          if (identity != 'visitor') {
            accounts.session = AccountSession(
              userId: 'synthetic',
              emailVerified: identity == 'valid',
              passwordAuthenticated: true,
            );
          }
          final account = AccountController(accounts);
          await account.initialize();
          final tips = TestTipsRepository();
          await tester.pumpWidget(
            PrivaApp(
              controller: account,
              initialRoute: '/tips/$id',
              tipsRepository: tips,
            ),
          );
          await tester.pumpAndSettle();
          final detail = tips.tips.singleWhere((e) => e.categoryId == id);
          expect(find.text(detail.title), findsOneWidget);
          final action = find.byKey(Key('tips.example.$id'));
          await scrollTo(tester, action);
          await tester.tap(action);
          await tester.pumpAndSettle();
          expect(find.text(detail.explanation), findsOneWidget);
          await tester.ensureVisible(action);
          await tester.tap(action);
          await tester.pumpAndSettle();
          expect(find.text(detail.explanation), findsOneWidget);
          expect(find.byType(TextField), findsNothing);
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
          expect(find.text('¡Tengo estos tips para ti!'), findsOneWidget);
          expect(find.byKey(const Key('tips.open.passwords')), findsOneWidget);
          await tester.pumpWidget(const SizedBox());
          account.dispose();
          await accounts.changes.close();
        },
      );
    }
  }
  testWidgets('F04-RECOVERY errors retry without requiring account', (
    tester,
  ) async {
    final accounts = UiTestRepository();
    final account = AccountController(accounts);
    await account.initialize();
    final repo = TestTipsRepository()
      ..failure = const TipsFailure(TipsFailureKind.error);
    await tester.pumpWidget(
      PrivaApp(
        controller: account,
        initialRoute: '/tips',
        tipsRepository: repo,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('No pudimos cargar los consejos. Inténtalo de nuevo.'),
      findsOneWidget,
    );
    repo.failure = null;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tips.open.links')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    account.dispose();
    await accounts.changes.close();
  });
}
