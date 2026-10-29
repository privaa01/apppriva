import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/profile/data/deletion_contact_service.dart';

void main() {
  test(
    'a nonresponding native launcher yields a recoverable fallback',
    () async {
      final pending = Completer<bool>();
      final service = PlatformDeletionContactService(
        launch: (_) => pending.future,
        timeout: const Duration(milliseconds: 5),
      );
      expect(await service.openDraft(), isFalse);
      pending.complete(
        true,
      ); // A timeout does not cancel an already requested action.
    },
  );

  test('opens only an explicit generic draft, not a sent request', () async {
    Uri? uri;
    var calls = 0;
    final service = PlatformDeletionContactService(
      launch: (value) async {
        uri = value;
        calls++;
        return true;
      },
    );
    expect(calls, 0);
    expect(await service.openDraft(), isTrue);
    expect(calls, 1);
    expect(uri?.scheme, 'mailto');
    expect(uri?.path, supportEmail);
    expect(
      uri?.queryParameters['subject'],
      'Solicitud de eliminación de datos de Priva',
    );
    expect(uri.toString(), contains('%20'));
    expect(uri.toString(), isNot(contains('+')));
    expect(uri?.queryParameters.keys.toSet(), {'subject', 'body'});
    expect(uri.toString(), isNot(contains('uid')));
  });
  test('unavailable client and platform exception yield fallback', () async {
    expect(
      await PlatformDeletionContactService(launch: (_) async => false)
          .openDraft(),
      isFalse,
    );
    expect(
      await PlatformDeletionContactService(
        launch: (_) async => throw StateError('native details'),
      ).openDraft(),
      isFalse,
    );
  });
  test('copy writes only public address after explicit call', () async {
    String? copied;
    final service = PlatformDeletionContactService(
      copy: (value) async {
        copied = value;
      },
    );
    expect(copied, isNull);
    expect(await service.copyAddress(), isTrue);
    expect(copied, supportEmail);
    expect(
      await PlatformDeletionContactService(
        copy: (_) async => throw StateError('native'),
      ).copyAddress(),
      isFalse,
    );
  });
}
