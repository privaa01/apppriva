import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/accessibility/application/text_scale_controller.dart';
import 'package:priva_mobile/features/accessibility/application/text_scale_preset.dart';
import 'package:priva_mobile/features/accessibility/data/text_scale_preferences.dart';
import 'package:priva_mobile/features/profile/presentation/profile_screen.dart';

import 'profile_test_fixtures.dart';

void main() {
  testWidgets('profile offers four readable presets and persists selection', (
    tester,
  ) async {
    final harness = await ProfileHarness.create();
    addTearDown(harness.dispose);
    final preferences = MemoryTextScalePreferences();
    final textScale = TextScaleController(preferences);
    await textScale.initialize();

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          account: harness.account,
          repository: harness.repository,
          contact: FakeDeletionContact(),
          textScaleController: textScale,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tamaño del texto'), findsOneWidget);
    for (final preset in TextScalePreset.values) {
      expect(find.text(preset.label), findsOneWidget);
    }

    final option = find.byKey(const Key('profile.textScale.extraLarge'));
    await tester.ensureVisible(option);
    await tester.tap(option);
    await tester.pumpAndSettle();

    expect(textScale.preset, TextScalePreset.extraLarge);
    expect(preferences.value, TextScalePreset.extraLarge);
    expect(harness.repository.writes, 0);
  });
}
