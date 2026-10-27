import 'package:flutter/material.dart';

import '../features/account/application/account_controller.dart';
import 'account_router.dart';

class PrivaApp extends StatelessWidget {
  const PrivaApp({
    super.key,
    required this.controller,
    this.testMode = false,
    this.initialRoute = '/signin',
    this.destinationBuilder,
    this.builder,
  });
  final AccountController controller;
  final bool testMode;
  final String initialRoute;
  final AccountDestinationBuilder? destinationBuilder;
  final TransitionBuilder? builder;
  @override
  Widget build(BuildContext context) {
    final router = AccountRouter(
      controller: controller,
      destinationBuilder: destinationBuilder,
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
      initialRoute: initialRoute,
      onGenerateInitialRoutes: (route) => [
        router.onGenerateRoute(RouteSettings(name: route)),
      ],
      onGenerateRoute: router.onGenerateRoute,
      builder: (context, child) {
        final built =
            builder?.call(context, child) ?? child ?? const SizedBox();
        if (!testMode) return built;
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
            Expanded(child: built),
          ],
        );
      },
    );
  }
}
