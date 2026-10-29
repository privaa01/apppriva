import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/profile/presentation/profile_screen.dart';

import 'profile_test_fixtures.dart';

void main() {
  late ProfileHarness h;
  late FakeDeletionContact contact;
  setUp(() async {
    h = await ProfileHarness.create();
    contact = FakeDeletionContact();
  });
  tearDown(() {
    h.dispose();
  });
  Future<void> open(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          account: h.account,
          repository: h.repository,
          contact: contact,
        ),
        routes: {
          '/signin': (_) => const Scaffold(body: Text('Acceso de prueba')),
        },
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  testWidgets('root routing denies visitor profile before any read', (
    tester,
  ) async {
    await h.account.signOut();
    await tester.pumpWidget(
      PrivaApp(
        controller: h.account,
        initialRoute: '/profile',
        profileRepository: h.repository,
        deletionContactService: contact,
      ),
    );
    await tester.pumpAndSettle();
    expect(h.repository.loads, 0);
    expect(find.byKey(const Key('signin.submit')), findsOneWidget);
    expect(find.text('owner@example.test'), findsNothing);
  });
  testWidgets(
    'covering profile discards draft and returning reloads server name',
    (tester) async {
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          initialRoute: '/profile',
          profileRepository: h.repository,
          deletionContactService: contact,
        ),
      );
      await tester.pumpAndSettle();
      await tap(tester, 'profile.edit');
      await tester.enterText(
        find.byKey(const Key('profile.name')),
        'Private draft',
      );
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tips'));
      await tester.pumpAndSettle();
      h.repository.name = 'Confirmado en servidor';
      tester.state<NavigatorState>(find.byType(Navigator).first).pop();
      await tester.pumpAndSettle();
      expect(find.text('Hola, Confirmado en servidor.'), findsOneWidget);
      expect(find.text('Private draft'), findsNothing);
      expect(h.repository.writes, 0);
    },
  );
  testWidgets(
    'root signout removes history and direct profile route stays guarded',
    (tester) async {
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          initialRoute: '/profile',
          profileRepository: h.repository,
          deletionContactService: contact,
        ),
      );
      await tester.pumpAndSettle();
      await tap(tester, 'profile.signout');
      final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
      expect(nav.canPop(), isFalse);
      nav.pushNamed('/profile');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('signin.submit')), findsOneWidget);
      expect(find.text('owner@example.test'), findsNothing);
    },
  );
  testWidgets('profile shows owned confirmed data and email is not editable', (
    tester,
  ) async {
    await open(tester);
    expect(find.text('Hola, Persona de prueba.'), findsOneWidget);
    expect(find.text('owner@example.test'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
    expect(find.textContaining('Teléfono'), findsNothing);
    await tap(tester, 'profile.edit');
    expect(find.byType(TextFormField), findsOneWidget);
    await tester.enterText(find.byKey(const Key('profile.name')), 'Borrador');
    await tap(tester, 'profile.cancel');
    expect(h.repository.writes, 0);
    expect(find.text('Hola, Persona de prueba.'), findsOneWidget);
  });
  testWidgets('save confirms the name and preserves readonly email', (
    tester,
  ) async {
    await open(tester);
    await tap(tester, 'profile.edit');
    await tester.enterText(find.byKey(const Key('profile.name')), 'María');
    await tap(tester, 'profile.save');
    expect(find.text('Hola, María.'), findsOneWidget);
    expect(find.text('owner@example.test'), findsOneWidget);
    expect(h.repository.writes, 1);
  });
  testWidgets(
    'deletion opens draft only on request and fallback copies address',
    (tester) async {
      contact.available = false;
      await open(tester);
      await tap(tester, 'profile.delete.info');
      expect(contact.opened, 0);
      await tap(tester, 'profile.delete.open');
      expect(contact.opened, 1);
      await tap(tester, 'profile.delete.copy');
      expect(contact.copied, 1);
      expect(find.text('Correo copiado.'), findsOneWidget);
      expect(h.repository.writes, 0);
      expect(h.account.state.canAccessPrivate, isTrue);
      expect(find.text('Solicitud enviada'), findsNothing);
    },
  );
  testWidgets('signout removes private navigation immediately', (tester) async {
    await open(tester);
    await tap(tester, 'profile.signout');
    expect(find.text('Acceso de prueba'), findsOneWidget);
    expect(find.text('owner@example.test'), findsNothing);
    expect(h.account.state.canAccessPrivate, isFalse);
    expect(h.auth.signOutCalls, 1);
  });
}
