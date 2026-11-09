import 'package:priva_mobile/features/accessibility/application/text_scale_preset.dart';
import 'package:priva_mobile/features/accessibility/data/text_scale_preferences.dart';

class FakeTextScalePreferences implements TextScalePreferences {
  FakeTextScalePreferences([this.value = TextScalePreset.normal]);
  TextScalePreset value;
  int reads = 0;
  int writes = 0;
  @override
  Future<TextScalePreset> load() async {
    reads++;
    return value;
  }

  @override
  Future<void> save(TextScalePreset preset) async {
    writes++;
    value = preset;
  }
}
