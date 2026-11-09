# Validación técnica — F07

**Fecha:** 2026-11-07. **Entorno:** Flutter 3.47.8, Dart 3.13.7, Linux x86_64.

| Control | Resultado |
| --- | --- |
| `flutter analyze --fatal-infos` | 0 diagnósticos |
| `flutter test --no-pub --concurrency=4` | 232/232 satisfactorias en la suite vigente |
| Functions | no existe backend Functions en la rama integrada; F07 no lo usa |
| `firebase/npm test` | 17/17 satisfactorias |
| Dependencias | lockfile conservado, ninguna dependencia nueva |
| APK Android adicional | no generado; limitación aceptada por el responsable |

El intento de ejecutar `integration_test/result_test.dart` y
`result_performance_test.dart` terminó antes de las pruebas con `No supported
devices connected`. Posteriormente, el responsable comunicó validación satisfactoria
en Motorola G22/Android 12 y 20/20 ciclos de rendimiento; no se conservan tiempos
individuales ni se presenta esa ejecución como observada por Codex.
