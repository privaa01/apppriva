import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/connectivity/application/connectivity_controller.dart';
import 'package:priva_mobile/features/connectivity/presentation/connectivity_notice.dart';

import 'connectivity_test_fixtures.dart';

void main() {
  testWidgets('announces offline state and disables duplicate retry', (
    tester,
  ) async {
    final source = FakeConnectivitySource();
    final controller = ConnectivityController(source: source);
    await controller.initialize();
    final pending = Completer<void>();
    var calls = 0;

    final retry = controller.retry(() {
      calls++;
      return pending.future;
    });
    source.setAvailable(false);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ConnectivityNotice(
            controller: controller,
            onRetry: () async {},
            child: const Text('Contenido'),
          ),
        ),
      ),
    );

    expect(
      find.text('No hay conexión. Revisa Internet y vuelve a intentarlo.'),
      findsOneWidget,
    );
    final liveRegion = tester
        .widgetList<Semantics>(find.byType(Semantics))
        .any((widget) => widget.properties.liveRegion == true);
    expect(liveRegion, isTrue);

    expect(find.text('Intentando de nuevo…'), findsOneWidget);
    expect(
      tester.widget<TextButton>(find.byType(TextButton)).onPressed,
      isNull,
    );
    expect(calls, 1);
    pending.complete();
    await retry;
    await tester.pump();
    expect(calls, 1);
  });
}
