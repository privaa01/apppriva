import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';

import 'support/real_backend.dart';

void main() {
  test('real network outage cannot grant protected access', () async {
    final b = RealBackend();
    await b.start();
    addTearDown(b.close);
    await b.verified();
    await b.control('outage');
    try {
      expect(
        await b.controller.signIn(
          email: b.email,
          password: RealBackend.password,
        ),
        isFalse,
      );
      expect(b.controller.state.canAccessPrivate, isFalse);
    } finally {
      await b.control('restore-network');
    }
  });

  testWidgets(
    'real session loss removes protected content while Tips remains public',
    (tester) async {
      final b = RealBackend();
      await tester.runAsync(() async {
        await b.start();
        await b.verified();
        await b.login();
      });
      await tester.pumpWidget(
        PrivaApp(
          controller: b.controller,
          initialRoute: '/profile',
          destinationBuilder: (context, route) => Text('Destino:$route'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Destino:/profile'), findsOneWidget);
      await tester.runAsync(b.controller.signOut);
      await tester.pumpAndSettle();
      expect(find.text('Destino:/profile'), findsNothing);
      expect(canOpenDestination('/tips', b.controller.state), isTrue);
      expect(canOpenDestination('/profile', b.controller.state), isFalse);
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(b.close);
    },
  );
}
