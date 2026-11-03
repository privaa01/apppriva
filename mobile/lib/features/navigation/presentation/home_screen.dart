import 'dart:async';

import 'package:flutter/material.dart';

import '../../account/application/account_controller.dart';
import '../../account/presentation/account_scaffold.dart';
import '../application/navigation_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.account});
  final AccountController account;
  @override
  Widget build(BuildContext context) {
    Widget tool(String title, String text, IconData icon, String path) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Card(
            child: ListTile(
              key: ValueKey('home.$path'),
              contentPadding: const EdgeInsets.all(20),
              leading: ExcludeSemantics(child: Icon(icon)),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(text),
              onTap: () {
                final nav = NavigationScope.maybeOf(context);
                if (nav != null) unawaited(nav.navigate(context, path));
              },
            ),
          ),
        );
    return AccountScaffold(
      controller: account,
      title: 'Inicio',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Conoce las herramientas de Priva para aprender sobre privacidad y seguridad.',
          ),
          const SizedBox(height: 24),
          tool(
            'Tips',
            'Aprende hábitos para cuidar tu información',
            Icons.push_pin_outlined,
            '/tips',
          ),
          tool(
            'Chat IA',
            'Consulta a Zyro sobre privacidad y seguridad',
            Icons.chat_bubble_outline,
            '/chat',
          ),
          tool(
            'Cuestionario',
            'Reflexiona sobre tus hábitos digitales',
            Icons.quiz_outlined,
            '/questionnaire',
          ),
        ],
      ),
    );
  }
}
