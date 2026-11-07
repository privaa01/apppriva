import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../application/questionnaire_connectivity.dart';

class PlatformQuestionnaireConnectivity extends ChangeNotifier
    implements QuestionnaireConnectivity {
  PlatformQuestionnaireConnectivity({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();
  bool _started = false;
  @override
  Future<void> initialize() async {
    if (_started) return;
    _started = true;
    _subscription = _connectivity.onConnectivityChanged.listen(
      _update,
      onError: (_) {},
    );
    try {
      _update(await _connectivity.checkConnectivity());
    } catch (_) {
      // Keep the conservative initial state when the platform is unavailable.
    }
  }
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _available = true;
  @override
  bool get available => _available;

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
