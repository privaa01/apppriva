# Trazabilidad F02 — parcial

Actualización 2026-10-30: evidencia de reporte manual del usuario (perfil,
edición/cancelación, contacto de eliminación, cierre de sesión y accesibilidad) en
[user-reported-manual.md](user-reported-manual.md). No equivale a observación
independiente ni satisface por sí sola matrices Android sin datos de dispositivo.
Reglas, análisis estático y build se reintentaron en este entorno y quedaron
bloqueados; las confirmaciones posteriores del usuario se registran por separado.

Actualización posterior del usuario (2026-10-30): T027 (emulador), T028 (escenarios
de reglas), T031 (mediciones), T032 (privacidad) y, en otra confirmación, T030
(formato/análisis/pruebas/build) se reportan realizados. No se adjuntaron resultados
detallados de esas confirmaciones. Los intentos bloqueados previos se mantienen
como historial de esta sesión, no como evidencia de que las validaciones posteriores
reportadas fallaran. T029 sigue pendiente.

| Criterios | Evidencia local | Estado/pending |
| --- | --- | --- |
| CA-02.1/02.4/02.5/02.8/02.9 | profile_repository_test y profile_screen_test: datos propios, guardas, errores | Backend/matriz reales |
| CA-02.6/02.7 | profile_controller_test y screen: guardar/cancelar/error/doble/tardío; T028 escenarios reportados por usuario | Nativos/contacto (T029) |
| CA-02.2/02.10–02.12 | controller/screen: cierre, historial y rutas, sesión/identidad | Nativos/red real |
| CA-02.3/02.13–02.17 | deletion_contact_service_test y screen: URI/copia/fallback/sin envío | Mailto y cancelación nativos |
| CA-02.18/02.19 | profile_accessibility_test; T027 validación en emulador reportada por usuario | T029 evidencia restante |
| SC-02.1–02.5 | Suite local previa; T030 build/análisis reportados; T031 mediciones y T032 privacidad reportadas | T029 y consolidación final |

T033 sigue abierta mientras T029 esté pendiente y la matriz de trazabilidad
no se haya consolidado contra todos los resultados. El reporte del usuario de T031
se reconoce, aunque no adjunta valores sanitizados reproducibles. Los intentos y
bloqueos de esta sesión constan en `current-results.json` y `builds.md`/`firestore.md`.
No se trasladan reportes del001 a una aceptación del002.
