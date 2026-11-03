import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../account/application/account_controller.dart';
import '../data/destination_catalog.dart';
import '../data/temporary_journey.dart';
import 'navigation_state.dart';

class NavigationController extends ChangeNotifier {
  NavigationController(this.account, this.journey) {
    _uid = account.state.canAccessPrivate
        ? account.state.session!.userId
        : null;
    if (_uid == null) journey.discard(DiscardReason.session);
    account.addListener(_accountChanged);
    journey.addListener(_journeyChanged);
    observer = _NavigationObserver(this);
  }
  final AccountController account;
  final TemporaryJourney journey;
  final navigatorKey = GlobalKey<NavigatorState>();
  late final NavigatorObserver observer;
  final _routes = <Route<dynamic>>[];
  final _exitGuards = <Route<dynamic>, bool Function()>{};
  String? _uid;
  int _generation = 0;
  bool _pending = false;
  bool _disposed = false;
  bool _resetScheduled = false;
  bool obscured = false;
  DialogRoute<bool>? _dialog;

  NavigationState get state => NavigationState(
    path: _routes.isEmpty ? null : _routes.last.settings.name,
    history: List.unmodifiable(
      _routes
          .map((r) => r.settings.name ?? '')
          .where((p) => destinationFor(p) != null),
    ),
    generation: _generation,
    pending: _pending,
  );
  bool get hasResult => journey.phase == JourneyPhase.result;
  bool allowed(String path) => destinationAllowed(
    path,
    privateAccess: account.state.canAccessPrivate,
    hasResult: hasResult,
  );

  ExitDecision decision({required bool back, bool canLeave = true}) {
    if (!canLeave) return ExitDecision.blockSaving;
    if (journey.phase == JourneyPhase.attempt) {
      if (back && journey.canGoToPreviousQuestion) {
        return ExitDecision.previousQuestion;
      }
      return ExitDecision.confirmDiscard;
    }
    return ExitDecision.allow;
  }

  void _publish() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) notifyListeners();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _journeyChanged() {
    if (!account.state.canAccessPrivate && journey.phase != JourneyPhase.idle) {
      journey.discard(DiscardReason.session);
    }
    _publish();
  }

  void _accountChanged() {
    final next = account.state.canAccessPrivate
        ? account.state.session!.userId
        : null;
    if (_uid != null && next != _uid) {
      _generation++;
      journey.discard(DiscardReason.session);
      _invalidateDialog();
      _scheduleReset();
    }
    _uid = next;
    _publish();
  }

  void _scheduleReset() {
    if (_resetScheduled || _disposed) return;
    _resetScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetScheduled = false;
      if (_disposed) return;
      final nav = navigatorKey.currentState;
      final target = account.state.canAccessPrivate ? '/home' : '/signin';
      if (nav == null || (_routes.length == 1 && state.path == target)) {
        return;
      }
      nav.pushNamedAndRemoveUntil(target, (_) => false);
    });
  }

  void _invalidateDialog() {
    _pending = false;
    final dialog = _dialog;
    _dialog = null;
    if (dialog != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_disposed && dialog.isActive) {
          navigatorKey.currentState?.removeRoute(dialog, false);
        }
      });
    }
  }

  void lifecycle(AppLifecycleState state) {
    obscured = state != AppLifecycleState.resumed;
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _generation++;
      journey.discard(DiscardReason.background);
      _invalidateDialog();
    }
    _publish();
  }

  void registerExitGuard(Route<dynamic> route, bool Function() guard) =>
      _exitGuards[route] = guard;
  void unregisterExitGuard(Route<dynamic> route, bool Function() guard) {
    if (_exitGuards[route] == guard) _exitGuards.remove(route);
  }

  bool _canLeave() =>
      _routes.isEmpty || (_exitGuards[_routes.last]?.call() ?? true);
  bool interceptBack(String? path) =>
      !_canLeave() ||
      ((path == '/questionnaire' || path == '/results') &&
          journey.phase != JourneyPhase.idle);

  Future<bool> _prepare(
    BuildContext context, {
    required bool back,
    String? target,
  }) async {
    if (_pending || _disposed) return false;
    final action = decision(back: back, canLeave: _canLeave());
    if (action == ExitDecision.blockSaving) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Espera a que termine el guardado.')),
      );
      return false;
    }
    if (action == ExitDecision.previousQuestion) {
      journey.previousQuestion();
      return false;
    }
    if (action == ExitDecision.confirmDiscard) {
      final intent = NavigationIntent(
        ownerId: _uid,
        navigationGeneration: _generation,
        journeyGeneration: journey.generation,
      );
      _pending = true;
      final dialog = DialogRoute<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('¿Quieres salir?'),
          content: const Text('Si sales, se descartarán tus respuestas.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Salir'),
            ),
          ],
        ),
      );
      _dialog = dialog;
      final confirmed = await navigatorKey.currentState!.push<bool>(dialog);
      if (_dialog == dialog) {
        _dialog = null;
        _pending = false;
      }
      if (_disposed ||
          !context.mounted ||
          intent.navigationGeneration != _generation ||
          intent.journeyGeneration != journey.generation ||
          intent.ownerId != _uid ||
          !account.state.canAccessPrivate ||
          confirmed != true) {
        return false;
      }
    }
    final enteringResult =
        target == '/results' &&
        journey.phase == JourneyPhase.result &&
        state.path != '/results';
    if (journey.phase != JourneyPhase.idle && !enteringResult) {
      journey.discard(DiscardReason.exit);
    }
    return true;
  }

  Future<void> navigate(BuildContext context, String path) async {
    if (_disposed || _pending || state.path == path) return;
    if (!await _prepare(context, back: false, target: path) ||
        _disposed ||
        !context.mounted) {
      return;
    }
    // Check again after any asynchronous confirmation.
    if (destinationFor(path) != null && !allowed(path) && path != '/results') {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Inicia sesión para continuar.')),
      );
      path = '/signin';
    } else if (path == '/results' && !account.state.canAccessPrivate) {
      path = '/signin';
    }
    final nav = navigatorKey.currentState;
    if (nav == null || state.path == path) return;
    final previous = _routes.where((r) => r.settings.name == path).lastOrNull;
    if (previous != null) {
      nav.popUntil((route) => route == previous);
      return;
    }
    if (path.startsWith('/tips/') &&
        destinationFor(path) != null &&
        !_routes.any((r) => r.settings.name == '/tips')) {
      unawaited(nav.pushNamed('/tips'));
    }
    unawaited(nav.pushNamed(path));
  }

  Future<void> back(BuildContext context) async {
    if (!await _prepare(context, back: true) || _disposed || !context.mounted) {
      return;
    }
    final nav = navigatorKey.currentState;
    if (nav == null) return;
    if (_routes.length > 1) {
      nav.pop();
    } else {
      await SystemNavigator.pop();
    }
  }

  void _leftPath(String? previous) {
    if (previous == state.path) return;
    if ((previous == '/results' && journey.phase == JourneyPhase.result) ||
        (previous == '/questionnaire' &&
            state.path != '/results' &&
            journey.phase == JourneyPhase.attempt)) {
      journey.discard(DiscardReason.exit);
    }
  }

  void _changed() {
    _generation++;
    _publish();
  }

  @override
  void dispose() {
    _disposed = true;
    account.removeListener(_accountChanged);
    journey.removeListener(_journeyChanged);
    journey.discard(DiscardReason.dispose);
    _routes.clear();
    _exitGuards.clear();
    _dialog = null;
    super.dispose();
  }
}

