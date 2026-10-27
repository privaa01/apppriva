import 'package:flutter/material.dart';

import '../features/account/application/account_controller.dart';
import '../features/account/application/account_state.dart';
import '../features/account/presentation/account_scaffold.dart';
import '../features/account/presentation/signin_screen.dart';
import '../features/account/presentation/signup_screen.dart';
import '../features/account/presentation/email_confirmation_view.dart';
import '../features/account/presentation/password_recovery_view.dart';

typedef AccountDestinationBuilder = Widget Function(
  BuildContext context,
  String path,
);

class AccountRouter {
  AccountRouter({required this.controller, this.destinationBuilder});
  final AccountController controller;
  final AccountDestinationBuilder? destinationBuilder;
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final path = settings.name ?? '/signin';
    Widget child;
    switch (path) {
      case '/signin':
        child = SigninScreen(controller: controller);
      case '/signup':
        child = SignupScreen(controller: controller);
      case '/confirm':
        child = EmailConfirmationView(controller: controller);
      case '/recovery':
        child = PasswordRecoveryView(controller: controller);
      default:
        child = _GuardedDestination(
          controller: controller,
          path: path,
          builder: destinationBuilder,
        );
    }
    return MaterialPageRoute<void>(settings: settings, builder: (_) => child);
  }
}

class _GuardedDestination extends StatelessWidget {
  const _GuardedDestination({
    required this.controller,
    required this.path,
    this.builder,
  });
  final AccountController controller;
  final String path;
  final AccountDestinationBuilder? builder;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      if (!canOpenDestination(path, controller.state))
        return SigninScreen(controller: controller, accessRequired: true);
      final title = switch (path) {
        '/tips' => 'Tips',
        '/home' => 'Inicio',
        '/profile' => 'Perfil',
        '/chat' => 'Chat IA',
        '/questionnaire' => 'Cuestionario',
        '/results' => 'Resultados',
        _ => 'Priva',
      };
      return AccountScaffold(
        controller: controller,
        title: title,
        child:
            builder?.call(context, path) ??
            const Text(
              'El contenido de esta sección no está disponible en este momento.',
              textAlign: TextAlign.center,
            ),
      );
    },
  );
}
