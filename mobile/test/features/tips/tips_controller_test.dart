import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/tips/application/tips_controller.dart';
import 'package:priva_mobile/features/tips/data/tip_content.dart';
import 'package:priva_mobile/features/tips/data/tips_repository.dart';

import 'tips_test_fixtures.dart';

void main() {
  test('F04-RECOVERY failed request retries same destination; explanation is idempotent', () async {
    final repo = TestTipsRepository()
      ..failure = const TipsFailure(TipsFailureKind.error);
    final c = TipsController(repo, categoryId: 'passwords');
    await c.load();
    expect(c.phase, TipsPhase.error);
    repo.failure = null;
    await c.load();
    expect(c.phase, TipsPhase.ready);
    c.revealExample();
    c.revealExample();
    expect(c.exampleExpanded, isTrue);
    c.togglePassword();
    expect(c.passwordVisible, isTrue);
    expect(c.exampleExpanded, isTrue);
    c.togglePassword();
    expect(c.passwordVisible, isFalse);
    c.dispose();
  });
  test('F04-RECOVERY duplicate loads group; late covered response cannot replace current', () async {
    final old = Completer<List<TipContent>>();
    final repo = TestTipsRepository()..pending = old;
    final c = TipsController(repo);
    final first = c.load();
    final duplicate = c.load();
    expect(identical(first, duplicate), isTrue);
    expect(repo.calls, 1);
    c.covered();
    repo.pending = null;
    await c.load();
    expect(c.phase, TipsPhase.ready);
    old.complete([]);
    await first;
    expect(c.content, hasLength(4));
    c.dispose();
  });
  test(
    'F04-RECOVERY timeout, unavailable and dispose keep late updates out',
    () async {
      final old = Completer<List<TipContent>>();
      final repo = TestTipsRepository()..pending = old;
      final c = TipsController(repo, timeout: const Duration(milliseconds: 1));
      await c.load();
      expect(c.phase, TipsPhase.error);
      c.dispose();
      old.complete([]);
      await Future<void>.delayed(Duration.zero);
      final r = TestTipsRepository()
        ..failure = const TipsFailure(TipsFailureKind.unavailable);
      final unavailable = TipsController(r);
      await unavailable.load();
      expect(unavailable.phase, TipsPhase.unavailable);
      unavailable.dispose();
    },
  );
}
