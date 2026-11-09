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
  ZyroQuestionCategory? _selectedCategory;
  String? _selectedQuestion;

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
        const SizedBox(height: 20),
        Text(
          'Explora preguntas por categoría',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<ZyroQuestionCategory>(
          key: const Key('zyro.category'),
          initialValue: _selectedCategory,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Categoría'),
          hint: const Text('Elige una categoría'),
          items: [
            for (final category in LocalZyroGuide.questionCategories)
              DropdownMenuItem(
                value: category,
                child: Text(category.name, overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: (category) => setState(() {
            _selectedCategory = category;
            _selectedQuestion = null;
          }),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: const Key('zyro.question'),
          initialValue: _selectedQuestion,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Pregunta'),
          hint: const Text('Elige una pregunta'),
          items: [
            for (final question
                in _selectedCategory?.questions ?? const <String>[])
              DropdownMenuItem(
                value: question,
                child: Text(question, overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: _selectedCategory == null
              ? null
              : (question) => setState(() => _selectedQuestion = question),
        ),
        const SizedBox(height: 12),
        FilledButton.tonalIcon(
          key: const Key('zyro.askSelected'),
          onPressed: _selectedQuestion == null
              ? null
              : () => _send(_selectedQuestion),
          icon: const Icon(Icons.question_answer_outlined),
          label: const Text('Preguntar a Zyro'),
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
