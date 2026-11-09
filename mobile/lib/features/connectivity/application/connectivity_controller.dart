import 'package:flutter/foundation.dart';

import '../data/platform_connectivity_source.dart';
import 'connectivity_source.dart';
import 'connectivity_state.dart';

class ConnectivityController extends ChangeNotifier {
  ConnectivityController({ConnectivitySource? source})
    : _source = source ?? PlatformConnectivitySource();
  final ConnectivitySource _source;
  ConnectivityState _state = const ConnectivityState();
  ConnectivityState get state => _state;
  bool get initialized => _state.initialized;
  bool get available => _state.available;
  bool get retrying => _state.retrying;

  Future<void> initialize() async {
    if (initialized) return;
    _source.addListener(_sourceChanged);
    await _source.initialize();
    _state = _state.copyWith(initialized: true, available: _source.available);
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      await _source.initialize();
      _sourceChanged();
    } catch (_) {}
  }

  Future<void> retry(Future<void> Function() operation) async {
    if (!available || retrying) return;
    _state = _state.copyWith(retrying: true);
    notifyListeners();
    try {
      await operation();
    } finally {
      _state = _state.copyWith(retrying: false);
      notifyListeners();
    }
  }

  void _sourceChanged() {
    if (_source.available == available) return;
    _state = _state.copyWith(available: _source.available);
    notifyListeners();
  }

  @override
  void dispose() {
    _source.removeListener(_sourceChanged);
    if (_source is ChangeNotifier) (_source as ChangeNotifier).dispose();
    super.dispose();
  }
}
