import 'dart:async';

import 'package:flutter/material.dart';

import '../../account/application/account_controller.dart';
import '../../account/presentation/account_scaffold.dart';
import '../application/tips_controller.dart';
import '../data/tip_content.dart';
import '../data/tips_repository.dart';

/// The same lifecycle and recovery rules apply to catalog and detail routes.
class TipsPage extends StatefulWidget {
  const TipsPage({
    super.key,
    required this.account,
    required this.repository,
    this.categoryId,
    this.observer,
  });
  final AccountController account;
  final TipsRepository repository;
  final String? categoryId;
  final RouteObserver<PageRoute<dynamic>>? observer;
  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> with RouteAware {
  late TipsController controller;
  PageRoute<dynamic>? _route;
  void _create() => controller = TipsController(
    widget.repository,
    categoryId: widget.categoryId,
  );
  @override
  void initState() {
    super.initState();
    _create();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute && route != _route) {
      widget.observer?.unsubscribe(this);
      _route = route;
      widget.observer?.subscribe(this, route);
      if (route.isCurrent) unawaited(controller.load());
    }
  }

  @override
  void didUpdateWidget(TipsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.observer != widget.observer) {
      oldWidget.observer?.unsubscribe(this);
      if (_route != null) widget.observer?.subscribe(this, _route!);
    }
    if (oldWidget.repository != widget.repository ||
        oldWidget.categoryId != widget.categoryId) {
      controller.dispose();
      _create();
      if (_route?.isCurrent ?? true) unawaited(controller.load());
    }
  }

  @override
  void didPushNext() => controller.covered();
  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && (_route?.isCurrent ?? false)) unawaited(controller.load());
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    widget.observer?.unsubscribe(this);
    controller.dispose();
    super.dispose();
  }

  Widget _panel(Widget child, {Color color = Colors.white}) => Card(
    margin: EdgeInsets.zero,
    color: color,
    elevation: 3,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: Padding(padding: const EdgeInsets.all(18), child: child),
  );
  Widget _heading(String text) => Semantics(
    header: true,
    child: Text(
      text,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
  );
  void _catalog() => openAccountDestination(context, '/tips', widget.account);
  Widget _hero() => LayoutBuilder(
    builder: (context, box) {
      final large = MediaQuery.textScalerOf(context).scale(1) > 1.3;
      final text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heading('¡Tengo estos tips para ti!'),
          const SizedBox(height: 20),
          const Text(
            'Aquí tienes unos consejos prácticos para cuidar tu privacidad digital todos los días.',
            style: TextStyle(fontSize: 18),
          ),
        ],
      );
      final image = ExcludeSemantics(
        child: Image.asset(
          'assets/images/zyro/zyro.png',
          width: 110,
          height: 170,
          fit: BoxFit.contain,
        ),
      );
      if (large || box.maxWidth < 280) {
        return Column(children: [text, const SizedBox(height: 12), image]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: text),
          image,
        ],
      );
    },
  );
  Widget _catalogContent() => _panel(
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final tip in controller.content)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.catalogTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(tip.description),
                const SizedBox(height: 6),
                Semantics(
                  container: true,
                  label: 'Ver más: ${tip.catalogTitle}',
                  button: true,
                  excludeSemantics: true,
                  onTap: () =>
                      openAccountDestination(context, tip.path, widget.account),
                  child: FilledButton(
                    key: Key('tips.open.${tip.categoryId}'),
                    onPressed: () => openAccountDestination(
                      context,
                      tip.path,
                      widget.account,
                    ),
                    child: const Text('Ver más'),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
  Widget _example(TipContent tip) {
    final e = tip.example;
    final content = <Widget>[
      _heading('Ejemplo'),
      const SizedBox(height: 8),
      Text(
        e['fictionalLabel'] as String,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
    ];
    switch (tip.categoryId) {
      case 'passwords':
        content.addAll([
          Text(
            controller.passwordVisible
                ? e['value'] as String
                : '••••••••••••••••',
            key: const Key('tips.password.value'),
            style: const TextStyle(fontSize: 18),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              key: const Key('tips.password.toggle'),
              tooltip: controller.passwordVisible
                  ? 'Ocultar contraseña de ejemplo'
                  : 'Mostrar contraseña de ejemplo',
              onPressed: controller.togglePassword,
              icon: Icon(
                controller.passwordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
          Text(e['caption'] as String),
        ]);
      case 'sharing':
        content.addAll([
          const ExcludeSemantics(child: Icon(Icons.photo_outlined, size: 52)),
          Text('«${e['body']}»'),
          const SizedBox(height: 10),
          Text(e['caption'] as String),
        ]);
      case 'links':
        content.addAll([
          const ExcludeSemantics(
            child: Icon(Icons.warning_amber_outlined, size: 40),
          ),
          Text('«${e['body']}»'),
          const SizedBox(height: 12),
          Text(e['address'] as String),
          const SizedBox(height: 10),
          Text(e['caption'] as String),
        ]);
      case 'profiles':
        content.addAll([
          const ExcludeSemantics(child: Icon(Icons.person_outline, size: 52)),
          Text(
            e['name'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(e['handle'] as String),
          const SizedBox(height: 12),
          for (final signal in e['signals'] as List<String>)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('• $signal'),
            ),
        ]);
    }
    content.addAll([
      const SizedBox(height: 16),
      Semantics(
        container: true,
        label: 'Ver ejemplo: ${tip.catalogTitle}',
        button: true,
        expanded: controller.exampleExpanded,
        excludeSemantics: true,
        onTap: controller.revealExample,
        child: FilledButton(
          key: Key('tips.example.${tip.categoryId}'),
          onPressed: controller.revealExample,
          child: const Text('Ver ejemplo'),
        ),
      ),
      if (controller.exampleExpanded)
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Semantics(
            liveRegion: true,
            child: Text(
              tip.explanation,
              key: Key('tips.explanation.${tip.categoryId}'),
            ),
          ),
        ),
    ]);
    return _panel(
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: content),
    );
  }

  Widget _detail(TipContent tip) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(tip.description, textAlign: TextAlign.right),
      const SizedBox(height: 28),
      _heading(tip.panelTitle),
      const SizedBox(height: 18),
      for (final recommendation in tip.recommendations)
        Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Text(recommendation),
        ),
      const SizedBox(height: 8),
      _example(tip),
      if (tip.clarification.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Text(tip.clarification),
        ),
      const SizedBox(height: 24),
      _panel(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExcludeSemantics(
              child: Icon(Icons.verified_user_outlined, size: 40),
            ),
            _heading('Consejo'),
            const SizedBox(height: 12),
            Text(tip.advice),
          ],
        ),
        color: const Color(0xffa7b9a5),
      ),
    ],
  );
  Widget _body() {
    switch (controller.phase) {
      case TipsPhase.loading:
        return Semantics(
          liveRegion: true,
          child: const Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando consejos…'),
            ],
          ),
        );
      case TipsPhase.ready:
        return widget.categoryId == null
            ? _catalogContent()
            : _detail(controller.content.single);
      case TipsPhase.error:
      case TipsPhase.unavailable:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              liveRegion: true,
              child: Text(
                controller.phase == TipsPhase.error
                    ? 'No pudimos cargar los consejos. Inténtalo de nuevo.'
                    : 'Este contenido no está disponible en este momento.',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => unawaited(controller.load()),
              child: const Text('Reintentar'),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      final detail = widget.categoryId != null;
      final title = controller.phase == TipsPhase.ready && detail
          ? controller.content.single.title
          : detail
          ? TipContent.catalogTitles[widget.categoryId]!
          : 'Tips';
      return DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 18),
        child: AccountScaffold(
          controller: widget.account,
          title: title,
          heading: detail
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _catalog,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Volver a Tips'),
                      ),
                    ),
                    Semantics(
                      header: true,
                      child: Text(
                        title,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              : _hero(),
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontSize: 18),
            child: _body(),
          ),
        ),
      );
    },
  );
}
