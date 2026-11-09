import '../application/text_scale_preset.dart';

abstract interface class TextScalePreferences {
  Future<TextScalePreset> load();
  Future<void> save(TextScalePreset preset);
}

class MemoryTextScalePreferences implements TextScalePreferences {
  MemoryTextScalePreferences([this.value = TextScalePreset.normal]);

  TextScalePreset value;

  @override
  Future<TextScalePreset> load() async => value;

  @override
  Future<void> save(TextScalePreset preset) async {
    value = preset;
  }
}
