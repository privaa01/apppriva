import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/zyro_repository.dart';
import '../domain/zyro_message.dart';

class ZyroController extends ChangeNotifier {
  ZyroController(this.repository, {this.timeout = const Duration(seconds: 15)});
  final ZyroRepository repository;
  final Duration timeout;
  final messages = <ZyroMessage>[];
  bool busy = false;
  String? error;
  String? _uid;
  int _generation = 0;
  String? _retryText;
  String? _retryRequestId;
  String? get failedDraft => error == null ? null : _retryText;
  void owner(String? uid) {
    if (_uid != uid) {
      _uid = uid;
      clear();
    }
  }

  String _id() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  Future<void> send(String raw, {String? retryRequestId}) async {
    final text = raw.trim();
    if (busy || text.isEmpty || text.length > 1000 || _uid == null) return;
    final requestId = retryRequestId ?? _id();
    _retryText = text;
    _retryRequestId = requestId;
    error = null;
    busy = true;
    messages.add(ZyroMessage(id: requestId, role: ZyroRole.user, text: text));
    notifyListeners();
    final generation = _generation;
    try {
      final reply = await repository
          .respond(requestId: requestId, message: text, context: messages)
          .timeout(timeout);
      if (generation != _generation || _uid == null) return;
      messages.add(
        ZyroMessage(
          id: '$requestId-reply',
          role: ZyroRole.zyro,
          text: reply.text,
          kind: reply.kind,
          steps: reply.steps,
          guideId: reply.guideId,
          guideRevision: reply.guideRevision,
        ),
      );
    } catch (_) {
      if (generation == _generation) {
        error = 'No pudimos obtener una respuesta. Inténtalo de nuevo.';
      }
    } finally {
      if (generation == _generation) {
        busy = false;
        if (error == null) {
          _retryText = null;
          _retryRequestId = null;
        }
        notifyListeners();
      }
    }
  }

  Future<void> retry() async {
    final text = _retryText;
    if (text == null || busy) return;
    if (messages.isNotEmpty && messages.last.role == ZyroRole.user) {
      messages.removeLast();
    }
    await send(text, retryRequestId: _retryRequestId);
  }

  void leave() {
    _generation++;
    busy = false;
    error = null;
    notifyListeners();
  }

  void clear() {
    _generation++;
    messages.clear();
    busy = false;
    error = null;
    _retryText = null;
    _retryRequestId = null;
    notifyListeners();
  }
}
