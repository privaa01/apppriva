import 'package:flutter/material.dart';

import '../../account/application/account_controller.dart';
import '../../account/presentation/account_scaffold.dart';
import '../application/zyro_controller.dart';
import 'zyro_message_view.dart';

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
  final inputFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_restoreFailedDraft);
  }

  @override
  void didUpdateWidget(ZyroScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_restoreFailedDraft);
      widget.controller.addListener(_restoreFailedDraft);
    }
  }

  void _restoreFailedDraft() {
    if (widget.controller.error != null && input.text.isEmpty) {
      input.text = widget.controller.failedDraft ?? '';
      input.selection = TextSelection.collapsed(offset: input.text.length);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_restoreFailedDraft);
    input.dispose();
    inputFocus.dispose();
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
          for (final message in widget.controller.messages)
            ZyroMessageView(message: message),
          if (widget.controller.busy)
            Semantics(liveRegion: true, child: LinearProgressIndicator()),
          if (widget.controller.error != null)
            Semantics(
              liveRegion: true,
              child: Column(
                children: [
                  Text(widget.controller.error!),
                  TextButton(
                    key: const Key('zyro.retry'),
                    onPressed: () {
                      input.clear();
                      widget.controller.retry();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('zyro.input'),
            controller: input,
            focusNode: inputFocus,
            maxLength: 1000,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Escribe tu mensaje'),
          ),
          FilledButton(
            key: const Key('zyro.send'),
            onPressed: widget.controller.busy
                ? null
                : () {
                    final text = input.text;
                    input.clear();
                    widget.controller.send(text);
                    inputFocus.requestFocus();
                  },
            child: const Text('Enviar'),
          ),
        ],
      ),
    ),
  );
}
