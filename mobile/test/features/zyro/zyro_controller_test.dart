import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/zyro/application/zyro_controller.dart';
import 'package:priva_mobile/features/zyro/domain/zyro_message.dart';

import 'zyro_test_fixtures.dart';

void main() {
  test('requires an owner and allows only one active request', () async {
    final repository = ControlledZyroRepository();
    final controller = ZyroController(repository);
    await controller.send('Sin sesión');
    expect(repository.calls, isEmpty);

    controller.owner('uid-1');
    final first = controller.send('Revisar dispositivos de Google');
    await controller.send('Segundo toque');
    expect(repository.calls, hasLength(1));
    expect(
      repository.calls.single.requestId,
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
    repository.succeed(0, kind: ZyroKind.guide);
    await first;
    expect(controller.messages, hasLength(2));
    expect(controller.messages.last.guideId, 'google-review-devices');
  });

  test('retry reuses request id and does not duplicate user bubble', () async {
    final repository = ControlledZyroRepository();
    final controller = ZyroController(repository)..owner('uid-1');
    final failed = controller.send('Consulta');
    repository.fail(0);
    await failed;
    expect(controller.error, isNotNull);
    final originalId = repository.calls.single.requestId;

    final retry = controller.retry();
    expect(repository.calls, hasLength(2));
    expect(repository.calls.last.requestId, originalId);
    repository.succeed(1);
    await retry;
    expect(
      controller.messages.where((m) => m.role == ZyroRole.user),
      hasLength(1),
    );
    expect(controller.error, isNull);
  });

  test(
    'route exit invalidates late response but retains conversation',
    () async {
      final repository = ControlledZyroRepository();
      final controller = ZyroController(repository)..owner('uid-1');
      final first = controller.send('Primera');
      repository.succeed(0);
      await first;
      expect(controller.messages, hasLength(2));

      final pending = controller.send('Pendiente');
      controller.leave();
      repository.succeed(1);
      await pending;
      expect(
        controller.messages.where((m) => m.text == 'Respuesta educativa'),
        hasLength(1),
      );
      expect(controller.messages, hasLength(3));
    },
  );

  test(
    'logout or UID change clears messages and discards late response',
    () async {
      final repository = ControlledZyroRepository();
      final controller = ZyroController(repository)..owner('uid-1');
      final pending = controller.send('Consulta');
      controller.owner(null);
      repository.succeed(0);
      await pending;
      expect(controller.messages, isEmpty);
      controller.owner('uid-2');
      expect(controller.messages, isEmpty);
    },
  );

  test('timeout becomes a recoverable generic error', () async {
    final repository = ControlledZyroRepository();
    final controller = ZyroController(
      repository,
      timeout: const Duration(milliseconds: 5),
    )..owner('uid-1');
    await controller.send('Consulta sin respuesta');
    expect(controller.busy, isFalse);
    expect(controller.error, contains('Inténtalo de nuevo'));
  });
}
