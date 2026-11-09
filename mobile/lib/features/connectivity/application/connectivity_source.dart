import 'package:flutter/foundation.dart';

abstract interface class ConnectivitySource implements Listenable {
  bool get available;
  Future<void> initialize();
}
