# Baseline F05 — intento previo a implementación

**Fecha:** 2026-11-05. **Resultado:** bloqueado por herramientas y red del entorno.

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

El proxy del entorno tampoco acepta conexiones, por lo que no fue posible instalar
las dependencias fijadas. Estos son fallos de preparación del entorno, no fallos de
las pruebas o del producto. T006 permanece pendiente hasta ejecutar análisis, suite
Flutter, reglas y build en un entorno con el toolchain y las dependencias disponibles.
