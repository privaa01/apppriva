import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:priva_mobile/features/accessibility/application/text_scale_preset.dart';
import 'package:priva_mobile/features/accessibility/data/shared_preferences_text_scale.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'uses normal when missing or unknown and stores one local key',
    () async {
      var store = await SharedPreferencesTextScale.create();
      expect(await store.load(), TextScalePreset.normal);

      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(SharedPreferencesTextScale.key, 'unknown');
      store = SharedPreferencesTextScale(preferences);
      expect(await store.load(), TextScalePreset.normal);

      await store.save(TextScalePreset.extraLarge);
      expect(preferences.getKeys(), {SharedPreferencesTextScale.key});
      expect(
        preferences.getString(SharedPreferencesTextScale.key),
        TextScalePreset.extraLarge.name,
      );
    },
  );
}
