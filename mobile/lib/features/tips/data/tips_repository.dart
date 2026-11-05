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

/// Core can be retried without relying on a successful account authorization.
class DeferredTipsRepository implements TipsRepository {
  DeferredTipsRepository(this.initialize);
  final Future<TipsRepository> Function() initialize;
  Future<TipsRepository>? _repository;
  Future<T> _use<T>(Future<T> Function(TipsRepository) read) async {
    try {
      final repository = await (_repository ??= initialize());
      return await read(repository);
    } catch (_) {
      _repository = null;
      rethrow;
    }
  }

  @override
  Future<List<TipContent>> loadCatalog() => _use((r) => r.loadCatalog());
  @override
  Future<TipContent> loadDetail(String id) => _use((r) => r.loadDetail(id));
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
