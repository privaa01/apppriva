import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/profile/data/profile_details.dart';

import '../profile/profile_test_fixtures.dart';

void main() {
  testWidgets(
    'profile saving blocks common controls without cancelling write',
    (tester) async {
      final h = await ProfileHarness.create();
      final pending = Completer<ProfileDetails>();
      h.repository.saver = (_, _) => pending.future;
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          initialRoute: '/profile',
          profileRepository: h.repository,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Editar nombre'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Nombre nuevo');
      await tester.ensureVisible(find.byKey(const Key('profile.save')));
      await tester.tap(find.byKey(const Key('profile.save')));
      await tester.pump();
      await tester.tap(find.text('Tips').first);
      await tester.pump();
      expect(find.byKey(const Key('profile.name')), findsOneWidget);
      expect(h.repository.writes, 1);
      pending.complete(
        const ProfileDetails(
          uid: 'synthetic',
          name: 'Nombre nuevo',
          email: 'owner@example.test',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
      h.dispose();
    },
  );
}
