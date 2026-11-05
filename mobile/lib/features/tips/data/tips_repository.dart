import 'tip_content.dart';

enum TipsFailureKind { error, unavailable }

class TipsFailure implements Exception {
  const TipsFailure(this.kind);
  final TipsFailureKind kind;
}

abstract interface class TipsRepository {
  Future<List<TipContent>> loadCatalog();
  Future<TipContent> loadDetail(String id);
}

class UnavailableTipsRepository implements TipsRepository {
  const UnavailableTipsRepository();
  @override
  Future<List<TipContent>> loadCatalog() async =>
      throw const TipsFailure(TipsFailureKind.unavailable);
  @override
  Future<TipContent> loadDetail(String id) async =>
      throw const TipsFailure(TipsFailureKind.unavailable);
}
