import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';

import 'profile_test_fixtures.dart';

void main() {
  for (final state in ['ready', 'editing', 'error', 'deletion']) {
    testWidgets(
      'profile accessible labels, targets and text contrast: $state',
      (tester) async {
        final semantics = tester.ensureSemantics();
        final h = await ProfileHarness.create();
        if (state == 'error') {
          h.repository.loader = (_) async => throw StateError('synthetic');
        }
        await tester.pumpWidget(
          PrivaApp(
            controller: h.account,
            initialRoute: '/profile',
            profileRepository: h.repository,
            deletionContactService: FakeDeletionContact(),
          ),
        );
        await tester.pumpAndSettle();
        if (state == 'editing' || state == 'deletion') {
          final key = state == 'editing'
              ? 'profile.edit'
              : 'profile.delete.info';
          await tester.ensureVisible(find.byKey(Key(key)));
          await tester.tap(find.byKey(Key(key)));
          await tester.pumpAndSettle();
        }
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        await tester.pumpWidget(const SizedBox());
        h.dispose();
        semantics.dispose();
      },
    );
  }
  testWidgets(
    'profile text and significant component colors meet contrast thresholds',
    (tester) async {
      final h = await ProfileHarness.create();
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          initialRoute: '/profile',
          profileRepository: h.repository,
          deletionContactService: FakeDeletionContact(),
        ),
      );
      await tester.pumpAndSettle();
      final colors = Theme.of(
        tester.element(find.byKey(const Key('profile.edit'))),
      ).colorScheme;
      double ratio(Color a, Color b) {
        final x = a.computeLuminance(), y = b.computeLuminance();
        return ((x > y ? x : y) + 0.05) / ((x < y ? x : y) + 0.05);
      }

      expect(
        ratio(colors.onSurface, colors.surface),
        greaterThanOrEqualTo(4.5),
      );
      expect(ratio(colors.error, colors.surface), greaterThanOrEqualTo(4.5));
      expect(
        ratio(colors.onPrimary, colors.primary),
        greaterThanOrEqualTo(4.5),
      );
      expect(ratio(colors.primary, colors.surface), greaterThanOrEqualTo(3));
      expect(ratio(colors.outline, colors.surface), greaterThanOrEqualTo(3));
      await tester.pumpWidget(const SizedBox());
      h.dispose();
    },
  );
  testWidgets(
    'profile edit at text 200 percent with keyboard remains operable',
    (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final h = await ProfileHarness.create();
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          initialRoute: '/profile',
          profileRepository: h.repository,
          deletionContactService: FakeDeletionContact(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(2),
              viewInsets: const EdgeInsets.only(bottom: 200),
            ),
            child: child!,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('profile.edit')));
      await tester.tap(find.byKey(const Key('profile.edit')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('profile.name')));
      await tester.tap(find.byKey(const Key('profile.name')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('profile.save')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('profile.save')).hitTestable(),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      h.dispose();
    },
  );
}
