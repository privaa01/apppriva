import 'package:flutter/material.dart';

import '../application/account_controller.dart';
import 'account_scaffold.dart';
import 'treatment_policy_view.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.controller});
  final AccountController controller;
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _viewed = false,
      _accepted = false,
      _hidden = true,
      _consentError = false;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.clear();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final valid = _form.currentState!.validate();
    setState(() => _consentError = !_accepted);
    if (!valid || !_accepted) return;
    final success = await widget.controller.register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
      accepted: _accepted,
    );
    _password.clear();
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/confirm');
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.controller,
    builder: (context, _) {
      final policy = widget.controller.policy;
      final busy = widget.controller.state.busy;
      return AccountScaffold(
        controller: widget.controller,
        title: '¡Crea tu cuenta con nosotros!',
        navigation: false,
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Aprende a proteger tu información personal. Todos los campos son obligatorios.',
              ),
              const SizedBox(height: 20),
              AccountMessages(controller: widget.controller),
              TextFormField(
                key: const Key('signup.name'),
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nombre'),
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Escribe tu nombre.' : null,
                enabled: !busy,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('signup.email'),
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: accountEmailValidator,
                enabled: !busy,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('signup.password'),
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  helperText: 'Usa una frase de al menos 12 caracteres.',
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
                enabled: !busy,
              ),
              const SizedBox(height: 20),
              if (policy == null)
                const Text(
                  'El registro no está disponible en este momento. Puedes consultar Tips e intentarlo más tarde.',
                ),
              TextButton(
                key: const Key('signup.policy'),
                onPressed: policy == null || busy
                    ? null
                    : () async {
                        await showTreatmentPolicy(context, policy);
                        if (mounted) setState(() => _viewed = true);
                      },
                child: const Text('Leer política de tratamiento'),
              ),
              CheckboxListTile(
                key: const Key('signup.consent'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _accepted,
                onChanged: !_viewed || policy == null || busy
                    ? null
                    : (v) => setState(() => _accepted = v ?? false),
                title: const Text(
                  'Autorizo el tratamiento de mis datos para las finalidades de la política consultada.',
                ),
              ),
              if (_consentError)
                Text(
                  'Consulta la política y autoriza el tratamiento para crear tu cuenta.',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 20),
              AccountSubmit(
                key: const Key('signup.submit'),
                label: 'Crear cuenta',
                busy: busy,
                onPressed: policy == null ? null : _submit,
              ),
              TextButton(
                onPressed: busy
                    ? null
                    : () =>
                          Navigator.of(context).pushReplacementNamed('/signin'),
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
