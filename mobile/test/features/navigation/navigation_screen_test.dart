import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';

import '../profile/profile_test_fixtures.dart';

import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';

import '../account/ui_test_repository.dart';

import 'package:priva_mobile/features/navigation/data/destination_catalog.dart';

void main() {
  for (final identity in ['visitor', 'unverified', 'valid']) {
    testWidgets(
      'all catalog destinations enforce access for $identity before builder',
      (tester) async {
        final repo = UiTestRepository();
        if (identity != 'visitor') {
          repo.session = AccountSession(
            userId: 'synthetic',
            emailVerified: identity == 'valid',
            passwordAuthenticated: true,
          );
        }
        final account = AccountController(repo);
        await account.initialize();
        for (final destination in destinations.where(
          (d) => d.access != DestinationAccess.entry,
        )) {
          var calls = 0;
          await tester.pumpWidget(
            PrivaApp(
              controller: account,
              initialRoute: destination.path,
              destinationBuilder: (_, path) {
                calls++;
                return Text('content:$path');
              },
            ),
          );
          await tester.pumpAndSettle();
          final permitted =
              (destination.access == DestinationAccess.public ||
                  identity == 'valid') &&
              !destination.requiresResult;
          expect(
            find.text('content:${destination.path}'),
            permitted ? findsOneWidget : findsNothing,
            reason: destination.path,
          );
          if (!permitted) expect(calls, 0, reason: destination.path);
          await tester.pumpWidget(const SizedBox());
        }
        account.dispose();
        await repo.changes.close();
      },
    );
  }

  testWidgets(
    'P01 has approved educational tools and unknown path never invokes builder',
    (tester) async {
      final h = await ProfileHarness.create();
      await tester.pumpWidget(
        PrivaApp(controller: h.account, initialRoute: '/home'),
      );
      expect(
        find.text('Aprende hábitos para cuidar tu información'),
        findsOneWidget,
      );
      expect(
        find.text('Consulta a Zyro sobre privacidad y seguridad'),
        findsOneWidget,
      );
      expect(
        find.text('Reflexiona sobre tus hábitos digitales'),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
      var called = false;
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          initialRoute: '/arbitrary',
          destinationBuilder: (_, path) {
            called = true;
            return Text(path);
          },
        ),
      );
      expect(called, isFalse);
      await tester.pumpWidget(const SizedBox());
      h.dispose();
    },
  );
}
