import 'package:shared_preferences/shared_preferences.dart';

import '../application/text_scale_preset.dart';
import 'text_scale_preferences.dart';

class SharedPreferencesTextScale implements TextScalePreferences {
  SharedPreferencesTextScale(this.preferences);

  static const key = 'priva.text_scale';
  final SharedPreferences preferences;

  static Future<SharedPreferencesTextScale> create() async =>
      SharedPreferencesTextScale(await SharedPreferences.getInstance());

  @override
  Future<TextScalePreset> load() async =>
      TextScalePreset.fromStorage(preferences.getString(key));

  @override
  Future<void> save(TextScalePreset preset) async {
    final saved = await preferences.setString(key, preset.name);
    if (!saved) throw StateError('Preference was not saved');
  }
}
