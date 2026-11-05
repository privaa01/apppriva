import '../domain/zyro_message.dart';

class ZyroReply {
  const ZyroReply({
    required this.requestId,
    required this.text,
    required this.kind,
    this.steps = const [],
  });
  final String requestId;
  final String text;
  final ZyroKind kind;
  final List<String> steps;
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
  }) => Future.error(StateError('unavailable'));
}
