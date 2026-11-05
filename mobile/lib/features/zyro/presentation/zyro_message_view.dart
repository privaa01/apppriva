import 'package:flutter/material.dart';

import '../domain/zyro_message.dart';

class ZyroMessageView extends StatelessWidget {
  const ZyroMessageView({super.key, required this.message});
  final ZyroMessage message;

  @override
  Widget build(BuildContext context) {
    final author = message.role == ZyroRole.user ? 'Tú' : 'Zyro';
    final isGuide = message.kind == ZyroKind.guide;
    return Semantics(
      container: true,
      label: '$author: ${message.text}',
      child: Card(
        key: ValueKey('zyro.message.${message.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 6),
              Text(message.text),
              if (message.kind == ZyroKind.limit) ...[
                const SizedBox(height: 8),
                const Text(
                  'Límite de orientación',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              if (isGuide) ...[
                const SizedBox(height: 12),
                const Text(
                  'Pasos de la guía verificada',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              for (var index = 0; index < message.steps.length; index++)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Semantics(
                    label:
                        'Paso ${index + 1} de ${message.steps.length}: ${message.steps[index]}',
                    child: Text('${index + 1}. ${message.steps[index]}'),
                  ),
                ),
              if (isGuide) ...[
                const SizedBox(height: 12),
                Text(
                  'Revisión ${message.guideRevision}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
