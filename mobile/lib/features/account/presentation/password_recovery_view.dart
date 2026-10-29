import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../application/account_controller.dart';
import '../application/account_state.dart';
import 'account_scaffold.dart';

class PasswordRecoveryView extends StatefulWidget {
  const PasswordRecoveryView({super.key, required this.controller});
  final AccountController controller;
  @override
  State<PasswordRecoveryView> createState() => _PasswordRecoveryViewState();
}

class _PasswordRecoveryViewState extends State<PasswordRecoveryView> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  int _step = 0;
  bool _hidden = true;
  @override
  void dispose() {
    _email.dispose();
    _code.clear();
    _code.dispose();
    _password.clear();
    _password.dispose();
    if (widget.controller.state.phase == AccountPhase.recovering) {
      unawaited(widget.controller.signOut());
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (widget.controller.usesEmailLinkRecovery) {
      final success = await widget.controller.requestRecovery(
        _email.text.trim(),
      );
      if (success && mounted) setState(() => _step = 1);
      return;
    }
    bool success;
    if (_step == 0) {
      success = await widget.controller.requestRecovery(_email.text.trim());
    } else if (_step == 1) {
      success = await widget.controller.verifyRecovery(_code.text.trim());
      _code.clear();
    } else {
      success = await widget.controller.changePassword(_password.text);
      _password.clear();
    }
    if (!success || !mounted) return;
    if (_step < 2) {
      setState(() => _step++);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/signin', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.controller,
    builder: (context, _) => AccountScaffold(
      controller: widget.controller,
      title: 'Recupera tu acceso',
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.controller.usesEmailLinkRecovery && _step == 1
                  ? 'Revisa tu correo y abre el enlace para cambiar tu contraseña. Luego vuelve a iniciar sesión. Si no llega, revisa la carpeta de correo no deseado.'
                  : switch (_step) {
                      0 => 'Escribe el correo con el que te registraste.',
                      1 => 'Si la solicitud procede, recibirás un código en tu correo. Usa el más reciente.',
                      _ =>
                        'Elige una nueva contraseña de al menos 12 caracteres.',
                    },
            ),
            const SizedBox(height: 20),
            AccountMessages(controller: widget.controller),
            if (_step == 0)
              TextFormField(
                key: const Key('recovery.email'),
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: accountEmailValidator,
                enabled: !widget.controller.state.busy,
              ),
            if (_step == 1 && !widget.controller.usesEmailLinkRecovery)
              TextFormField(
                key: const Key('recovery.code'),
                controller: _code,
                decoration: const InputDecoration(
                  labelText: 'Código de recuperación',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofillHints: const [AutofillHints.oneTimeCode],
                validator: (v) => v == null || v.isEmpty
                    ? 'Escribe el código que recibiste.'
                    : null,
                enabled: !widget.controller.state.busy,
              ),
            if (_step == 2)
              TextFormField(
                key: const Key('recovery.password'),
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña',
                  suffixIcon: IconButton(
                    tooltip: _hidden
                        ? 'Mostrar contraseña'
                        : 'Ocultar contraseña',
                    onPressed: () => setState(() => _hidden = !_hidden),
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                obscureText: _hidden,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: const [AutofillHints.newPassword],
                validator: accountPasswordValidator,
                enabled: !widget.controller.state.busy,
              ),
            const SizedBox(height: 24),
            AccountSubmit(
              key: const Key('recovery.submit'),
              label: widget.controller.usesEmailLinkRecovery
                  ? (_step == 0
                        ? 'Enviar enlace de recuperación'
                        : 'Reenviar enlace')
                  : switch (_step) {
                      0 => 'Solicitar código',
                      1 => 'Validar código',
                      _ => 'Guardar contraseña',
                    },
              busy: widget.controller.state.busy,
              onPressed: _submit,
            ),
            if (_step == 1 && !widget.controller.usesEmailLinkRecovery)
              TextButton(
                key: const Key('recovery.resend'),
                onPressed: widget.controller.state.busy
                    ? null
                    : () =>
                          widget.controller.requestRecovery(_email.text.trim()),
                child: const Text('Solicitar otro código'),
              ),
            TextButton(
              onPressed: widget.controller.state.busy
                  ? null
                  : () =>
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/signin', (_) => false),
              child: const Text('Volver a iniciar sesión'),
            ),
          ],
        ),
      ),
    ),
  );
}
