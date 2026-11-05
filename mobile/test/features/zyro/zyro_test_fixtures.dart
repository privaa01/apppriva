import 'dart:async';

import 'package:priva_mobile/features/zyro/data/zyro_repository.dart';
import 'package:priva_mobile/features/zyro/domain/zyro_message.dart';
import 'package:priva_mobile/features/account/application/account_state.dart';

const syntheticAccountStates = <AccountSession?>[
  null,
  AccountSession(
    userId: 'synthetic-unverified',
    emailVerified: false,
    passwordAuthenticated: true,
  ),
  AccountSession(
    userId: 'synthetic-valid',
    emailVerified: true,
    passwordAuthenticated: true,
  ),
];

class ZyroCall {
  ZyroCall(this.requestId, this.message, this.context, this.completer);
  final String requestId;
  final String message;
  final List<ZyroMessage> context;
  final Completer<ZyroReply> completer;
}

class ControlledZyroRepository implements ZyroRepository {
  final calls = <ZyroCall>[];

  @override
  Future<ZyroReply> respond({
    required String requestId,
    required String message,
    required List<ZyroMessage> context,
  }) {
    final completer = Completer<ZyroReply>();
    calls.add(
      ZyroCall(requestId, message, List.unmodifiable(context), completer),
    );
    return completer.future;
  }

  void succeed(
    int index, {
    ZyroKind kind = ZyroKind.general,
    List<String> steps = const [],
    String text = 'Respuesta educativa',
  }) {
    final call = calls[index];
    call.completer.complete(
      ZyroReply(
        requestId: call.requestId,
        text: text,
        kind: kind,
        steps: steps,
        guideId: kind == ZyroKind.guide ? 'google-review-devices' : null,
        guideRevision: kind == ZyroKind.guide ? '2026-11-05' : null,
      ),
    );
  }

  void fail(int index) => calls[index].completer.completeError(
    const ZyroFailure(ZyroFailureKind.unavailable),
  );
}
