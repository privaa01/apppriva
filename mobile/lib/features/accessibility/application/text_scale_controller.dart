import 'package:flutter/foundation.dart';

import '../data/text_scale_preferences.dart';
import 'text_scale_preset.dart';

class TextScaleController extends ChangeNotifier {
  TextScaleController(this.preferences);

  final TextScalePreferences preferences;
  TextScalePreset _preset = TextScalePreset.normal;
  bool _initialized = false;
  bool _saving = false;
  String? _message;

  TextScalePreset get preset => _preset;
  double get factor => _preset.factor;
  bool get initialized => _initialized;
  bool get saving => _saving;
  String? get message => _message;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      _preset = await preferences.load();
    } catch (_) {
      _preset = TextScalePreset.normal;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> select(TextScalePreset value) async {
    if (value == _preset || _saving) return;
    _preset = value;
    _saving = true;
    _message = null;
    notifyListeners();
    try {
      await preferences.save(value);
    } catch (_) {
      _message =
          'El tamaño cambió, pero no pudimos recordarlo para la próxima vez.';
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}
