# F04 — Matriz de trazabilidad de ejecución

Fecha2026-11-05. Plan aprobado; fuentes verificadas. Identificadores de escenarios
estables; rutas de pruebas son objetivos previstos, no archivos ejecutados todavía.
Se actualizarán resultados al ejecutar, sin atribuir tests históricos a F04.

| RF / historia | CA / SC | Contrato | Tareas | Escenario / prueba prevista | Resultado |
| --- | --- | --- | --- | --- | --- |
| RF-06.a / HU-04 | CA-04.1; SC-04.1 | C-TIPS-01/05 | T007/T010/T013/T017/T020 | F04-CATALOG:4 entradas y orden; tips_screen_test | Local satisfactorio; nativo/remoto si corresponde pendiente |
| RF-06.b / HU-04 | CA-04.2; SC-04.2 | C-TIPS-01/05 | T007/T013/T018/T019/T023 | F04-CONTENT:4 detalles y expansión; tip_content_test/tips_screen_test | Local satisfactorio; nativo/remoto si corresponde pendiente |
| RF-06.c / HU-04 | CA-04.4/5; CA-ACC-01–05; SC-04.1 | C-TIPS-02/04 | T008/T010/T015/T020/T021/T024/T027 | F04-ACCESS:3 estados de cuenta×5 rutas, retorno directo y privados; tips_screen_test/tips_test | Local satisfactorio; nativo/remoto si corresponde pendiente |
| RF-06.d / HU-04 | CA-04.3/6; SC-04.3 | C-TIPS-01/03 | T008/T009/T014/T015/T016/T021 | F04-RECOVERY:error/timeout/ausente/inválido/reintento/respuesta tardía; repositorio/controlador | Local satisfactorio; nativo/remoto si corresponde pendiente |
| RF-06.e / HU-04 | CA-04.7–10; SC-04.2 | C-TIPS-01/05 | T001/T004/T007/T013/T023 | F04-EDITORIAL:fuentes+texto aprobado+payload exacto | Fuentes/payload/pruebas locales satisfactorias; publicación pendiente |
| RF-06.f / HU-04 | CA-04.11; SC-04.4 | C-TIPS-06 | T012/T017/T018/T019/T028/T029 | F04-A11Y:200%,48dp,contraste,labels y TalkBack | Local satisfactorio; nativo/remoto si corresponde pendiente |
| RF-06.g / HU-04 | CA-04.9/12 | C-TIPS-02/05 | T010/T011/T019/T022/T032 | F04-PRIVACY:sin inputs/acciones externas/escrituras/historial | Local satisfactorio; nativo/remoto si corresponde pendiente |
| RF-06.c/g / HU-04 | CA-ACC-01–05 | C-TIPS-02 | T011/T022/T026/T034/T035 | F04-RULES:get público4 IDs/list/escritura denegados y regresión | Local satisfactorio; nativo/remoto si corresponde pendiente |
| RF-06.f / HU-04 | SC-04.1–4 | C-TIPS-03/06 | T027/T028/T029/T030 | F04-NATIVE:API24/API36;20 tiempos por operación/configuración | APK compilado; mediciones/matriz pendientes |
| RF-06.b/e/f / HU-04 | SC-04.5 | C-TIPS-06 | T031 | F04-COMPREHENSION:6 comprobaciones,≥4/5 participantes | Pendiente; sin participantes |
| Todos / HU-04 | CA/SC completos | C-TIPS-01–06 | T005/T025–T036 | F04-DELIVERY:baseline,regresión,publicación autorizada y aceptación | Local satisfactorio; nativo/remoto si corresponde pendiente |

Escenarios F04-CONTENT incluyen exactamente A1–A5 y «Ver ejemplo»; una prueba
semántica no acredita TalkBack y un doble no acredita configuración hospedada.
T001 resuelta no completa T023 ni SC-04.2 por sí sola. Resultados de cuenta/perfil
anteriores solo son baseline; deben repetirse como regresión al integrar F04.

Resultados actuales: Flutter182 y reglas/preflight24 satisfactorios, análisis0 y
APK debug compilado. Referencias en flutter-results.md, firestore-results.md,
android-matrix.md, accessibility.md y delivery-review.md. Tráfico/logs, TalkBack,
matriz nativa, mediciones, participantes y producción permanecen pendientes.
