# Reglas Firestore F02

Cambio preparado: update profiles propio, password+email verificado, evidencia válida,
affectedKeys exclusivo name y nombre no vacío/solo espacios (incluye separadores
Unicode/BOM). Reglas de alta F01 y evidencia inmutable se mantienen. No se permiten
borrado, email, teléfono/UID/campos adicionales ni cuestionario.

Seis escenarios nuevos de reglas preparados; junto con los siete existentes se
ejecutan secuencialmente para evitar que un archivo limpie datos de otro.
`npm test` intentado: falla descargando el JAR oficial cloud-firestore-emulator-v1.22.0.jar.
Los13 escenarios no se ejecutaron: no afirmar reglas validadas. Sintaxis JavaScript
del test revisada con node --check, sin sustituir al compilador de reglas.

Reintento de validación 2026-10-30: `npm ci` instaló las dependencias fijadas. `npm test`
intentó iniciar Firestore Emulator y falló antes de los escenarios porque el entorno
denegó el bind de puertos locales (EPERM). Un reintento con ejecución elevada no
encontró el CLI `firebase`. `node --check tests/profile.test.mjs` y
`node --check tests/firestore.test.mjs` pasan; solo comprueban sintaxis JavaScript,
no compilan ni validan reglas.

Los 13 escenarios no se ejecutaron. No se hicieron solicitudes directas ni comparación
de autorización antes/después. Sin cambios desplegados por el asistente. Se requiere
validación de las nuevas reglas antes de cualquier publicación; la configuración
pública Android no concede acceso administrativo. La prueba de evidencia idéntica
sigue preparada, no ejecutada.

## Reporte posterior del usuario — 2026-10-30

El usuario confirmó que T028 (validación de escenarios) ya se realizó. Este reporte
posterior actualiza el estado de ejecución anterior; los intentos locales fallidos
se conservan como historial fiel de ese entorno. No se afirma que el asistente haya
ejecutado esas pruebas ni que se hayan desplegado reglas. No se recibieron resultados
por escenario ni evidencia de comparación antes/después, por lo que se registra
la confirmación como reporte del usuario, no como salida reproducible adjunta.
