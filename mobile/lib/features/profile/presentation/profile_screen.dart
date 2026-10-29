import 'dart:async';

import 'package:flutter/material.dart';

import '../../account/application/account_controller.dart';
import '../../account/presentation/account_scaffold.dart';
import '../application/profile_controller.dart';
import '../application/profile_state.dart';
import '../data/profile_repository.dart';
import '../data/deletion_contact_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.account,
    required this.repository,
    required this.contact,
    this.observer,
  });
  final AccountController account;
  final ProfileRepository repository;
  final DeletionContactService contact;
  final RouteObserver<PageRoute<dynamic>>? observer;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with RouteAware {
  late ProfileController _profile;
  final _name = TextEditingController();
  PageRoute<dynamic>? _route;
  bool _started = false;
  bool _closing = false;
  @override
  void initState() {
    super.initState();
    _profile = ProfileController(widget.account, widget.repository)
      ..addListener(_syncDraft);
  }

  void _syncDraft() {
    final value = _profile.state.draft;
    if (_name.text != value) {
      _name.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic> && widget.observer != null) {
      _route = route;
      widget.observer!.subscribe(this, route);
    } else {
      _profile.activate();
    }
  }

  @override
  void didPush() => _profile.activate();
  @override
  void didPopNext() => _profile.activate();
  @override
  void didPushNext() => _profile.deactivate();
  @override
  void didPop() => _profile.deactivate();
  @override
  void dispose() {
    if (_route != null) widget.observer?.unsubscribe(this);
    _profile.removeListener(_syncDraft);
    _profile.dispose();
    _name.clear();
    _name.dispose();
    super.dispose();
  }

  void _signOut() {
    if (_closing) return;
    _closing = true;
    _profile.deactivate();
    // AccountController clears local access synchronously before awaiting Auth.
    final closing = widget.account.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/signin', (_) => false);
    unawaited(closing);
  }

  void _save() {
    FocusScope.of(context).unfocus();
    unawaited(_profile.save());
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _profile,
    builder: (context, _) {
      final state = _profile.state;
      final data = state.profile;
      final editing =
          state.phase == ProfilePhase.editing ||
          state.phase == ProfilePhase.saving;
      return PopScope(
        canPop: state.phase != ProfilePhase.saving,
        child: AccountScaffold(
          controller: widget.account,
          title: 'Perfil',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ExcludeSemantics(
                child: Icon(Icons.account_circle, size: 96),
              ),
              const SizedBox(height: 20),
              if (state.phase == ProfilePhase.loading)
                Semantics(
                  label: 'Cargando perfil',
                  liveRegion: true,
                  child: const LinearProgressIndicator(),
                ),
              if (state.message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      state.message!,
                      style: TextStyle(
                        color: state.phase == ProfilePhase.ready
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              if (data != null) ...[
                Text(
                  'Hola, ${data.name}.',
                  key: const Key('profile.greeting'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                const Text('Correo electrónico'),
                Text(data.email, key: const Key('profile.email')),
                const SizedBox(height: 24),
                if (editing) ...[
                  TextFormField(
                    key: const Key('profile.name'),
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      helperText: 'Este nombre se usa para saludarte.',
                    ),
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.name],
                    enabled: !_profile.operationPending,
                    onChanged: _profile.changeDraft,
                    onFieldSubmitted: (_) =>
                        _profile.operationPending ? null : _save(),
                  ),
                  const SizedBox(height: 16),
                  AccountSubmit(
                    key: const Key('profile.save'),
                    label: 'Guardar nombre',
                    busy: state.phase == ProfilePhase.saving,
                    onPressed: _profile.operationPending ? null : _save,
                  ),
                  TextButton(
                    key: const Key('profile.cancel'),
                    onPressed: _profile.operationPending
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            _profile.cancelEdit();
                          },
                    child: const Text('Cancelar'),
                  ),
                ] else if (state.phase == ProfilePhase.ready)
                  TextButton.icon(
                    key: const Key('profile.edit'),
                    onPressed: _profile.beginEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar nombre'),
                  ),
              ],
              if (state.phase == ProfilePhase.error ||
                  state.phase == ProfilePhase.unknown)
                TextButton(
                  key: const Key('profile.reload'),
                  onPressed: _profile.operationPending
                      ? null
                      : () => _profile.load(),
                  child: const Text('Volver a consultar el perfil'),
                ),
              const SizedBox(height: 24),
              TextButton(
                key: const Key('profile.delete.info'),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) =>
                        _DeletionContactDialog(contact: widget.contact),
                  );
                },
                child: const Text('Solicitar eliminación de mis datos'),
              ),
              const SizedBox(height: 16),
              AccountSubmit(
                key: const Key('profile.signout'),
                label: 'Cerrar sesión',
                busy: false,
                onPressed: _closing ? null : _signOut,
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _DeletionContactDialog extends StatefulWidget {
  const _DeletionContactDialog({required this.contact});
  final DeletionContactService contact;
  @override
  State<_DeletionContactDialog> createState() => _DeletionContactDialogState();
}

class _DeletionContactDialogState extends State<_DeletionContactDialog> {
  bool _busy = false;
  String? _message;
  Future<void> _open() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    final opened = await widget.contact.openDraft();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _message = opened
          ? 'Completa y envía la solicitud desde tu app de correo. Abrir el borrador no confirma su envío.'
          : 'No pudimos abrir una app de correo. Copia la dirección y envía tu solicitud desde tu correo.';
    });
  }

  Future<void> _copy() async {
    if (_busy) return;
    setState(() {
      _busy = true;
    });
    final copied = await widget.contact.copyAddress();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _message = copied ? 'Correo copiado.' : 'No pudimos copiar el correo. Puedes escribir la dirección manualmente.';
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: const Text('Solicitar eliminación'),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('El equipo de Priva atiende las solicitudes en:'),
        const SizedBox(height: 12),
        const Text(supportEmail),
        const SizedBox(height: 12),
        const Text(
          'Envía la solicitud desde el correo de tu cuenta. El equipo comprobará tu identidad y te informará qué datos se eliminan y cualquier conservación que tenga un fundamento aplicable.\n\nSe abrirá tu app de correo. Abrir este borrador no elimina tus datos. La solicitud no se envía automáticamente.',
        ),
        if (_message != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Semantics(liveRegion: true, child: Text(_message!)),
          ),
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('profile.delete.open'),
          onPressed: _busy ? null : _open,
          child: const Text('Abrir app de correo'),
        ),
        TextButton(
          key: const Key('profile.delete.copy'),
          onPressed: _busy ? null : _copy,
          child: const Text('Copiar correo'),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Volver'),
      ),
    ],
  );
}
