# Revisión de privacidad T036 — código y entorno sintético

**Resultado:** revisión realizada; no certifica configuración hospedada ni almacenamiento físico.

| Control inspeccionado | Resultado | Evidencia / límite |
| --- | --- | --- |
| Datos de registro | Nombre, correo y contraseña; aceptación/versión de política | Metadata no concede permisos; teléfono ausente. |
| Evidencia de autorización | Trigger atómico, fecha/ID servidor, inmutabilidad y rollback | SQL/HTTP e integración Dart contra servicio local. |
| Sesión local | Adaptador flutter_secure_storage; eliminada copia adicional de correo/nombre/metadata arbitraria y credenciales del proveedor | Persisten tokens y campos mínimos que SDK requiere para reconstruir identidad; JWT firmado no se altera. Test de serialización/recuperación y borrado pasó con plugin simulado. |
| Contraseñas/códigos | Solo estado temporal de formularios, limpieza tras envío/dispose | No se añaden a persistSession; no aparecen en eventos propios de la app. |
| Analítica/logs/crash reports | Sin SDK de analítica/crash de producto ni print/debugPrint en lib; Supabase debug=false | Servicios hospedados podrían tener sus propios registros: requieren revisión T039/T042. |
| Respaldos Android | allowBackup=false | Pendiente comprobar comportamiento en dispositivo; no garantiza borrado de nube. |
| Datos de cuestionario/chat | No existen tablas ni operaciones F01 para ellos | No se deduce validación de módulos aún no implementados. |
| Credenciales de servicios | Ejemplo vacío, configuración local ignorada, claves privilegiadas solo en fixture efímero | No hay service key/SMTP de usuarios en la app o repositorio. |

El SDK persiste además del token metadatos mínimos de identidad necesarios para
recuperar sesión (id,aud,created_at,email_confirmed_at). Se eliminan los demás campos
al escribir el contenedor protegido; esto no minimiza ni modifica el contenido firmado
del JWT que debe permanecer íntegro. No se usa esta identidad local como sustituto de RLS.

No se leyó almacenamiento físico de Keychain/Keystore ni registros/backups de un
proyecto alojado. Esas comprobaciones y la matriz de conservación siguen abiertas
antes de datos reales. T036 registra una revisión del código, no una aceptación jurídica.

## Revisión del modelo Firebase

Se inspeccionó FirestoreRegistrationStore: evidencia con UID, versión, finalidades,
acción, aceptación y timestamp servidor; perfil con nombre. No replica contraseña,
correo, IP, teléfono o respuestas. Reglas inmutables preparadas y revisadas, sin
prueba de ejecución por bloqueo del emulador. Se prueban denegación de acceso cuando
falta evidencia o falla lectura y consentimiento previo en el cliente. Ver
verification-review.md. Conservación, eliminación y sesión nativa requieren pruebas
y revisión del servicio real; la revisión histórica Supabase no acredita esos puntos.
