# Baseline F05 — intento previo a implementación

**Fecha:** 2026-11-05. **Resultado vigente:** satisfactorio tras reanudar toolchain.

No se modificó código de producto ni se atribuyeron resultados históricos a esta
ejecución. El baseline vigente documentado por F04 era 180 pruebas Flutter, pero
debe repetirse para T006.

## Comprobaciones ejecutadas

| Comprobación | Resultado |
| --- | --- |
| `flutter analyze --fatal-infos` | Omitida: `flutter` no está disponible en `PATH` y no existe SDK Flutter bajo `/workspace`. |
| `flutter test --no-pub` | Omitida por la misma ausencia; no se confirma el recuento de 180 pruebas. |
| Reglas Firebase con `npm test` | Falló antes de ejecutar pruebas: `firebase: not found`; no existe `node_modules` instalado. |
| `npm ci --offline` en `firebase/` | Falló con `ENOTCACHED`: falta `zod-to-json-schema-3.25.2.tgz` en caché. |
| Build APK Android | Omitido: no hay Flutter/SDK Android disponible en este entorno. |

El proxy del entorno tampoco aceptaba conexiones en ese intento. Esos eran fallos
de preparación, no fallos del producto.

## Reejecución satisfactoria — 2026-11-05

- Flutter:180/180 pruebas satisfactorias,0 fallidas.
- Analizador oficial:0 diagnósticos.
- Firestore Emulator:17/17 pruebas satisfactorias; los PERMISSION_DENIED impresos
  corresponden a escenarios negativos esperados.
- Android: `flutter build apk --debug --no-pub` satisfactorio en37.4s.
- Advertencias no bloqueantes: migración futura de KGP y diferencia de versión XML
  del SDK; no se ocultaron ni atribuyeron a F05.

T006 queda completa. Este baseline no prueba aún P07 ni una llamada a Vertex.
