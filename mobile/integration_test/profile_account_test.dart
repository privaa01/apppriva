import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/profile/data/profile_repository.dart';

import 'support/profile_native_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('owned profile cancel/save/evidence/signout against Firebase', (
    tester,
  ) async {
    final h = await NativeProfileHarness.connect();
    addTearDown(h.close);
    final original = await h.repository.loadCurrent(expectedUid: h.uid);
    final evidence = h.database.collection('authorization_evidence').doc(h.uid);
    final before = (await evidence.get(const GetOptions(source: Source.server)))
        .data()!;
    try {
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          profileRepository: h.repository,
          initialRoute: '/profile',
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('profile.edit')));
      await tester.tap(find.byKey(const Key('profile.edit')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('profile.name')),
        'Borrador sintético',
      );
      await tester.ensureVisible(find.byKey(const Key('profile.cancel')));
      await tester.tap(find.byKey(const Key('profile.cancel')));
      await tester.pumpAndSettle();
      expect(
        (await h.repository.loadCurrent(expectedUid: h.uid)).name ==
            original.name,
        isTrue,
      );
      await tester.ensureVisible(find.byKey(const Key('profile.edit')));
      await tester.tap(find.byKey(const Key('profile.edit')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('profile.name')),
        'Prueba sintética de perfil',
      );
      await tester.ensureVisible(find.byKey(const Key('profile.save')));
      await tester.tap(find.byKey(const Key('profile.save')));
      await tester.pumpAndSettle();
      expect(
        (await h.repository.loadCurrent(expectedUid: h.uid)).name ==
            'Prueba sintética de perfil',
        isTrue,
      );
      final after = (await evidence.get(
        const GetOptions(source: Source.server),
      )).data()!;
      expect(after['authorized_at'] == before['authorized_at'], isTrue);
      expect(after['policy_version'] == before['policy_version'], isTrue);
      expect(after['action'] == before['action'], isTrue);
      expect(after['accepted'] == before['accepted'], isTrue);
      await expectLater(
        h.repository.loadCurrent(expectedUid: 'different-synthetic-uid'),
        throwsA(isA<ProfileFailure>()),
      );
      await h.repository.updateName(original.name, expectedUid: h.uid);
      await tester.ensureVisible(find.byKey(const Key('profile.signout')));
      await tester.tap(find.byKey(const Key('profile.signout')));
      await tester.pumpAndSettle();
      expect(h.account.state.canAccessPrivate, isFalse);
      expect(find.byKey(const Key('profile.email')), findsNothing);
      expect(find.byKey(const Key('signin.submit')), findsOneWidget);
    } finally {
      if (h.account.state.canAccessPrivate) {
        await h.repository.updateName(original.name, expectedUid: h.uid);
      }
      await tester.pumpWidget(const SizedBox());
      await h.close();
    }
  }, skip: !runHostedProfileTests);
}
