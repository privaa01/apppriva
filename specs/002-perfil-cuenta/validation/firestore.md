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

Sin cambios desplegados por el asistente. Se requiere validación y publicación
autorizada de las nuevas reglas para editar nombre; las reglas anteriores del001
niegan esa escritura. La configuración pública Android no concede acceso administrativo.
Prueba real de evidencia idéntica antes/después preparada, no ejecutada.
