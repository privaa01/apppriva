import '../features/tips/presentation/tips_catalog_screen.dart';
import '../features/tips/presentation/tip_detail_screen.dart';
import '../features/tips/data/tips_repository.dart';
import '../features/zyro/application/zyro_controller.dart';
import '../features/zyro/presentation/zyro_screen.dart';
import '../features/navigation/application/navigation_controller.dart';
import '../features/navigation/data/destination_catalog.dart';
import '../features/navigation/presentation/home_screen.dart';
import '../features/questionnaire/application/questionnaire_controller.dart';
import '../features/questionnaire/presentation/questionnaire_screen.dart';

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
    this.navigation,
    this.tipsRepository,
    this.zyroController,
    this.questionnaireController,
  });
  final QuestionnaireController? questionnaireController;
  final ZyroController? zyroController;
  final TipsRepository? tipsRepository;
  final NavigationController? navigation;
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
          navigation: navigation,
          tipsRepository: tipsRepository,
          zyroController: zyroController,
          questionnaireController: questionnaireController,
        );
    }
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => navigation == null
          ? child
          : NavigationPageGuard(
              controller: navigation!,
              path: path,
              child: child,
            ),
    );
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
    this.navigation,
    this.tipsRepository,
    this.zyroController,
    this.questionnaireController,
  });
  final QuestionnaireController? questionnaireController;
  final ZyroController? zyroController;
  final TipsRepository? tipsRepository;
  final AccountController controller;
  final String path;
  final AccountDestinationBuilder? builder;
  final ProfileRepository? profileRepository;
  final DeletionContactService? contact;
  final RouteObserver<PageRoute<dynamic>>? observer;
  final NavigationController? navigation;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: navigation == null
        ? controller
        : Listenable.merge([controller, navigation!]),
    builder: (context, _) {
      final destination = destinationFor(path);
      if (destination == null) {
        return AccountScaffold(
          controller: controller,
          title: 'Sección no encontrada',
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => navigation?.navigate(context, '/tips'),
              child: const Text('Volver a Tips'),
            ),
          ),
        );
      }
      if (!canOpenDestination(path, controller.state)) {
        return SigninScreen(controller: controller, accessRequired: true);
      }
      if (destination.requiresResult && navigation?.hasResult != true) {
        return AccountScaffold(
          controller: controller,
          title: 'No hay un resultado disponible',
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => navigation?.navigate(context, '/questionnaire'),
              child: const Text('Volver al cuestionario'),
            ),
          ),
        );
      }
      if (builder == null && path == '/tips') {
        return TipsCatalogScreen(
          account: controller,
          repository: tipsRepository ?? const UnavailableTipsRepository(),
          observer: observer,
        );
      }
      if (builder == null && path.startsWith('/tips/')) {
        return TipDetailScreen(
          account: controller,
          categoryId: path.split('/').last,
          repository: tipsRepository ?? const UnavailableTipsRepository(),
          observer: observer,
        );
      }
      if (path == '/home' && builder == null) {
        return HomeScreen(account: controller);
      }
      if (path == '/chat' && builder == null && zyroController != null) {
        return ZyroScreen(account: controller, controller: zyroController!);
      }
      if (path == '/questionnaire' &&
          builder == null &&
          questionnaireController != null &&
          navigation != null) {
        return QuestionnaireScreen(
          account: controller,
          controller: questionnaireController!,
          navigation: navigation!,
        );
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
