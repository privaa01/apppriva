import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../application/connectivity_source.dart';

class PlatformConnectivitySource extends ChangeNotifier
    implements ConnectivitySource {
  PlatformConnectivitySource({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _initialized = false;
  bool _available = true;
  @override
  bool get available => _available;
  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    try {
      _update(await _connectivity.checkConnectivity());
      _subscription = _connectivity.onConnectivityChanged.listen(
        _update,
        onError: (_) {},
      );
    } catch (_) {
      // Remote repositories still report their own recoverable failures.
    }
  }

  void _update(List<ConnectivityResult> results) {
    final next = results.any((result) => result != ConnectivityResult.none);
    if (next == _available) return;
    _available = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
