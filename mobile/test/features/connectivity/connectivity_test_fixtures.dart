import 'package:flutter/foundation.dart';
import 'package:priva_mobile/features/connectivity/application/connectivity_source.dart';

class FakeConnectivitySource extends ChangeNotifier
    implements ConnectivitySource {
  FakeConnectivitySource([this._available = true]);
  bool _available;
  @override
  bool get available => _available;
  @override
  Future<void> initialize() async {}
  void setAvailable(bool value) {
    _available = value;
    notifyListeners();
  }
}
