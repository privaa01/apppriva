import 'package:flutter/foundation.dart';

import '../data/tip_content.dart';
import '../data/tips_repository.dart';

enum TipsPhase { loading, ready, error, unavailable }

class TipsController extends ChangeNotifier {
  TipsController(
    this.repository, {
    this.categoryId,
    this.timeout = const Duration(seconds: 15),
  });
  final TipsRepository repository;
  final String? categoryId;
  final Duration timeout;
  TipsPhase phase = TipsPhase.loading;
  List<TipContent> content = const [];
  bool exampleExpanded = false, passwordVisible = false;
  bool _disposed = false;
  int _generation = 0;
  Future<void>? _pending;
  Future<void> load() {
    if (_disposed) return Future<void>.value();
    if (_pending != null) return _pending!;
    final generation = ++_generation;
    content = const [];
    exampleExpanded = passwordVisible = false;
    phase = TipsPhase.loading;
    notifyListeners();
    return _pending = _run(generation);
  }

  Future<void> _run(int generation) async {
    try {
      final result = await Future<List<TipContent>>.sync(
        () => categoryId == null
            ? repository.loadCatalog()
            : repository.loadDetail(categoryId!).then((tip) => [tip]),
      ).timeout(timeout);
      if (_disposed || generation != _generation) return;
      content = List<TipContent>.unmodifiable(result);
      phase = TipsPhase.ready;
    } catch (error) {
      if (_disposed || generation != _generation) return;
      phase = error is TipsFailure && error.kind == TipsFailureKind.unavailable
          ? TipsPhase.unavailable
          : TipsPhase.error;
    } finally {
      if (!_disposed && generation == _generation) {
        _pending = null;
        notifyListeners();
      }
    }
  }

  void revealExample() {
    if (_disposed || phase != TipsPhase.ready || exampleExpanded) return;
    exampleExpanded = true;
    notifyListeners();
  }

  void togglePassword() {
    if (_disposed || phase != TipsPhase.ready || categoryId != 'passwords') {
      return;
    }
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void covered() {
    if (_disposed) return;
    _generation++;
    _pending = null;
    content = const [];
    exampleExpanded = passwordVisible = false;
    phase = TipsPhase.loading;
    // RouteAware can run during Navigator.build: notify only on the next load.
  }

  @override
  void dispose() {
    covered();
    _disposed = true;
    super.dispose();
  }
}
