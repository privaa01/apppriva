# F01 — Propuesta concreta para completar Firebase

Estado: propuesta pendiente de aprobación; no desplegada. Fecha: 2026-10-29 UTC.
Alcance: Android, proyecto priva-785cb, aplicación com.priva.

## Problema y decisión necesaria

El cliente Firebase implementado rechaza el registro y la recuperación heredando
UnavailableAccountRepository. Esto es una carencia funcional, no una tarea externa
ya completada. Habilitar Email/Password en Firebase Console no la resuelve.

El spec aprobado exige código por correo. El diseño Supabase U1 exigía una única
transacción de alta, perfil y evidencia. Firebase Auth y Firestore no deben suponerse
participantes de una transacción común. No basta añadir createUserWithEmailAndPassword
al cliente: se perdería esa garantía y la evidencia de autorización.

Se propone un servidor de cuenta en Cloud Functions, Firebase Admin para identidad,
Firestore para política/perfil/evidencia y desafíos, y un remitente transaccional
aprobado. No se elige región, proveedor de correo, modalidad comercial ni plazos
jurídicos por inferencia. No desplegar ni habilitar facturación sin autorización.

## Diseño para revisión

1. Publicar una política versionada aprobada en servidor. El cliente solo lee la
   activa; ninguna política ficticia permite usuarios reales.
2. Alta mediante endpoint con nombre, correo, contraseña y aceptación/versionado.
   Validar antes de crear identidad. Nunca registrar cuerpos, contraseña o código.
3. Crear identidad Auth inicialmente deshabilitada. Guardar perfil mínimo y evidencia
   inmutable con UID/fecha del servidor en una transacción Firestore. Una cuenta sin
   evidencia nunca puede autenticarse. No delegar esa escritura al cliente.
4. Ante fallo, compensar eliminando la identidad deshabilitada y registrar únicamente
   un estado operacional sanitizado. Añadir reconciliación y prueba de compensación
   fallida. Esta estrategia NO equivale a rollback atómico Auth+Firestore: modifica
   U1 y requiere aprobación expresa antes de implementar la operación afectada.
5. Generar código criptográficamente aleatorio de seis dígitos y almacenar solo HMAC
   con secreto servidor y propósito/UID/desafío/caducidad. Caducidad 600 s y reenvío
   mínimo 60 s, impuestos en servidor. Probar consumo único, concurrencia, expiración,
   propósito incorrecto, reintento y límites; no prometer bloqueo exacto de cinco.
6. Enviar por remitente autorizado. La entrega aceptada por SMTP no demuestra llegada
   al buzón. Pruebas locales con correo sintético; validación hospedada separada.
7. Confirmación válida: verificar email en Auth y habilitar identidad solo cuando la
   evidencia exista. Emitir claim priva_account_ready exclusivamente desde servidor;
   ante fallos mantener denegación y permitir reintento seguro. Pedir acceso normal
   con contraseña; confirmar no inicia sesión automáticamente.
8. Recuperación: respuestas públicas uniformes, solicitud sin crear usuarios, código
   separado de confirmación y desafío de recuperación restringido. Tras validarlo,
   emitir autorización temporal de un solo uso para cambiar contraseña, ligada a
   UID/propósito. No emitir sesión Firebase de acceso completo por validar código.
9. Cambio de contraseña: comprobar autorización temporal y mínimo de 12, actualizar
   Auth, revocar renovaciones de sesión y consumir autorización. Resolver reintentos
   sin volver a conceder acceso. Regresar al inicio de sesión. No enviar nueva clave
   por correo ni persistirla en Firestore, logs, colas o artefactos de pruebas.
10. Reglas: visitante solo política pública activa; perfil propio con token de método
    password, correo verificado y claim servidor. Evidencia y desafíos sin escrituras
    cliente y sin lectura de desafíos. Las reglas no sustituyen validación de cada
    endpoint Admin. Denegar colecciones no previstas, incluidos datos del cuestionario.

El rate limit debe existir también en servidor y revisarse frente a enumeración,
reenvíos, IP/identidad y abuso de códigos. App Check, si se adopta, es una protección
adicional; no reemplaza autenticación, autorización ni límites de servidor.
El mecanismo y cuotas concretos se deben justificar en la revisión técnica, sin
reintroducir un máximo exacto de cinco ni inventar garantías de proveedor.

## Contratos candidatos

- GET política activa: documento versionado; sin nombres o correos de usuarios.
- POST alta: declaración explícita; resultado público uniforme, sin consulta de
  existencia; idempotencia de evidencia y reconciliación de resultado desconocido.
- POST confirmación/solicitud y confirmación/validación: separados de recuperación.
- POST recuperación/solicitud y recuperación/validación: no crean identidades.
- POST recuperación/cambio: autorización temporal, nueva contraseña, sin sesión normal.
- Acceso/cierre: SDK Firebase Auth, con validación de claims y revocación real.

No se implementan endpoints contra una URL inventada ni se emiten claims manuales
para simular que el registro está terminado. Pins, región y remitente se concretarán
antes de desplegar; secretos mediante mecanismo seguro del proveedor, nunca en chat.

## Trabajo y evidencia para cerrar 001

| Trabajo | Evidencia exigida | Estado actual |
| --- | --- | --- |
| Registro, política, evidencia y códigos | Pruebas de transacciones/compensación, HTTP y correo sintético | No implementado en Firebase |
| Cliente Android | Integración con servidor y errores uniformes, sin persistir secretos | Configurado; adaptador parcial |
| T037 | TalkBack, foco, contraste, teclado y texto200% en Android | Automatización parcial; nativo pendiente |
| T038 | Análisis, tests y APK Android con SDK/lockfile | Análisis/tests locales previos; build bloqueado |
| T039 | Proyecto Firebase real, correo y permisos/direct HTTP | Configuración Android recibida; sin acceso Admin ni conectividad API |
| T041 | Piloto autorizado de diez participantes 40–65 | No ejecutado; no puede simularse |
| T042 | Política, responsable, región, acuerdos, conservación y borrado | Documentación/revisión competente pendiente |
| T045 | Veinte mediciones por operación/perfil/dispositivo Android | Solo subconjunto histórico local |
| T043/T044 | Trazabilidad final y aceptación después de resolver dependencias | Bloqueadas por los puntos anteriores |

No se trasladan las 37 marcas históricas Supabase a una afirmación de avance Firebase.
No se avanza al spec002 ni se marca completa ninguna validación no ejecutada.

## Comprobación de acceso en esta continuación

Se intentó consultar configuración pública de identitytoolkit.googleapis.com con
la configuración local, sin mostrar valores. La conexión falló antes de recibir
respuesta de Firebase. No se ha demostrado configuración efectiva del proveedor,
cuotas, reglas, envíos o creación de usuarios. No hay credencial administrativa
válida disponible ni un canal conectado para controlar Firebase Console.
