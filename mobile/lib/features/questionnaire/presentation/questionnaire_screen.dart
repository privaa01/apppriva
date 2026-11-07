import 'package:flutter/material.dart';

import '../../account/application/account_controller.dart';
import '../../account/presentation/account_scaffold.dart';
import '../../navigation/application/navigation_controller.dart';
import '../application/questionnaire_controller.dart';

class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({
    super.key,
    required this.account,
    required this.controller,
    required this.navigation,
  });
  final AccountController account;
  final QuestionnaireController controller;
  final NavigationController navigation;

  @override
  Widget build(BuildContext context) => AccountScaffold(
        controller: account,
        title: 'Cuestionario',
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => _content(context),
        ),
      );

  Widget _content(BuildContext context) {
    switch (controller.questionnairePhase) {
      case QuestionnairePhase.idle:
        return _Notice(onStart: controller.start);
      case QuestionnairePhase.loading:
        return Center(
          child: Semantics(
            label: 'Preparando cuestionario',
            child: CircularProgressIndicator(),
          ),
        );
      case QuestionnairePhase.error:
        return _Message(
          title: 'No pudimos preparar el cuestionario',
          body: 'Inténtalo de nuevo. Tus respuestas no se guardan.',
          action: 'Reintentar',
          onPressed: controller.start,
        );
      case QuestionnairePhase.paused:
        return const _Message(
          title: 'Cuestionario en pausa',
          body: 'Revisa tu conexión. Continuaremos aquí cuando vuelva.',
        );
      case QuestionnairePhase.completed:
        return _Message(
          title: 'Respuestas listas',
          body: 'Tus respuestas siguen solo en este dispositivo durante esta sesión.',
          action: 'Ver resultado',
          onPressed: () => navigation.navigate(context, '/results'),
        );
      case QuestionnairePhase.active:
        final attempt = controller.activeAttempt!;
        final current = attempt.current;
        return Column(
          key: ValueKey(current.question.id),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pregunta ${attempt.index + 1} de 10',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: (attempt.index + 1) / 10),
            const SizedBox(height: 24),
            Text(
              current.question.prompt,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            for (final option in current.question.options)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Semantics(
                  selected: current.selectedOptionId == option.id,
                  child: InkWell(
                    onTap: () => controller.select(option.id),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 56),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xff9aaba4)),
                        color: current.selectedOptionId == option.id
                            ? const Color(0xffdcebe5)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            current.selectedOptionId == option.id
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(option.text)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: current.selectedOptionId == null
                  ? null
                  : () {
                      final completed = attempt.isLast;
                      if (controller.continueAttempt() && completed) {
                        navigation.navigate(context, '/results');
                      }
                    },
              child: Text(attempt.isLast ? 'Ver resultado' : 'Continuar'),
            ),
          ],
        );
    }
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.onStart});
  final VoidCallback onStart;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Antes de comenzar', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 18),
          const Text(
            'Responderás 10 situaciones educativas sobre privacidad y seguridad. '
            'Las respuestas y el resultado no se guardan. Si sales o envías la app '
            'a segundo plano, el intento se descartará.',
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: onStart, child: const Text('Comenzar')),
        ],
      );
}

class _Message extends StatelessWidget {
  const _Message({
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
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(body, textAlign: TextAlign.center),
              if (action != null) ...[
                const SizedBox(height: 24),
                FilledButton(onPressed: onPressed, child: Text(action!)),
              ],
            ],
          ),
        ),
      );
}
