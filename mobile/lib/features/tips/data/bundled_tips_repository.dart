import 'dart:convert';

import 'package:flutter/services.dart';

import 'tip_content.dart';
import 'tips_repository.dart';

/// Reads the approved, immutable educational content packaged with the APK.
///
/// Account and profile features may still use Firebase; F04 never performs a
/// network request and remains available without a session or connectivity.
class BundledTipsRepository implements TipsRepository {
  BundledTipsRepository(
    this.bundle, {
    this.assetPath = 'assets/content/tips-1.0.0.json',
  });

  final AssetBundle bundle;
  final String assetPath;
  Future<Map<String, TipContent>>? _content;

  Future<Map<String, TipContent>> _load() => _content ??= _decode();

  Future<Map<String, TipContent>> _decode() async {
    try {
      final raw = await bundle.loadString(assetPath);
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic> ||
          decoded.length != TipContent.ids.length ||
          !TipContent.ids.every(decoded.containsKey)) {
        throw const FormatException();
      }
      final parsed = <String, TipContent>{};
      for (final id in TipContent.ids) {
        final value = decoded[id];
        if (value is! Map<String, dynamic>) throw const FormatException();
        parsed[id] = TipContent.parse(id, value);
      }
      return Map.unmodifiable(parsed);
    } catch (_) {
      throw const TipsFailure(TipsFailureKind.unavailable);
    }
  }

  @override
  Future<List<TipContent>> loadCatalog() async {
    final content = await _load();
    return List.unmodifiable(TipContent.ids.map((id) => content[id]!));
  }

  @override
  Future<TipContent> loadDetail(String id) async {
    if (!TipContent.ids.contains(id)) {
      throw const TipsFailure(TipsFailureKind.unavailable);
    }
    return (await _load())[id]!;
  }
}
