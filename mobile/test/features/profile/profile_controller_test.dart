import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/profile/application/profile_controller.dart';
import 'package:priva_mobile/features/profile/application/profile_state.dart';
import 'package:priva_mobile/features/profile/data/profile_details.dart';

import 'profile_test_fixtures.dart';

void main() {
  late ProfileHarness harness;
  late ProfileController controller;
  setUp(() async {
    harness = await ProfileHarness.create();
    controller = ProfileController(
      harness.account,
      harness.repository,
      timeout: const Duration(milliseconds: 20),
    );
  });
  tearDown(() {
    controller.dispose();
    harness.dispose();
  });
  test(
    'name synchronization never grants access or updates another identity',
    () async {
      harness.account.updateProfileName(uid: 'other', name: 'Wrong');
      expect(harness.account.state.session?.displayName, 'Old session name');
      await harness.account.signOut();
      harness.account.updateProfileName(uid: 'synthetic', name: 'Late');
      expect(harness.account.state.session, isNull);
      expect(harness.account.state.canAccessPrivate, isFalse);
    },
  );
  test('load, edit, cancel do not write or use stale session name', () async {
    expect(await controller.load(), isTrue);
    expect(controller.state.profile?.name, 'Persona de prueba');
    controller.beginEdit();
    controller.changeDraft('Borrador');
    controller.cancelEdit();
    expect(controller.state.profile?.name, 'Persona de prueba');
    expect(controller.state.draft, 'Persona de prueba');
    expect(harness.repository.writes, 0);
  });
  test(
    'confirmed save trims and synchronizes only the same session name',
    () async {
      await controller.load();
      controller.beginEdit();
      controller.changeDraft('  María  ');
      expect(await controller.save(), isTrue);
      expect(controller.state.profile?.name, 'María');
      expect(harness.account.state.session?.displayName, 'María');
      expect(harness.account.state.canAccessPrivate, isTrue);
    },
  );
  test(
    'whitespace rejected and failure preserves draft and confirmed name',
    () async {
      await controller.load();
      controller.beginEdit();
      controller.changeDraft('  ');
      expect(await controller.save(), isFalse);
      expect(harness.repository.writes, 0);
      controller.changeDraft('Nuevo');
      harness.repository.saver = (_, _) async =>
          throw StateError('private backend error');
      expect(await controller.save(), isFalse);
      expect(controller.state.phase, ProfilePhase.editing);
      expect(controller.state.profile?.name, 'Persona de prueba');
      expect(controller.state.draft, 'Nuevo');
      expect(controller.state.message, isNot(contains('private')));
    },
  );
  test('double save blocked and timeout reconciles before retry', () async {
    await controller.load();
    controller.beginEdit();
    controller.changeDraft('Nuevo');
    final pending = Completer<ProfileDetails>();
    harness.repository.saver = (_, _) => pending.future;
    final first = controller.save();
    expect(await controller.save(), isFalse);
    expect(await first, isFalse);
    expect(controller.state.phase, ProfilePhase.unknown);
    expect(controller.operationPending, isTrue);
    expect(await controller.save(), isFalse);
    pending.complete(
      const ProfileDetails(
        uid: 'synthetic',
        name: 'Nuevo',
        email: 'owner@example.test',
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(controller.state.profile?.name, 'Persona de prueba');
    harness.repository.name = 'Nuevo';
    expect(await controller.load(), isTrue);
    expect(controller.state.profile?.name, 'Nuevo');
    expect(harness.repository.writes, 1);
  });
  test(
    'signout clears draft immediately and late load never restores it',
    () async {
      final pending = Completer<ProfileDetails>();
      harness.repository.loader = (_) => pending.future;
      final loading = controller.load();
      await harness.account.signOut();
      pending.complete(
        const ProfileDetails(
          uid: 'synthetic',
          name: 'Old',
          email: 'owner@example.test',
        ),
      );
      expect(await loading, isFalse);
      expect(controller.state.profile, isNull);
      expect(controller.state.draft, isEmpty);
    },
  );
  test('wrong UID response cannot expose another profile', () async {
    harness.repository.loader = (_) async => const ProfileDetails(
      uid: 'other',
      name: 'Other',
      email: 'other@example.test',
    );
    expect(await controller.load(), isFalse);
    expect(controller.state.profile, isNull);
  });
  test(
    'leaving profile discards data and late save does not update session',
    () async {
      await controller.load();
      controller.beginEdit();
      controller.changeDraft('Nuevo');
      final pending = Completer<ProfileDetails>();
      harness.repository.saver = (_, _) => pending.future;
      final saving = controller.save();
      controller.deactivate();
      pending.complete(
        const ProfileDetails(
          uid: 'synthetic',
          name: 'Nuevo',
          email: 'owner@example.test',
        ),
      );
      expect(await saving, isFalse);
      expect(controller.state.profile, isNull);
      expect(harness.account.state.session?.displayName, 'Old session name');
    },
  );
}
