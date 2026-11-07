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

class _Message {
  const _Message(this.text, this.user);
  final String text;
  final bool user;
}

class _ZyroScreenState extends State<ZyroScreen> {
  final _controller = TextEditingController();
  final _guide = const LocalZyroGuide();
  final _messages = <_Message>[
    const _Message(
      'Soy Zyro, tu asistente para aprender sobre privacidad y seguridad digital. '
      'Te orientaré con información verificada.',
      false,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _messages.clear();
    super.dispose();
  }

  void _send([String? prompt]) {
    final text = (prompt ?? _controller.text).trim();
    if (text.isEmpty) return;
    final reply = _guide.answer(text);
    setState(() {
      _messages.add(_Message(text, true));
      _messages.add(_Message(reply.text, false));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) => AccountScaffold(
    controller: widget.account,
    title: 'Asistente Zyro',
    navigationPath: '/chat',
    heading: Row(
      children: [
        Image.asset(
          'assets/images/zyro/zyro.png',
          width: 84,
          height: 84,
          fit: BoxFit.contain,
          semanticLabel: 'Zyro, asistente de Priva',
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Asistente Zyro',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Text('Orientación local de privacidad y seguridad'),
            ],
          ),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xfffff2c7),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(child: Icon(Icons.privacy_tip_outlined)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No compartas contraseñas, códigos, documentos ni datos privados. '
                  'La conversación se borra al salir de esta pantalla.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text('Temas rápidos', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: LocalZyroGuide.quickPrompts
              .map(
                (prompt) => ActionChip(
                  key: ValueKey('zyro.quick.$prompt'),
                  label: Text(prompt),
                  onPressed: () => _send(prompt),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 20),
        ..._messages.map(
          (message) => Align(
            alignment: message.user
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Semantics(
              label: message.user ? 'Tu mensaje' : 'Respuesta de Zyro',
              child: Container(
                constraints: const BoxConstraints(maxWidth: 430),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: message.user
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: message.user
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('zyro.input'),
          controller: _controller,
          minLines: 1,
          maxLines: 4,
          maxLength: 300,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _send(),
          decoration: InputDecoration(
            labelText: 'Escribe una consulta general',
            hintText: 'Ejemplo: ¿Cómo protejo mi cuenta?',
            suffixIcon: IconButton(
              key: const Key('zyro.send'),
              tooltip: 'Enviar consulta',
              onPressed: _send,
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ),
      ],
    ),
  );
}
