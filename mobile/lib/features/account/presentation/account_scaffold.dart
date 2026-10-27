import 'package:flutter/material.dart';

import '../application/account_controller.dart';
import '../application/account_state.dart';

void openAccountDestination(
  BuildContext context,
  String path,
  AccountController controller,
) {
  if (!canOpenDestination(path, controller.state)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inicia sesión para continuar.')),
    );
    if (ModalRoute.of(context)?.settings.name != '/signin') {
      Navigator.of(context).pushNamed('/signin');
    }
    return;
  }
  Navigator.of(context).pushNamed(path);
}

class AccountScaffold extends StatelessWidget {
  const AccountScaffold({
    super.key,
    required this.controller,
    required this.title,
    required this.child,
    this.navigation = true,
  });
  final AccountController controller;
  final String title;
  final Widget child;
  final bool navigation;
  @override
  Widget build(BuildContext context) {
    final large = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    Widget destination(String label, IconData icon, String route) => Expanded(
      child: TextButton(
        onPressed: () => openAccountDestination(context, route, controller),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: navigation
          ? PreferredSize(
              preferredSize: Size.fromHeight(large ? 124 : 90),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      destination('Inicio', Icons.home_outlined, '/home'),
                      const Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shield_outlined),
                            Text(
                              'Priva',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      destination('Perfil', Icons.person_outline, '/profile'),
                    ],
                  ),
                ),
              ),
            )
          : AppBar(title: const Text('Priva')),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              key: const Key('account.scroll'),
              padding: const EdgeInsets.all(24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 28),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: navigation
          ? SafeArea(
              top: false,
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      destination('Tips', Icons.push_pin_outlined, '/tips'),
                      destination(
                        'Chat IA',
                        Icons.chat_bubble_outline,
                        '/chat',
                      ),
                      destination(
                        'Cuestionario',
                        Icons.quiz_outlined,
                        '/questionnaire',
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class AccountMessages extends StatelessWidget {
  const AccountMessages({super.key, required this.controller});
  final AccountController controller;
  @override
  Widget build(BuildContext context) {
    final error = controller.state.error;
    final notice = controller.state.notice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Semantics(
              liveRegion: true,
              child: Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
        if (notice != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Semantics(liveRegion: true, child: Text(notice)),
          ),
      ],
    );
  }
}

String? accountEmailValidator(String? value) =>
    value == null ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())
    ? 'Escribe un correo válido.'
    : null;
String? accountPasswordValidator(String? value) =>
    value == null || value.length < 12 ? 'Usa al menos 12 caracteres.' : null;

class AccountSubmit extends StatelessWidget {
  const AccountSubmit({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });
  final String label;
  final bool busy;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy ? null : onPressed,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: busy
          ? Semantics(
              label: 'Enviando solicitud',
              liveRegion: true,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : Text(label, textAlign: TextAlign.center),
    ),
  );
}
