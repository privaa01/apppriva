# Trazabilidad F02 — parcial

| Criterios | Evidencia local | Estado pendiente |
| --- | --- | --- |
| CA-02.1/02.4/02.5/02.8/02.9 | profile_repository_test y profile_screen_test: datos propios, guardas, errores | Backend/matriz reales |
| CA-02.6/02.7 | profile_controller_test y screen: guardar/cancelar/error/doble/tardío | Reglas/nativos |
| CA-02.2/02.10–02.12 | controller/screen: cierre, historial y rutas, sesión/identidad | Nativos/red real |
| CA-02.3/02.13–02.17 | deletion_contact_service_test y screen: URI/copia/fallback/sin envío | Mailto y cancelación nativos |
| CA-02.18/02.19 | profile_accessibility_test: estados, contraste, targets, texto/teclado | TalkBack y hardware |
| SC-02.1–02.5 | Suite local satisfactoria y revisión de código | No certifica entrega final |

T033 no cerrada: las validaciones nativas/de servicio y rendimiento aún no están
completas. No se convierten pruebas no ejecutadas en satisfechas por ausencia de
entorno. No se trasladan reportes del001 a una aceptación del002.
