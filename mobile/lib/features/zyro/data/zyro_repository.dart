import '../domain/zyro_message.dart';

class ZyroReply {
  ZyroReply({
    required this.requestId,
    required this.text,
    required this.kind,
    List<String> steps = const [],
    this.guideId,
    this.guideRevision,
  }) : steps = List.unmodifiable(steps) {
    if (requestId.trim().isEmpty ||
        text.trim().isEmpty ||
        steps.length > 6 ||
        steps.any((step) => step.trim().isEmpty)) {
      throw const ZyroFailure(ZyroFailureKind.invalidResponse);
    }
    if (kind == ZyroKind.guide &&
        ((guideId?.trim().isEmpty ?? true) ||
            (guideRevision?.trim().isEmpty ?? true))) {
      throw const ZyroFailure(ZyroFailureKind.invalidResponse);
    }
    if (kind != ZyroKind.guide && (guideId != null || guideRevision != null)) {
      throw const ZyroFailure(ZyroFailureKind.invalidResponse);
    }
    final url = RegExp(r'(https?://|www\.)', caseSensitive: false);
    if (url.hasMatch(text) || steps.any(url.hasMatch)) {
      throw const ZyroFailure(ZyroFailureKind.invalidResponse);
    }
  }
  final String requestId;
  final String text;
  final ZyroKind kind;
  final List<String> steps;
  final String? guideId;
  final String? guideRevision;
}

enum ZyroFailureKind { unavailable, timeout, invalidResponse, denied, limited }

class ZyroFailure implements Exception {
  const ZyroFailure(this.kind);
  final ZyroFailureKind kind;
}

abstract interface class ZyroRepository {
  Future<ZyroReply> respond({
    required String requestId,
    required String message,
    required List<ZyroMessage> context,
  });
}

class UnavailableZyroRepository implements ZyroRepository {
  const UnavailableZyroRepository();
  @override
  Future<ZyroReply> respond({
    required String requestId,
    required String message,
    required List<ZyroMessage> context,
  }) => Future.error(const ZyroFailure(ZyroFailureKind.unavailable));
}
