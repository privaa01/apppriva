import 'dart:async';
import 'dart:convert';

import 'tips_fixture_payload.dart';

import 'package:priva_mobile/features/tips/data/tip_content.dart';
import 'package:priva_mobile/features/tips/data/tips_repository.dart';

Map<String, dynamic> approvedTipsPayload() =>
    jsonDecode(tipsFixtureJson) as Map<String, dynamic>;

class TestTipsRepository implements TipsRepository {
  final payload = approvedTipsPayload();
  int calls = 0;
  Duration latency = Duration.zero;
  TipsFailure? failure;
  Completer<List<TipContent>>? pending;
  List<TipContent> get tips => TipContent.ids
      .map(
        (id) =>
            TipContent.parse(id, Map<String, dynamic>.from(payload[id] as Map)),
      )
      .toList();
  @override
  Future<List<TipContent>> loadCatalog() async {
    calls++;
    if (latency != Duration.zero) await Future<void>.delayed(latency);
    if (failure != null) throw failure!;
    if (pending != null) return pending!.future;
    return tips;
  }

  @override
  Future<TipContent> loadDetail(String id) async =>
      (await loadCatalog()).singleWhere((tip) => tip.categoryId == id);
}
