import 'package:flutter/material.dart';

import '../application/connectivity_controller.dart';

class ConnectivityNotice extends StatelessWidget {
  const ConnectivityNotice({
    super.key,
    required this.controller,
    required this.child,
    this.onRetry,
  });

  final ConnectivityController controller;
  final Widget child;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    child: child,
    builder: (context, child) => Column(
      children: [
        if (!controller.available)
          Material(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Semantics(
              liveRegion: true,
              container: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const ExcludeSemantics(
                      child: Icon(Icons.wifi_off_outlined),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'No hay conexión. Revisa Internet y vuelve a intentarlo.',
                      ),
                    ),
                    TextButton(
                      key: const Key('connectivity.retry'),
                      onPressed: controller.retrying
                          ? null
                          : () =>
                                controller.retry(onRetry ?? controller.refresh),
                      child: Text(
                        controller.retrying
                            ? 'Intentando de nuevo…'
                            : 'Reintentar',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(child: child!),
      ],
    ),
  );
}
