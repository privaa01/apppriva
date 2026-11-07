import 'package:flutter/material.dart';

import '../../account/application/account_controller.dart';
import '../../account/presentation/account_scaffold.dart';
import '../../navigation/application/navigation_controller.dart';
import '../../navigation/data/temporary_journey.dart';
import '../application/questionnaire_controller.dart';
import '../application/result_controller.dart';
import '../domain/question.dart';
import '../domain/result_assessment.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.account,
    required this.questionnaire,
    required this.controller,
    required this.navigation,
  });
  final AccountController account;
  final QuestionnaireController questionnaire;
  final ResultController controller;
  final NavigationController navigation;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  Future<void> _repeat() async {
    if (!widget.controller.beginRestart()) return;
    widget.questionnaire.discard(DiscardReason.exit);
    await widget.navigation.navigate(context, '/questionnaire');
    await widget.questionnaire.start();
  }

  @override
  Widget build(BuildContext context) => AccountScaffold(
    controller: widget.account,
    title: 'Resultado orientativo',
    child: AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => switch (widget.controller.phase) {
        ResultPhase.loading => const Center(
          child: CircularProgressIndicator(
            semanticsLabel: 'Preparando resultado orientativo',
          ),
        ),
        ResultPhase.error => _ResultMessage(
          title: 'No pudimos preparar el resultado',
          body: 'Tus respuestas siguen solo en memoria. Inténtalo de nuevo.',
          action: 'Reintentar',
          onPressed: widget.controller.load,
        ),
        ResultPhase.restarting => const _ResultMessage(
          title: 'Preparando otro cuestionario',
          body: 'El resultado anterior ya fue descartado.',
        ),
        ResultPhase.ready => _ReadyResult(
          assessment: widget.controller.assessment!,
          onRepeat: _repeat,
        ),
      },
    ),
  );
}

class _ReadyResult extends StatelessWidget {
  const _ReadyResult({required this.assessment, required this.onRepeat});
  final ResultAssessment assessment;
  final VoidCallback onRepeat;

  @override
  Widget build(BuildContext context) {
    final level = _levelLabel(assessment.level);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            '${assessment.formattedPercent} % · Nivel $level',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 12),
        Text(_levelExplanation(assessment.level), textAlign: TextAlign.center),
        const SizedBox(height: 18),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Este resultado es orientativo y se basa en tus respuestas. '
              'No mide la probabilidad real de que se filtren tus datos.',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Prioridades para mejorar',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        for (final module in assessment.priorities)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      _topicLabel(module.topic),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final action in module.actions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('• $action'),
                    ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('result.repeat'),
          onPressed: onRepeat,
          child: const Text('Repetir cuestionario'),
        ),
      ],
    );
  }
}

class _ResultMessage extends StatelessWidget {
  const _ResultMessage({
    required this.title,
    required this.body,
    this.action,
    this.onPressed,
  });
  final String title;
  final String body;
  final String? action;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 12),
      Text(body, textAlign: TextAlign.center),
      if (action != null) ...[
        const SizedBox(height: 20),
        FilledButton(onPressed: onPressed, child: Text(action!)),
      ],
    ],
  );
}

String _levelLabel(ResultLevel level) => switch (level) {
  ResultLevel.low => 'bajo',
  ResultLevel.medium => 'medio',
  ResultLevel.high => 'alto',
};

String _levelExplanation(ResultLevel level) => switch (level) {
  ResultLevel.low => 'Tus respuestas muestran prácticas de menor exposición. Mantén y revisa estos hábitos.',
  ResultLevel.medium =>
    'Tus respuestas muestran algunas prácticas que conviene reforzar.',
  ResultLevel.high => 'Tus respuestas muestran varias prácticas que conviene revisar con prioridad.',
};

String _topicLabel(QuestionTopic topic) => switch (topic) {
  QuestionTopic.passwords => 'Contraseñas y credenciales',
  QuestionTopic.access => 'Autenticación y control de acceso',
  QuestionTopic.networks => 'Redes, Wi-Fi y conectividad',
  QuestionTopic.phishing => 'Phishing, correo e ingeniería social',
  QuestionTopic.devices => 'Dispositivos, antivirus y actualizaciones',
};
