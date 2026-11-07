import 'package:flutter/material.dart';

import '../../account/application/account_controller.dart';
import '../../account/presentation/account_scaffold.dart';
import '../data/local_zyro_guide.dart';

class ZyroScreen extends StatefulWidget {
  const ZyroScreen({super.key, required this.account});
  final AccountController account;

  @override
  State<ZyroScreen> createState() => _ZyroScreenState();
}

class _ZyroScreenState extends State<ZyroScreen> {
  final _input = TextEditingController();
  final _guide = const LocalZyroGuide();
  final _messages = <({bool fromUser, String text})>[];

  void _send([String? prompt]) {
    final text = (prompt ?? _input.text).trim();
    if (text.isEmpty) return;
    final reply = _guide.answer(text);
    setState(() {
      _messages.add((fromUser: true, text: text));
      _messages.add((fromUser: false, text: reply.text));
      _input.clear();
    });
  }

  @override
  void dispose() {
    _messages.clear();
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AccountScaffold(
    controller: widget.account,
    title: 'Asistente Zyro',
    navigationPath: '/chat',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          'assets/images/zyro/zyro.png',
          height: 140,
          semanticLabel: 'Zyro, asistente educativo de Priva',
        ),
        const Text(
          'Soy Zyro, tu asistente local de privacidad y seguridad digital.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'No compartas contraseñas, códigos de verificación ni datos privados. '
          'La conversación se borra cuando sales de esta pantalla.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final prompt in LocalZyroGuide.quickPrompts)
              ActionChip(
                key: ValueKey('zyro.quick.$prompt'),
                label: Text(prompt),
                onPressed: () => _send(prompt),
              ),
          ],
        ),
        const SizedBox(height: 16),
        for (final message in _messages)
          Align(
            alignment: message.fromUser
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Semantics(
              label: message.fromUser ? 'Tú' : 'Zyro',
              child: Card(
                color: message.fromUser
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(message.text),
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('zyro.input'),
          controller: _input,
          maxLength: 300,
          maxLines: 3,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _send(),
          decoration: const InputDecoration(
            labelText: 'Escribe tu consulta',
            hintText: 'Ejemplo: ¿Cómo protejo mi cuenta?',
          ),
        ),
        FilledButton.icon(
          key: const Key('zyro.send'),
          onPressed: _send,
          icon: const Icon(Icons.send),
          label: const Text('Enviar'),
        ),
      ],
    ),
  );
}
