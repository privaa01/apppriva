import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../app/account_errors.dart';
import '../data/account_models.dart';
import '../data/account_repository.dart';
import 'account_state.dart';

class AccountController extends ChangeNotifier {
  AccountController(
    this.repository, {
    this.timeout = const Duration(seconds: 15),
    this.allowTestPolicy = false,
  });
  final AccountRepository repository;
  final Duration timeout;
  final bool allowTestPolicy;
  AccountState _state = const AccountState();
  TreatmentPolicy? _policy;
  StreamSubscription<AccountSession?>? _subscription;
  int _generation = 0;
  bool _disposed = false;
  bool _inFlight = false;
  DateTime? _confirmationResentAt;
  DateTime? _recoveryRequestedAt;
  AccountState get state => _state;
  TreatmentPolicy? get policy => _policy;

  void _set(AccountState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  Future<void> initialize() async {
    _subscription ??= repository.sessionChanges.listen(
      (session) {
        // Stream events can revoke an existing grant, never create a new one.
        if (_state.canAccessPrivate && session?.canAccessPrivate != true) {
          _generation++;
          _set(const AccountState());
        }
      },
      onError: (Object _) {
        _generation++;
        _set(const AccountState(error: operationFailureMessage));
      },
    );
    final restored = repository.currentSession;
    if (restored?.canAccessPrivate == true) {
      _set(AccountState(phase: AccountPhase.authenticated, session: restored));
    } else if (restored != null) {
      try {
        await repository.signOut();
      } catch (_) {
        /* Fail closed. */
      }
    }
    try {
      final loaded = await repository.loadPolicy().timeout(timeout);
      if (!_disposed) {
        _policy = loaded?.isTest == true && !allowTestPolicy ? null : loaded;
        notifyListeners();
      }
    } catch (_) {
      if (!_disposed) {
        _policy = null;
        notifyListeners();
      }
    }
  }

  static bool validEmail(String value) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim());
  static bool validPassword(String value) => value.runes.length >= 12;
  static bool validCode(String value) =>
      RegExp(r'^\d{6}$').hasMatch(value.trim());

  bool _reject(String message) {
    if (!_state.busy) {
      _set(
        AccountState(
          phase: _state.phase,
          email: _state.email,
          session: _state.session,
          error: message,
        ),
      );
    }
    return false;
  }

  Future<bool> _perform(
    Future<AccountState> Function() operation, {
    String errorMessage = operationFailureMessage,
    bool revokeLateSession = false,
  }) async {
    if (_disposed || _inFlight) return false;
    _inFlight = true;
    final generation = ++_generation;
    final before = _state;
    _set(
      AccountState(
        phase: before.phase,
        email: before.email,
        session: before.session,
        busy: true,
      ),
    );
    final pending = Future<AccountState>.sync(operation);
    // A timeout does not cancel an SDK operation. Keep duplicate requests blocked
    // until it actually settles and revoke any late session before allowing retry.
    unawaited(
      pending
          .then<void>((_) async {
            if (revokeLateSession && generation != _generation) {
              try {
                await repository.signOut();
              } catch (_) {
                /* Remain unprivileged. */
              }
            }
          }, onError: (Object _, StackTrace _) {})
          .whenComplete(() {
            _inFlight = false;
          }),
    );
    try {
      final next = await pending.timeout(timeout);
      if (_disposed || generation != _generation) return false;
      _set(next);
      return true;
    } on TimeoutException {
      if (!_disposed && generation == _generation) {
        _generation++;
        _set(
          AccountState(
            phase: before.phase,
            email: before.email,
            session: before.session,
            error: waitFailureMessage,
          ),
        );
      }
      return false;
    } catch (_) {
      if (!_disposed && generation == _generation) {
        _set(
          AccountState(
            phase: before.phase,
            email: before.email,
            session: before.session,
            error: errorMessage,
          ),
        );
      }
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required bool accepted,
  }) async {
    if (_inFlight) return false;
    if (name.trim().isEmpty || !validEmail(email) || !validPassword(password)) {
      return _reject(
        'Revisa los campos y usa una contraseña de al menos 12 caracteres.',
      );
    }
    if (!accepted) {
      return _reject(
        'Consulta la política y autoriza el tratamiento antes de crear tu cuenta.',
      );
    }
    final selected = _policy;
    if (selected == null || (selected.isTest && !allowTestPolicy)) {
      return _reject('El registro no está disponible en este momento.');
    }
    return _perform(() async {
      await repository.signUp(
        name: name.trim(),
        email: email.trim(),
        password: password,
        policyVersion: selected.version,
      );
      return AccountState(
        phase: AccountPhase.pendingVerification,
        email: email.trim(),
        notice: 'Si el registro puede completarse, recibirás un código en tu correo.',
      );
    });
  }

