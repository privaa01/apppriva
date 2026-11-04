# Trazabilidad F03 — parcial, T034 pendiente

Todas las referencias siguientes describen cobertura local o preparación; la
aceptación de entrega no está concedida. tasks.md mantiene abiertos los controles
sin ejecución nativa, métricas o participantes. Archivo de tests base:
mobile/test/features/navigation/ (y regresión account_state_test.dart para UID).

| Requisito / CA | Tareas | Prueba / evidencia actual | Falta |
| --- | --- | --- | --- |
| RF-05.a / CA-03.1/03.4 | T010,T020–T022,T024 | navigation_screen_test, tarjetas educativas/menú | Matriz nativa |
| RF-05.b / CA-03.5/03.6, CA-ACC-01–05 | T007/T012,T014/T015/T017/T020 | destination_catalog_test, navigation_screen_test, UID y diálogo | Android y cuentas sintéticas reales cuando corresponda |
| RF-05.c / CA-03.2/03.3/03.9 | T008/T011,T016/T017/T020/T023 | navigation_controller_test, navigation_profile_test, desconocido/resultado | Retroceso/raíz en Android |
| RF-05.d / CA-03.7/03.8 | T009/T013,T018/T019/T025 | temporary_journey_navigation_test, navigation_lifecycle_test | Ciclo Android; futura integración F06/F07 |
| RF-05.e/f / CA-03.10 | T024,T030 | navigation_accessibility_test,4 geometrías/escalas widget | TalkBack/foco nativo |
| RF-05.g / CA-03.6/03.8 | T003–T006,T015/T017–T019 | Revisión de código y contratos sintéticos | Inspección nativa/tráfico |
| SC-03.1 | T026/T028 | Matriz de destino/estado antes del builder | Completar nativo |
| SC-03.2 | T026/T028 |20 reselecciones, A→B→A, detalle→catálogo | Salida Android real |
| SC-03.3 | T026/T028/T033 | Cancelar/confirmar, resultado, generación y ciclo sintéticos | Nativo y futuro adaptador real |
| SC-03.4 | T030 | Etiquetas,48dp, contraste, texto100%/200% | TalkBack y matriz API |
| SC-03.5 | T032 | Protocolo aprobado, sin ejecución |5 participantes,30 oportunidades |
| Presupuestos de respuesta/RNF-09 | T029/T031 | Runner monotónico preparado | Muestras Android y máximos |

La suite F01/F02 se ejecuta de nuevo, conservando sus tests y políticas. No transferir
una excepción/aceptación de esos specs a los controles faltantes de F03. La
consolidación final y current-results.json deben actualizarse con resultados reales
tras resolver los pendientes, antes de solicitar aceptación o avanzar a F04.

## Cierre posterior — 2026-11-04

El usuario confirmó conservación de sesión y aprobó cerrar F03. Ver
[aceptación y limitaciones](closure-2026-11-04.md):29 tareas completadas,6 parciales/
aplazadas. Los pendientes anteriores describen el estado histórico; no se convierten
en resultados satisfactorios. Se preservan los límites de la evidencia ejecutada.
