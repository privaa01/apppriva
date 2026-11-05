enum ZyroRole { user, zyro }

enum ZyroKind { general, guide, limit }

class ZyroMessage {
  ZyroMessage({
    required this.id,
    required this.role,
    required this.text,
    this.kind = ZyroKind.general,
    List<String> steps = const [],
    this.guideId,
    this.guideRevision,
  }) : steps = List.unmodifiable(steps) {
    if (id.trim().isEmpty ||
        text.trim().isEmpty ||
        steps.length > 6 ||
        steps.any((step) => step.trim().isEmpty) ||
        (role == ZyroRole.user && text.length > 1000)) {
      throw const FormatException('Invalid Zyro message');
    }
    final actionableUrl = RegExp(r'(https?://|www\.)', caseSensitive: false);
    if (role == ZyroRole.zyro &&
        (actionableUrl.hasMatch(text) || steps.any(actionableUrl.hasMatch))) {
      throw const FormatException('Actionable URLs are not allowed');
    }
    if (kind == ZyroKind.guide &&
        ((guideId?.trim().isEmpty ?? true) ||
            (guideRevision?.trim().isEmpty ?? true))) {
      throw const FormatException('Guide metadata is required');
    }
    if (kind != ZyroKind.guide && (guideId != null || guideRevision != null)) {
      throw const FormatException('Guide metadata is not allowed');
    }
  }
  final String id;
  final ZyroRole role;
  final String text;
  final ZyroKind kind;
  final List<String> steps;
  final String? guideId;
  final String? guideRevision;
}
