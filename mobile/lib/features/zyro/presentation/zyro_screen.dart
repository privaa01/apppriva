import 'package:flutter/material.dart';

import '../../account/application/account_controller.dart';
import '../../account/presentation/account_scaffold.dart';
import '../application/zyro_controller.dart';
import '../domain/zyro_message.dart';

class ZyroScreen extends StatefulWidget {
  const ZyroScreen({
    super.key,
    required this.account,
    required this.controller,
  });
  final AccountController account;
  final ZyroController controller;
  @override
  State<ZyroScreen> createState() => _ZyroScreenState();
}

class _ZyroScreenState extends State<ZyroScreen> {
  final input = TextEditingController();
  @override
  void dispose() {
    input.dispose();
    widget.controller.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AccountScaffold(
    controller: widget.account,
    title: 'Asistente Zyro',
    navigationPath: '/chat',
    child: AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/zyro/zyro.png',
            height: 150,
            semanticLabel: 'Zyro, asistente educativo de Priva',
          ),
          const Text(
            'Soy Zyro. Te oriento sobre privacidad y seguridad. No compartas contraseñas, códigos ni datos sensibles.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          for (final m in widget.controller.messages) _Message(message: m),
          if (widget.controller.busy)
            Semantics(liveRegion: true, child: LinearProgressIndicator()),
          if (widget.controller.error != null)
            Semantics(
              liveRegion: true,
              child: Column(
                children: [
                  Text(widget.controller.error!),
                  TextButton(
                    onPressed: widget.controller.retry,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: input,
            maxLength: 1000,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Escribe tu mensaje'),
          ),
          FilledButton(
            onPressed: widget.controller.busy
                ? null
                : () {
                    final text = input.text;
                    input.clear();
                    widget.controller.send(text);
                  },
            child: const Text('Enviar'),
          ),
        ],
      ),
    ),
  );
}

class _Message extends StatelessWidget {
  const _Message({required this.message});
  final ZyroMessage message;
  @override
  Widget build(BuildContext context) => Semantics(
    label: (message.role == ZyroRole.user ? 'Tú: ' : 'Zyro: ') + message.text,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.role == ZyroRole.user ? 'Tú' : 'Zyro',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(message.text),
            for (final step in message.steps) Text('• $step'),
          ],
        ),
      ),
    ),
  );
}
