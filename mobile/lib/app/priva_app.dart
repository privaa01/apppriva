import '../features/tips/data/tips_repository.dart';
import '../features/navigation/application/navigation_controller.dart';
import '../features/navigation/data/temporary_journey.dart';
import '../features/navigation/data/destination_catalog.dart';
import '../features/questionnaire/application/questionnaire_controller.dart';
import '../features/questionnaire/data/bundled_question_bank_repository.dart';
import '../features/questionnaire/data/platform_questionnaire_connectivity.dart';
import '../features/questionnaire/application/result_controller.dart';
import '../features/questionnaire/data/bundled_result_recommendation_repository.dart';

import 'package:flutter/material.dart';

import '../features/account/application/account_controller.dart';
import 'account_router.dart';
import '../features/profile/data/profile_repository.dart';
import '../features/profile/data/deletion_contact_service.dart';

class PrivaApp extends StatefulWidget {
  const PrivaApp({
    super.key,
    required this.controller,
    this.testMode = false,
    this.initialRoute = '/signin',
    this.destinationBuilder,
    this.builder,
    this.profileRepository,
    this.deletionContactService,
    this.temporaryJourney,
    this.tipsRepository,
  });
  final TipsRepository? tipsRepository;
  final TemporaryJourney? temporaryJourney;
  final AccountController controller;
  final bool testMode;
  final String initialRoute;
  final AccountDestinationBuilder? destinationBuilder;
  final TransitionBuilder? builder;
  final ProfileRepository? profileRepository;
  final DeletionContactService? deletionContactService;
  @override
  State<PrivaApp> createState() => _PrivaAppState();
}

class _PrivaAppState extends State<PrivaApp> with WidgetsBindingObserver {
  late TemporaryJourney _journey;
  late NavigationController _navigation;
  PlatformQuestionnaireConnectivity? _questionnaireConnectivity;
  ResultController? _result;
  void _createNavigation() {
    if (widget.temporaryJourney == null) {
      _questionnaireConnectivity = PlatformQuestionnaireConnectivity();
      _journey = QuestionnaireController(
        BundledQuestionBankRepository(),
        _questionnaireConnectivity!,
      );
      _result = ResultController(
        _journey as QuestionnaireController,
        BundledResultRecommendationRepository(),
      )..initialize();
    } else {
      _journey = widget.temporaryJourney!;
    }
    _navigation = NavigationController(widget.controller, _journey);
  }

  @override
  void initState() {
    super.initState();
    _createNavigation();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(PrivaApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.temporaryJourney != widget.temporaryJourney) {
      _navigation.dispose();
      _result?.dispose();
      _result = null;
      if (oldWidget.temporaryJourney == null) _journey.dispose();
      _questionnaireConnectivity?.dispose();
      _questionnaireConnectivity = null;
      _createNavigation();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      _navigation.lifecycle(state);
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _navigation.dispose();
    _result?.dispose();
    if (widget.temporaryJourney == null) _journey.dispose();
    _questionnaireConnectivity?.dispose();
    super.dispose();
  }

  final _profileObserver = RouteObserver<PageRoute<dynamic>>();
  @override
  Widget build(BuildContext context) {
    final router = AccountRouter(
      controller: widget.controller,
      tipsRepository: widget.tipsRepository,
      questionnaireController: _journey is QuestionnaireController
          ? _journey as QuestionnaireController
          : null,
      resultController: _result,
      navigation: _navigation,
      destinationBuilder: widget.destinationBuilder,
      profileRepository: widget.profileRepository,
      deletionContactService:
          widget.deletionContactService ?? PlatformDeletionContactService(),
      profileObserver: _profileObserver,
    );
    return MaterialApp(
      title: 'Priva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff193e33),
          primary: const Color(0xff193e33),
          onPrimary: Colors.white,
          surface: const Color(0xfff7f8f2),
          onSurface: const Color(0xff17382e),
          error: const Color(0xff9a2020),
        ),
        scaffoldBackgroundColor: const Color(0xfff7f8f2),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          contentPadding: const EdgeInsets.all(18),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(48, 52),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
      ),
      navigatorKey: _navigation.navigatorKey,
      initialRoute:
          widget.initialRoute == '/signin' &&
              widget.controller.state.canAccessPrivate
          ? '/home'
          : widget.initialRoute,
      navigatorObservers: [_profileObserver, _navigation.observer],
      onGenerateInitialRoutes: (route) => [
        if (route.startsWith('/tips/') && destinationFor(route) != null)
          router.onGenerateRoute(const RouteSettings(name: '/tips')),
        router.onGenerateRoute(RouteSettings(name: route)),
      ],
      onGenerateRoute: router.onGenerateRoute,
      builder: (context, child) {
        final built =
            widget.builder?.call(context, child) ?? child ?? const SizedBox();
        final content = NavigationScope(
          controller: _navigation,
          child: AnimatedBuilder(
            animation: _navigation,
            child: built,
            builder: (context, child) {
              final sensitive = const [
                '/questionnaire',
                '/results',
              ].contains(_navigation.state.path);
              final hidden = _navigation.obscured && sensitive;
              return Stack(
                fit: StackFit.expand,
                children: [
                  ExcludeSemantics(
                    excluding: hidden,
                    child: IgnorePointer(ignoring: hidden, child: child!),
                  ),
                  if (hidden)
                    const Positioned.fill(
                      child: ColoredBox(color: Color(0xfff7f8f2)),
                    ),
                ],
              );
            },
          ),
        );
        if (!widget.testMode) return content;
        return Column(
          children: [
            Material(
              color: const Color(0xffffefb8),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Entorno de pruebas. Usa solo datos ficticios.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
            Expanded(child: content),
          ],
        );
      },
    );
  }
}
