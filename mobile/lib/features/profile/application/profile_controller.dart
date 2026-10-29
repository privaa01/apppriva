import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../account/application/account_controller.dart';
import '../data/profile_details.dart';
import '../data/profile_repository.dart';
import 'profile_state.dart';

class ProfileController extends ChangeNotifier {
  ProfileController(
    this.account,
    this.repository, {
    this.timeout = const Duration(seconds: 15),
  }) {
    _uid = account.state.canAccessPrivate
        ? account.state.session?.userId
        : null;
    account.addListener(_accountChanged);
  }
  final AccountController account;
  final ProfileRepository repository;
  final Duration timeout;
  ProfileState _state = const ProfileState();
  String? _uid;
  Object? _operation;
  int _generation = 0;
  bool _disposed = false;
  bool _active = true;
  bool _refreshOnSettle = false;
  ProfileState get state => _state;
  bool get operationPending => _operation != null;
  bool get _hasAccess =>
      !_disposed &&
      _active &&
      account.state.canAccessPrivate &&
      _uid != null &&
      account.state.session?.userId == _uid;

  void _set(ProfileState value) {
    if (_disposed) return;
    _state = value;
    notifyListeners();
  }

  void _accountChanged() {
    final uid = account.state.canAccessPrivate
        ? account.state.session?.userId
        : null;
    if (uid == _uid) return;
    _uid = uid;
    _generation++;
    _operation = null;
    _refreshOnSettle = false;
    _set(const ProfileState());
  }

  bool _valid(int generation, String uid) =>
      _hasAccess && _generation == generation && _uid == uid;

  Future<bool> _run({required bool saving}) async {
    if (!_hasAccess || operationPending) return false;
    final uid = _uid!;
    final generation = ++_generation;
    final before = _state;
    final token = Object();
    _operation = token;
    _set(
      ProfileState(
        phase: saving ? ProfilePhase.saving : ProfilePhase.loading,
        profile: before.profile,
        draft: before.draft,
      ),
    );
    final pending = Future<ProfileDetails>.sync(
      () => saving
          ? repository.updateName(before.draft.trim(), expectedUid: uid)
          : repository.loadCurrent(expectedUid: uid),
    );
    unawaited(
      pending
          .then<void>((_) {}, onError: (Object _, StackTrace _) {})
          .whenComplete(() {
            if (_disposed || !identical(_operation, token)) return;
            _operation = null;
            notifyListeners();
            if (_refreshOnSettle && _hasAccess) {
              _refreshOnSettle = false;
              unawaited(load());
            }
          }),
    );
    try {
      final result = await pending.timeout(timeout);
      if (!_valid(generation, uid)) return false;
      if (result.uid != uid ||
          result.name.trim().isEmpty ||
          result.email.isEmpty) {
        throw const ProfileFailure();
      }
      _set(
        ProfileState(
          phase: ProfilePhase.ready,
          profile: result,
          draft: result.name,
          message: saving ? 'Nombre actualizado.' : null,
        ),
      );
      if (saving) account.updateProfileName(uid: uid, name: result.name);
      return true;
    } on TimeoutException {
      if (_valid(generation, uid)) {
        _generation++;
        _set(
          ProfileState(
            phase: ProfilePhase.unknown,
            profile: before.profile,
            draft: before.draft,
            message: 'La operación está tardando. No podemos confirmar el resultado. Consulta el perfil antes de volver a guardar.',
          ),
        );
      }
    } catch (_) {
      if (_valid(generation, uid)) {
        _set(
          ProfileState(
            phase: saving ? ProfilePhase.editing : ProfilePhase.error,
            profile: before.profile,
            draft: before.draft,
            message: saving
                ? 'No pudimos guardar el nombre. Revisa tu conexión e inténtalo de nuevo.'
                : 'No pudimos cargar tu perfil. Revisa tu conexión e inténtalo de nuevo.',
          ),
        );
      }
    }
    return false;
  }

  Future<bool> load() => _run(saving: false);
  void beginEdit() {
    final profile = _state.profile;
    if (!_hasAccess ||
        operationPending ||
        _state.phase != ProfilePhase.ready ||
        profile == null) {
      return;
    }
    _set(
      ProfileState(
        phase: ProfilePhase.editing,
        profile: profile,
        draft: profile.name,
      ),
    );
  }

  void changeDraft(String value) {
    if (!_hasAccess ||
        operationPending ||
        _state.phase != ProfilePhase.editing) {
      return;
    }
    _set(
      ProfileState(
        phase: ProfilePhase.editing,
        profile: _state.profile,
        draft: value,
      ),
    );
  }

  void cancelEdit() {
    if (!_hasAccess ||
        operationPending ||
        _state.phase != ProfilePhase.editing) {
      return;
    }
    _set(
      ProfileState(
        phase: ProfilePhase.ready,
        profile: _state.profile,
        draft: _state.profile?.name ?? '',
      ),
    );
  }

  Future<bool> save() async {
    if (!_hasAccess ||
        operationPending ||
        _state.phase != ProfilePhase.editing) {
      return false;
    }
    if (_state.draft.trim().isEmpty) {
      _set(
        ProfileState(
          phase: ProfilePhase.editing,
          profile: _state.profile,
          draft: _state.draft,
          message: 'Escribe tu nombre.',
        ),
      );
      return false;
    }
    return _run(saving: true);
  }

  void deactivate() {
    _active = false;
    _generation++;
    _refreshOnSettle = false;
    _set(const ProfileState());
  }

  void activate() {
    if (_disposed) return;
    _active = true;
    if (operationPending) {
      _refreshOnSettle = true;
      _set(
        const ProfileState(
          phase: ProfilePhase.unknown,
          message:
              'Hay una operación pendiente. Espera para consultar el perfil.',
        ),
      );
    } else {
      unawaited(load());
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    account.removeListener(_accountChanged);
    super.dispose();
  }
}
