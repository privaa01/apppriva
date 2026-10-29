import 'package:flutter/material.dart';

import '../features/profile/data/profile_repository.dart';
import '../features/profile/data/deletion_contact_service.dart';
import '../features/profile/presentation/profile_screen.dart';

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
  AccountRouter({
    required this.controller,
    this.destinationBuilder,
    this.profileRepository,
    this.deletionContactService,
    this.profileObserver,
  });
  final AccountController controller;
  final AccountDestinationBuilder? destinationBuilder;
  final ProfileRepository? profileRepository;
  final DeletionContactService? deletionContactService;
  final RouteObserver<PageRoute<dynamic>>? profileObserver;
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
          profileRepository: profileRepository,
          contact: deletionContactService,
          observer: profileObserver,
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
    this.profileRepository,
    this.contact,
    this.observer,
  });
  final AccountController controller;
  final String path;
  final AccountDestinationBuilder? builder;
  final ProfileRepository? profileRepository;
  final DeletionContactService? contact;
  final RouteObserver<PageRoute<dynamic>>? observer;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      if (!canOpenDestination(path, controller.state)) {
        return SigninScreen(controller: controller, accessRequired: true);
      }
      if (path == '/profile' && profileRepository != null && builder == null) {
        return ProfileScreen(
          key: ValueKey(controller.state.session!.userId),
          account: controller,
          repository: profileRepository!,
          contact: contact ?? PlatformDeletionContactService(),
          observer: observer,
        );
      }
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
