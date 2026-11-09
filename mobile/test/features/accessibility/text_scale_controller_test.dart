import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/accessibility/application/text_scale_controller.dart';
import 'package:priva_mobile/features/accessibility/application/text_scale_preset.dart';
import 'package:priva_mobile/features/accessibility/data/text_scale_preferences.dart';

void main() {
  test('loads the saved preset and exposes all approved factors', () async {
    final preferences = MemoryTextScalePreferences(TextScalePreset.large);
    final controller = TextScaleController(preferences);

    await controller.initialize();

    expect(controller.preset, TextScalePreset.large);
    expect(TextScalePreset.values.map((value) => value.factor), [
      0.90,
      1.00,
      1.25,
      1.50,
    ]);
  });

  test(
    'changes immediately and does not write the same preset twice',
    () async {
      final preferences = _CountingPreferences();
      final controller = TextScaleController(preferences);
      await controller.initialize();

      final pending = controller.select(TextScalePreset.extraLarge);
      expect(controller.factor, 1.50);
      expect(controller.saving, isTrue);
      preferences.complete();
      await pending;
      await controller.select(TextScalePreset.extraLarge);

      expect(preferences.writes, 1);
    },
  );
}

class _CountingPreferences implements TextScalePreferences {
  int writes = 0;
  Completer<void>? pending;

  @override
  Future<TextScalePreset> load() async => TextScalePreset.normal;

  @override
  Future<void> save(TextScalePreset preset) {
    writes++;
    pending = Completer<void>();
    return pending!.future;
  }

  void complete() => pending!.complete();
}
