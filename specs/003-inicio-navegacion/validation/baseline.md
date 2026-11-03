# Baseline F03 — 2026-11-03

Código baseline:2cd833f; antes de cambiar código de producto. Flutter3.47.8,
Dart3.13.7, engine cf636b1dfb818dd6a3ff16e390e93b1a036969c8, clon oficial
en /tmp/priva-flutter. flutter pub get resolvió lockfile sin cambios.

- flutter test --no-pub: **103 satisfactorias**,0 fallidas, ejecución nueva.
- flutter analyze --fatal-infos en host: bloqueado por /home/agent/.dartServer
  de solo lectura; no es fallo de código.
- PRIVA_FLUTTER_ROOT=/tmp/priva-flutter bash mobile/tool/analyze.sh con PUB_CACHE
  en /tmp/priva-pub: **0 diagnósticos**, exit0, contenedor fijado por digest,
  --network none.

Logs de trabajo: /tmp/priva-f03-baseline.log y /tmp/priva-f03-docker-analysis.log.
Sin actualizar dependencias, proveedor, SDK seleccionado ni mínimo Android.