class _NavigationObserver extends NavigatorObserver {
  _NavigationObserver(this.owner);
  final NavigationController owner;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) {
      final previous = owner.state.path;
      owner._routes.add(route);
      owner._leftPath(previous);
      owner._changed();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      didRemove(route, previousRoute);
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final previous = owner.state.path;
    if (owner._routes.remove(route)) {
      owner._leftPath(previous);
      owner._exitGuards.remove(route);
      owner._changed();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final previous = owner.state.path;
    final index = oldRoute == null ? -1 : owner._routes.indexOf(oldRoute);
    if (index >= 0) {
      if (newRoute is PageRoute) {
        owner._routes[index] = newRoute;
      } else {
        owner._routes.removeAt(index);
      }
      owner._exitGuards.remove(oldRoute);
      owner._leftPath(previous);
      owner._changed();
    }
  }
}

class NavigationScope extends InheritedWidget {
  const NavigationScope({
    super.key,
    required this.controller,
    required super.child,
  });
  final NavigationController controller;
  static NavigationController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavigationScope>()?.controller;
  @override
  bool updateShouldNotify(NavigationScope oldWidget) =>
      oldWidget.controller != controller;
}

class NavigationPageGuard extends StatelessWidget {
  const NavigationPageGuard({
    super.key,
    required this.controller,
    required this.path,
    required this.child,
  });
  final NavigationController controller;
  final String path;
  final Widget child;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => PopScope(
      canPop: !controller.interceptBack(path),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) unawaited(controller.back(context));
      },
      child: child,
    ),
  );
}

class NavigationExitGuard extends StatefulWidget {
  const NavigationExitGuard({
    super.key,
    required this.canLeave,
    required this.child,
  });
  final bool canLeave;
  final Widget child;
  @override
  State<NavigationExitGuard> createState() => _NavigationExitGuardState();
}

class _NavigationExitGuardState extends State<NavigationExitGuard> {
  NavigationController? _controller;
  Route<dynamic>? _route;
  bool _allowsLeave() => widget.canLeave;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _unregister();
    _controller = NavigationScope.maybeOf(context);
    _route = ModalRoute.of(context);
    if (_route != null) _controller?.registerExitGuard(_route!, _allowsLeave);
  }

  void _unregister() {
    if (_route != null) _controller?.unregisterExitGuard(_route!, _allowsLeave);
  }

  @override
  void dispose() {
    _unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
