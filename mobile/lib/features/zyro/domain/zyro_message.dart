enum ZyroRole { user, zyro }

enum ZyroKind { general, guide, limit }

class ZyroMessage {
  const ZyroMessage({
    required this.id,
    required this.role,
    required this.text,
    this.kind = ZyroKind.general,
    this.steps = const [],
  });
  final String id;
  final ZyroRole role;
  final String text;
  final ZyroKind kind;
  final List<String> steps;
}
