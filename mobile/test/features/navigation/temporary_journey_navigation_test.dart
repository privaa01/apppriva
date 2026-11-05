import 'package:flutter/material.dart';
import 'package:priva_mobile/app/priva_app.dart';

import '../profile/profile_test_fixtures.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/navigation/application/navigation_controller.dart';
import 'package:priva_mobile/features/navigation/application/navigation_state.dart';
import 'package:priva_mobile/features/navigation/data/temporary_journey.dart';

import '../account/ui_test_repository.dart';

import 'package:priva_mobile/features/account/application/account_controller.dart';

class SyntheticJourney extends TemporaryJourney {
  JourneyPhase value = JourneyPhase.idle;
  int epoch = 0;
  int question = 0;
  int discarded = 0;
  @override
  JourneyPhase get phase => value;
  @override
  int get generation => epoch;
  @override
  bool get canGoToPreviousQuestion => question > 0;
  void start({int at = 0, bool result = false}) {
    value = result ? JourneyPhase.result : JourneyPhase.attempt;
    question = at;
    epoch++;
    notifyListeners();
  }

  @override
  void previousQuestion() {
    if (question > 0) {
      question--;
      notifyListeners();
    }
  }

  @override
  void discard(DiscardReason reason) {
    if (value == JourneyPhase.idle) return;
    value = JourneyPhase.idle;
    question = 0;
    epoch++;
    discarded++;
    notifyListeners();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'unprivileged owner cannot keep or create synthetic result state',
    () async {
      final repo = UiTestRepository();
      final account = AccountController(repo);
      final journey = SyntheticJourney()..start(result: true);
      final nav = NavigationController(account, journey);
      expect(journey.phase, JourneyPhase.idle);
      journey.start();
      expect(journey.phase, JourneyPhase.idle);
      expect(journey.discarded, 2);
      nav.dispose();
      journey.dispose();
      account.dispose();
      await repo.changes.close();
    },
  );

  testWidgets(
    'system back reviews a question before offering exit from the first',
    (tester) async {
      final h = await ProfileHarness.create();
      final journey = SyntheticJourney()..start(at: 1);
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          temporaryJourney: journey,
          initialRoute: '/questionnaire',
        ),
      );
      await tester.pumpAndSettle();
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      await navigator.maybePop();
      await tester.pumpAndSettle();
      expect(journey.question, 0);
      expect(find.text('¿Quieres salir?'), findsNothing);
      await navigator.maybePop();
      await tester.pumpAndSettle();
      expect(find.text('¿Quieres salir?'), findsOneWidget);
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(journey.phase, JourneyPhase.attempt);
      await tester.pumpWidget(const SizedBox());
      journey.dispose();
      h.dispose();
    },
  );

  testWidgets(
    'cancel preserves attempt, confirm discards before reaching Tips',
    (tester) async {
      final h = await ProfileHarness.create();
      final journey = SyntheticJourney()..start();
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          temporaryJourney: journey,
          initialRoute: '/questionnaire',
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tips'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(journey.phase, JourneyPhase.attempt);
      expect(journey.discarded, 0);
      await tester.tap(find.text('Tips'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Salir'));
      await tester.pumpAndSettle();
      expect(journey.phase, JourneyPhase.idle);
      expect(journey.discarded, 1);
      expect(find.text('¡Tengo estos tips para ti!'), findsOneWidget);
      expect(find.text('Tips'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      journey.dispose();
      h.dispose();
    },
  );
  testWidgets(
    'completion can enter result; leaving and back cannot restore it',
    (tester) async {
      final h = await ProfileHarness.create();
      final journey = SyntheticJourney()..start(result: true);
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          temporaryJourney: journey,
          initialRoute: '/questionnaire',
          destinationBuilder: (_, path) => Text('synthetic:$path'),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.text('synthetic:/questionnaire'));
      final nav = NavigationScope.maybeOf(context)!;
      await nav.navigate(context, '/results');
      await tester.pumpAndSettle();
      expect(journey.phase, JourneyPhase.result);
      expect(find.text('synthetic:/results'), findsOneWidget);
      await tester.tap(find.text('Tips'));
      await tester.pumpAndSettle();
      expect(journey.phase, JourneyPhase.idle);
      tester.state<NavigatorState>(find.byType(Navigator).first).pop();
      await tester.pumpAndSettle();
      expect(find.text('synthetic:/results'), findsNothing);
      expect(find.text('No hay un resultado disponible'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      journey.dispose();
      h.dispose();
    },
  );
  testWidgets(
    'session invalidation during dialog rejects intent and removes private history',
    (tester) async {
      final h = await ProfileHarness.create();
      final journey = SyntheticJourney()..start();
      await tester.pumpWidget(
        PrivaApp(
          controller: h.account,
          temporaryJourney: journey,
          initialRoute: '/questionnaire',
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tips'));
      await tester.pumpAndSettle();
      await h.account.signOut();
      await tester.pumpAndSettle();
      expect(find.text('¿Quieres salir?'), findsNothing);
      expect(journey.phase, JourneyPhase.idle);
      expect(find.byKey(const Key('signin.submit')), findsOneWidget);
      final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
      expect(nav.canPop(), isFalse);
      await tester.pumpWidget(const SizedBox());
      journey.dispose();
      h.dispose();
    },
  );

  test('synthetic attempt back reviews; leaving requires confirmation; saving blocks', () async {
    final repo = UiTestRepository();
    final account = AccountController(repo);
    await account.initialize();
    await account.signIn(
      email: 'synthetic@example.test',
      password: 'Synthetic123!',
    );
    final journey = SyntheticJourney()..start(at: 1);
    final nav = NavigationController(account, journey);
    expect(nav.decision(back: true), ExitDecision.previousQuestion);
    journey.previousQuestion();
    expect(nav.decision(back: true), ExitDecision.confirmDiscard);
    expect(nav.decision(back: false), ExitDecision.confirmDiscard);
    expect(
      nav.decision(back: false, canLeave: false),
      ExitDecision.blockSaving,
    );
    journey.discard(DiscardReason.exit);
    journey.discard(DiscardReason.background);
    expect(journey.discarded, 1);
    expect(nav.decision(back: true), ExitDecision.allow);
    nav.dispose();
    journey.dispose();
    account.dispose();
    await repo.changes.close();
  });
}
