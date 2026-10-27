import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../application/account_controller.dart';
import 'account_scaffold.dart';

class EmailConfirmationView extends StatefulWidget {
  const EmailConfirmationView({super.key, required this.controller});
  final AccountController controller;
  @override
  State<EmailConfirmationView> createState() => _EmailConfirmationViewState();
}

class _EmailConfirmationViewState extends State<EmailConfirmationView> {
  final _form = GlobalKey<FormState>();
  final _code = TextEditingController();
  @override
  void dispose() {
    _code.clear();
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final success = await widget.controller.confirm(_code.text.trim());
    _code.clear();
    if (success && mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/signin', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.controller,
    builder: (context, _) => AccountScaffold(
      controller: widget.controller,
      title: 'Verifica tu correo',
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Si el registro puede completarse, recibirás un código en tu correo. Después podrás iniciar sesión con tu contraseña.',
            ),
            const SizedBox(height: 20),
            AccountMessages(controller: widget.controller),
            TextFormField(
              key: const Key('confirm.code'),
              controller: _code,
              decoration: const InputDecoration(
                labelText: 'Código de verificación',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofillHints: const [AutofillHints.oneTimeCode],
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Escribe el código que recibiste.'
                  : null,
              enabled: !widget.controller.state.busy,
            ),
            const SizedBox(height: 24),
            AccountSubmit(
              key: const Key('confirm.submit'),
              label: 'Verificar correo',
              busy: widget.controller.state.busy,
              onPressed: widget.controller.state.email.isEmpty ? null : _submit,
            ),
            TextButton(
              key: const Key('confirm.resend'),
              onPressed:
                  widget.controller.state.busy ||
                      widget.controller.state.email.isEmpty
                  ? null
                  : () => widget.controller.resendConfirmation(),
              child: const Text('Solicitar otro código'),
            ),
            TextButton(
              onPressed: () =>
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
