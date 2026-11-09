import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/connectivity/application/connectivity_controller.dart';
import 'package:priva_mobile/features/connectivity/application/connectivity_source.dart';

void main() {
  test('reports loss and recovery without retrying automatically', () async {
    final source = _FakeSource();
    final controller = ConnectivityController(source: source);
    var calls = 0;
    await controller.initialize();

    source.setAvailable(false);
    expect(controller.available, isFalse);
    source.setAvailable(true);
    expect(controller.available, isTrue);
    expect(calls, 0);

    await controller.retry(() async => calls++);
    expect(calls, 1);
  });

  test('manual retry runs only one operation at a time', () async {
    final controller = ConnectivityController(source: _FakeSource());
    await controller.initialize();
    final pending = Completer<void>();
    var calls = 0;
    Future<void> operation() {
      calls++;
      return pending.future;
    }

    final first = controller.retry(operation);
    final second = controller.retry(operation);
    expect(calls, 1);
    expect(controller.retrying, isTrue);
    pending.complete();
    await Future.wait([first, second]);

    expect(calls, 1);
    expect(controller.retrying, isFalse);
  });
}

class _FakeSource extends ChangeNotifier implements ConnectivitySource {
  bool _available = true;

  @override
  bool get available => _available;

  @override
  Future<void> initialize() async {}

  void setAvailable(bool value) {
    _available = value;
    notifyListeners();
  }
}