  Future<bool> confirm(String code) async {
    if (_state.phase != AccountPhase.pendingVerification || !validCode(code)) {
      return _reject(codeFailureMessage);
    }
    final email = _state.email;
    return _perform(
      () async {
        await repository.confirmEmail(email: email, code: code.trim());
        await repository.signOut();
        return AccountState(
          email: email,
          notice: 'Correo confirmado. Inicia sesión para continuar.',
        );
      },
      errorMessage: codeFailureMessage,
      revokeLateSession: true,
    );
  }

  Future<bool> resendConfirmation() async {
    if (_state.phase != AccountPhase.pendingVerification) return false;
    if (_confirmationResentAt != null &&
        DateTime.now().difference(_confirmationResentAt!).inSeconds < 60) {
      return _reject('Espera un minuto antes de pedir otro código.');
    }
    final before = _state;
    return _perform(() async {
      await repository.resendConfirmation(before.email);
      _confirmationResentAt = DateTime.now();
      return AccountState(
        phase: before.phase,
        email: before.email,
        notice: 'Si corresponde, recibirás un nuevo código en tu correo.',
      );
    });
  }

  Future<bool> signIn({required String email, required String password}) async {
    if (!validEmail(email) || password.isEmpty) {
      return _reject(signInFailureMessage);
    }
    return _perform(
      () async {
        final session = await repository.signIn(
          email: email.trim(),
          password: password,
        );
        if (session?.canAccessPrivate != true) {
          await repository.signOut();
          throw const AccountFailure();
        }
        return AccountState(
          phase: AccountPhase.authenticated,
          session: session,
        );
      },
      errorMessage: signInFailureMessage,
      revokeLateSession: true,
    );
  }

  Future<bool> requestRecovery(String email) async {
    if (!validEmail(email)) {
      return _reject('Escribe un correo electrónico válido.');
    }
    if (_recoveryRequestedAt != null &&
        DateTime.now().difference(_recoveryRequestedAt!).inSeconds < 60) {
      return _reject('Espera un minuto antes de pedir otro código.');
    }
    return _perform(() async {
      await repository.requestRecovery(email.trim());
      _recoveryRequestedAt = DateTime.now();
      return AccountState(
        email: email.trim(),
        notice: 'Si corresponde, recibirás un código para recuperar el acceso.',
      );
    });
  }

  Future<bool> verifyRecovery(String code) async {
    if (!validEmail(_state.email) || !validCode(code)) {
      return _reject(codeFailureMessage);
    }
    final email = _state.email;
    return _perform(
      () async {
        await repository.verifyRecovery(email: email, code: code.trim());
        return AccountState(phase: AccountPhase.recovering, email: email);
      },
      errorMessage: codeFailureMessage,
      revokeLateSession: true,
    );
  }

  Future<bool> changePassword(String password) async {
    if (_state.phase != AccountPhase.recovering || !validPassword(password)) {
      return _reject('Usa una contraseña de al menos 12 caracteres.');
    }
    return _perform(() async {
      await repository.changePassword(password);
      await repository.signOut();
      return const AccountState(
        notice: 'Contraseña actualizada. Inicia sesión para continuar.',
      );
    }, revokeLateSession: true);
  }

  Future<void> signOut() async {
    _generation++;
    _set(const AccountState());
    try {
      await repository.signOut();
    } catch (_) {
      _set(const AccountState(error: operationFailureMessage));
    }
  }

  void resetToVisitor() {
    _generation++;
    _set(const AccountState());
    unawaited(repository.signOut().catchError((Object _) {}));
  }

  @override
  void dispose() {
    _generation++;
    _disposed = true;
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
