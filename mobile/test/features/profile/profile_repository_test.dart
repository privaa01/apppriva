import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/profile/data/firestore_profile_repository.dart';
import 'package:priva_mobile/features/profile/data/profile_repository.dart';

import '../account/firebase_account_test.dart' as fixtures;

class OtherProviderToken extends fixtures.Token {
  OtherProviderToken() : super(true);
  @override
  String? get signInProvider => 'anonymous';
}

class OtherProviderIdentity extends fixtures.Identity {
  @override
  Future<OtherProviderToken> getIdTokenResult([
    bool forceRefresh = false,
  ]) async => OtherProviderToken();
}

class Documents implements ProfileDocuments {
  String? name = 'Anterior';
  int writes = 0;
  Completer<void>? waiting;
  @override
  Future<String?> readName(String uid) async {
    if (waiting != null) await waiting!.future;
    return name;
  }

  @override
  Future<String> updateName(
    String uid,
    String name,
    Future<void> Function() validate,
  ) async {
    await validate();
    if (waiting != null) await waiting!.future;
    await validate();
    writes++;
    this.name = name;
    return name;
  }
}

void main() {
  late fixtures.Auth auth;
  late fixtures.Store consent;
  late Documents docs;
  late FirestoreProfileRepository repository;
  setUp(() {
    auth = fixtures.Auth(fixtures.Identity());
    consent = fixtures.Store()..recorded = true;
    docs = Documents();
    repository = FirestoreProfileRepository.withStores(auth, docs, consent);
  });
  test('a non-password identity cannot read or update the profile', () async {
    auth.user = OtherProviderIdentity();
    await expectLater(
      repository.loadCurrent(expectedUid: 'synthetic'),
      throwsA(isA<ProfileFailure>()),
    );
    await expectLater(
      repository.updateName('Nuevo', expectedUid: 'synthetic'),
      throwsA(isA<ProfileFailure>()),
    );
    expect(docs.writes, 0);
  });
  test(
    'reads confirmed name and identity email without writing evidence',
    () async {
      final profile = await repository.loadCurrent(expectedUid: 'synthetic');
      expect(profile.name, 'Anterior');
      expect(profile.email, 'test@example.test');
      expect(docs.writes, 0);
      expect(consent.recorded, isTrue);
    },
  );
  test('updates only the name after validation, preserving consent', () async {
    final profile = await repository.updateName(
      '  María José  ',
      expectedUid: 'synthetic',
    );
    expect(profile.name, 'María José');
    expect(docs.writes, 1);
    expect(consent.name, isNull);
  });
  test('empty names never reach the document store', () async {
    await expectLater(
      repository.updateName(' \t\n ', expectedUid: 'synthetic'),
      throwsA(isA<ProfileFailure>()),
    );
    expect(docs.writes, 0);
  });
  test(
    'missing, unverified and unconsented identities cannot read or write',
    () async {
      for (final identity in [null, fixtures.Identity(verified: false)]) {
        auth.user = identity;
        await expectLater(
          repository.loadCurrent(expectedUid: 'synthetic'),
          throwsA(isA<ProfileFailure>()),
        );
      }
      auth.user = fixtures.Identity();
      consent.recorded = false;
      await expectLater(
        repository.updateName('Nuevo', expectedUid: 'synthetic'),
        throwsA(isA<ProfileFailure>()),
      );
      expect(docs.writes, 0);
    },
  );
  test(
    'a captured different UID is rejected before accessing documents',
    () async {
      await expectLater(
        repository.updateName('Nuevo', expectedUid: 'other'),
        throwsA(isA<ProfileFailure>()),
      );
      expect(docs.writes, 0);
    },
  );
  test(
    'missing server profile is an error, not a displayName fallback',
    () async {
      docs.name = null;
      await expectLater(
        repository.loadCurrent(expectedUid: 'synthetic'),
        throwsA(isA<ProfileFailure>()),
      );
    },
  );
  test('signout during a read discards its result', () async {
    docs.waiting = Completer<void>();
    final pending = repository.loadCurrent(expectedUid: 'synthetic');
    final assertion = expectLater(pending, throwsA(isA<ProfileFailure>()));
    await Future<void>.delayed(Duration.zero);
    auth.user = null;
    docs.waiting!.complete();
    await assertion;
  });
  test('signout during transaction prevents a late update', () async {
    docs.waiting = Completer<void>();
    final pending = repository.updateName('Nuevo', expectedUid: 'synthetic');
    final assertion = expectLater(pending, throwsA(isA<ProfileFailure>()));
    await Future<void>.delayed(Duration.zero);
    auth.user = null;
    docs.waiting!.complete();
    await assertion;
    expect(docs.writes, 0);
  });
}
