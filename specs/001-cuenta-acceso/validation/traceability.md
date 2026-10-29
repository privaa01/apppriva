# Trazabilidad F01 — registro parcial, T043 pendiente

| Requisito | Tareas / pruebas | Resultado y límites |
| --- | --- | --- |
| RF-01 / CA-01.1/01.2/01.5/01.6/01.8/01.11 | T014/T016/T018–T026/T031 | Widgets/SDK/servicio local satisfactorios; documento real y móvil pendientes. |
| RF-02 / CA-01.3/01.4/01.7/01.9/01.12/01.13 | T015/T022/T023/T027/T028/T032 | Recuperación y acceso reales locales satisfactorios; teclado/dispositivos y hospedado pendientes. |
| RF-03 / CA-01.8/01.10/01.11 | T010/T015/T027/T031/T034 | Errores uniformes, red y reintento satisfactorios localmente. |
| RF-05 / CA-ACC-01–05 | T017/T029/T030/T033/T034 | Frontera pública/privada y pérdida de sesión probadas; contenido de otros módulos no implementado. |
| RF-17 / SC-004 | T015/T023/T031/T034 | Caída de red/respuesta perdida sin duplicación; SDK real contra fixture. |
| RNF-01–06 | T005/T016/T037/T038/T040/T041 | Automatización parcial satisfactoria; lectores/móviles/piloto no ejecutados. |
| RNF-07/08 | T006/T007/T011/T012/T020/T021/T036/T039/T042 | Código/local revisados; proveedor y conservación reales sin verificar. |
| RNF-09 | T045 | Veinte registros locales y timeout tardío satisfactorios; resto de matriz/perfiles pendiente. |
| SC-001 | T040/T041 | Protocolo preparado; cero participantes/resultados. |
| SC-002–SC-004 | T031–T034 | Sin acceso/duplicados indebidos en escenarios locales; no certifica entrega final. |
| SC-005 | T035/T043/T044 | Evidencia local consolidada, aceptación final pendiente. |

T043 depende de T045 completa; este registro anticipa estados para no perder evidencia,
pero no marca la tarea final como cumplida. Pasado no equivale a omitido/no ejecutado.

## Cobertura Firebase de esta revisión

| Criterios | Pruebas y evidencia | Estado |
| --- | --- | --- |
| CA-01.1/01.2/01.5/01.6 | firebase_account_test: alta, política/aceptación, perfil/evidencia, compensación y duplicados | Local satisfactorio; seguridad hospedada pendiente |
| CA-01.9/01.12/01.13 revisados a enlace | Solicitud SDK, cuenta inexistente, errores y UI de enlace | Local satisfactorio + recuperación confirmada por usuario; enlace vencido/usado pendiente |
| CA-01.7 / RNF accesibilidad | Cuatro pantallas Firebase y dos recorridos texto200%/teclado | Automatizado satisfactorio; TalkBack/dispositivo pendiente |
| CA-01.11 / CA-ACC | Correo no verificado, falta de evidencia, fallo de lectura, revocación y rutas | Local satisfactorio; HTTP/reglas pendientes |
| T020/T021/T033/T039 | firebase/tests/firestore.test.mjs, siete escenarios | No ejecutados: descarga del emulador bloqueada |

Ver verification-review.md para resultados, defecto corregido y límites. T043 no
se cierra mientras T045 y dependencias sigan pendientes.
