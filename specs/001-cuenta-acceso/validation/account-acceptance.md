# Aceptación funcional local F01 — evidencia consolidada

**Estado:** consolidación T035 completada; entrega de HU-01 aún no aceptada.
**Plataforma:** Flutter tester Linux x86_64 + Auth/Postgres/PostgREST/Mailpit en Docker.
Los servicios reciben únicamente cuentas sintéticas. Los casos de widgets no son
pruebas en Android/iOS físico. Este documento y sus pruebas pertenecen al mismo
commit de avance; la base previa es 11da584.

## Ejecución actual

- flutter test --no-pub: 42 pruebas satisfactorias, cero fallidas/omitidas.
- python mobile/tool/run_local_integration.py: 9 escenarios satisfactorios y regresión
  SQL de fixture satisfactoria. Correos realmente recibidos en buzón local, sin mocks.
- dart analyze --fatal-infos en contenedor oficial Ubuntu 24.04: sin diagnósticos.
- Las 33 pruebas HTTP/backend previamente versionadas siguen disponibles en
  backend-results.json; no se presentan como una segunda ejecución de esta revisión.

| Criterio | Evidencia ejecutada | Límite |
| --- | --- | --- |
| CA-01.1/01.5 | Pruebas de formularios y validación; datos/formatos, sin teléfono | Falta matriz móvil nativa. |
| CA-01.2/01.11 | Integración registro→código entregado→confirmación→password; acceso no verificado denegado | Falta entorno hospedado. |
| CA-01.3/01.10 | Acceso fallido uniforme, operación sin configuración y fallo de red real controlado | SMTP y mensajes del proveedor final pendientes. |
| CA-01.4/01.9/01.12/01.13 | Recuperación real; error, código válido, reutilización/expiración denegada; contraseña nueva y acceso normal posterior | Tiempos600/60 probados envejeciendo timestamps de DB sintética, no reloj real de diez minutos. |
| CA-01.6 | Política antes de autorización en widgets; trigger valida versión/aceptación y revierte evidencia fallida | Documento/retención reales aún no incorporados. |
| CA-01.7 | Teclado/texto 200 %/acción operable en widget y estructura accesible | Falta teclado nativo/TalkBack/VoiceOver. |
| CA-01.8 | Doble envío unitario, reintento con respuesta perdida real, unicidad cuenta/perfil/evidencia | Entorno hospedado pendiente. |
| CA-ACC-01/05 | Cuatro destinos públicos y menú del wireframe probados en widgets | No se implementa el contenido F04. |
| CA-ACC-02/03 | Rechazo visitante/OTP y sesión normal; aislamiento HTTP RLS versionado | Otros módulos se validan en sus specs. |
| CA-ACC-04 | Pérdida de sesión real retira contenido privado en widgets y deja Tips permitido | Descarte real de cuestionario sigue en F02/F06/F07. |

Todas las pruebas locales anteriores pasaron. Eso no elimina las condiciones de
T037/T038/T039/T041/T042/T045 ni acredita finalización del producto. No se inventaron
resultados, participantes, dispositivos o tiempos de entrega de correo externo.
