import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/accessibility/application/text_scale_controller.dart';
import 'package:priva_mobile/features/accessibility/application/text_scale_preset.dart';
import 'package:priva_mobile/features/accessibility/data/text_scale_preferences.dart';

import '../features/profile/profile_test_fixtures.dart';

void main() {
  testWidgets('applies saved text scale to the whole app', (tester) async {
    final harness = await ProfileHarness.create();
    addTearDown(harness.dispose);
    final textScale = TextScaleController(
      MemoryTextScalePreferences(TextScalePreset.extraLarge),
    );
    await textScale.initialize();

    await tester.pumpWidget(
      PrivaApp(
        controller: harness.account,
        initialRoute: '/home',
        textScaleController: textScale,
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.text('Inicio').last);
    expect(MediaQuery.textScalerOf(context).scale(1), 1.5);
  });
}
