import 'package:flutter/material.dart';

import '../application/account_controller.dart';
import 'account_scaffold.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({
    super.key,
    required this.controller,
    this.accessRequired = false,
  });
  final AccountController controller;
  final bool accessRequired;
  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidden = true;
  @override
  void dispose() {
    _email.dispose();
    _password.clear();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final success = await widget.controller.signIn(
      email: _email.text.trim(),
      password: _password.text,
    );
    _password.clear();
    if (success && mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.controller,
    builder: (context, _) => AccountScaffold(
      controller: widget.controller,
      title: '¡Ingresa a tu cuenta!',
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.accessRequired)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Inicia sesión para acceder a esta sección. Puedes consultar Tips sin cuenta.',
                ),
              ),
            AccountMessages(controller: widget.controller),
            TextFormField(
              key: const Key('signin.email'),
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.username],
              textInputAction: TextInputAction.next,
              validator: accountEmailValidator,
              enabled: !widget.controller.state.busy,
            ),
            const SizedBox(height: 20),
            TextFormField(
              key: const Key('signin.password'),
              controller: _password,
              decoration: InputDecoration(
                labelText: 'Contraseña',
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
              autofillHints: const [AutofillHints.password],
              enableSuggestions: false,
              autocorrect: false,
              onFieldSubmitted: (_) =>
                  widget.controller.state.busy ? null : _submit(),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Escribe tu contraseña.' : null,
              enabled: !widget.controller.state.busy,
            ),
            const SizedBox(height: 28),
            AccountSubmit(
              key: const Key('signin.submit'),
              label: 'Iniciar sesión',
              busy: widget.controller.state.busy,
              onPressed: _submit,
            ),
            TextButton(
              key: const Key('signin.recover'),
              onPressed: widget.controller.state.busy
                  ? null
                  : () => Navigator.of(context).pushNamed('/recovery'),
              child: const Text('Olvidé mi contraseña'),
            ),
            TextButton(
              key: const Key('signin.create'),
              onPressed: widget.controller.state.busy
                  ? null
                  : () => Navigator.of(context).pushNamed('/signup'),
              child: const Text('Crear cuenta'),
            ),
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/zyro/zyro.png',
              height: 240,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
            const SizedBox(height: 12),
            const Text(
              'Bienvenido a Priva. Aprende a cuidar tu privacidad.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
