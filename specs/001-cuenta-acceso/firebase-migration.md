# F01 — Cambio de Supabase a Firebase

Fecha: 2026-10-27 (America/Bogota). Rama: `work`.

**Decisión confirmada:** el usuario indicó «vamos a configurarlo con firebase».
Autoriza cambiar el proveedor; no implica aceptar cambios de comportamiento,
costos, términos comerciales o una nueva entrega. Se conserva Flutter para Android/iOS.

**Estado:** análisis de impacto; Firebase todavía no configurado ni validado.
No hay ID de proyecto confirmado ni sesión administrativa verificada disponible.
Se solicitó el ID público, sin claves privadas ni cuentas de servicio por chat.

## Requisitos que se conservan

- RF-01/02/03 y CA-01: nombre, correo y contraseña, sin teléfono/SMS; finalidades
  y autorización conforme al spec y política revisada.
- Verificar correo antes del acceso completo; Tips público. Las reglas del servicio
  deben impedir acceso directo, además de las guardas del cliente.
- CA-01.9/01.12/01.13: recuperación mediante código enviado al correo, sin crear
  usuarios ni conceder acceso automático al recuperar.
- Contraseña mínima de 12, caducidad de código de 600 segundos y reenvío no antes
  de 60 segundos: requisitos que deben contrastarse en el nuevo proveedor.
  La elección previa de límites nativos no aprueba automáticamente cuotas diferentes.
- Mensajes sin enumeración, errores sanitizados y ausencia de secretos en logs/app.
- Cero persistencia del cuestionario; no instalar Analytics/Crashlytics por defecto.
- Conservación, eliminación, región y acuerdos requieren revisión competente.
  Los mínimos móviles y criterios de calidad no se modifican por inferencia.

## Conflictos y resolución propuesta

| Área | Diferencia que debe resolverse | Propuesta y evidencia necesaria |
| --- | --- | --- |
| Recuperación por código | El flujo habitual Firebase Auth `sendPasswordResetEmail` envía una acción por enlace. El `oobCode` del enlace no demuestra un flujo de código ingresado en la app equivalente al aprobado. | Conservar el código por correo. Investigar soporte oficial o un servicio adicional mínimo, sus costos y controles. No reemplazar por enlace sin decisión explícita del usuario. |
| Confirmación de correo | El plan Supabase utiliza código; Firebase ofrece `sendEmailVerification` mediante enlace. | Revisar mecanismo, retorno a la app y compatibilidad antes de elegir. El spec exige verificación, sin fijar por sí mismo el mecanismo de alta. |
| Alta y autorización atómicas | El trigger actual escribe Auth, perfil y evidencia en la misma transacción Postgres. No se puede trasladar esa garantía a Auth + Firestore suponiendo una transacción común. | Evaluar flujo de aprovisionamiento bloqueado hasta evidencia válida y recuperación de fallos. Eso modifica el diseño ratificado U1: requiere revisión explícita, no solo cambiar bibliotecas. |
| Permisos | `amr=password`, RLS y SQL son específicos del diseño anterior. | Diseñar reglas Firebase y validación servidor de identidad verificada/sesión permitida; probar tokens y acceso directo en emulador y servicio real. No copiar condiciones SQL ni confiar en un booleano cliente. |
| Sesiones y secretos | El almacenamiento personalizado del SDK anterior no configura Firebase Auth. | Revisar persistencia nativa, revocación, tokens, cierre y recuperación; demostrar restricciones de acceso y protección en Android/iOS. |
| Perfil y política | Firestore sería un almacén nuevo; no queda elegido por mencionar Firebase. | Proponer entidades mínimas, región, reglas de lectura/escritura y evidencia inmutable. Decidir tras revisar transacciones y minimización. |
| Límites y correo | No están verificadas equivalencias de 600 s/60 s, anti-enumeración ni configuración del remitente. | Contrastar capacidades/configuración reales, probar destinatarios sintéticos y registrar cualquier incompatibilidad antes de aprobar diseño. |

Las diferencias anteriores son un análisis preliminar. La consulta de documentación
oficial intentada en este entorno recibió `Tunnel connection failed: 403 Forbidden`;
no se presenta como investigación documental concluida ni validación del proveedor.

## Artefactos afectados y secuencia SDD

1. Identificar proyecto Firebase de pruebas y acceso seguro. No crear recursos
   facturables, aceptar contratos o usar datos reales por inferencia.
2. Completar investigación oficial y pruebas de viabilidad de recuperación,
   alta/evidencia, permisos, compatibilidad y límites. Herramientas locales no
   requieren una clave administrativa embebida en la aplicación.
3. Revisar `plan.md`, `research.md`, `data-model.md`, `contracts/cuenta-acceso.md`
   y `quickstart.md`; distinguir decisiones confirmadas de propuestas. Cualquier
   cambio funcional requiere además revisar los CA de `spec.md`.
4. Presentar el diseño completo para aprobación de la etapa; después actualizar
   tareas conservando IDs y trazabilidad, analizar e implementar el adaptador,
   configuración móvil y controles del servicio.
5. Repetir validación del proveedor, integración y revisión de privacidad. Las
   pruebas independientes del proveedor pueden conservarse si siguen aplicando;
   los resultados de Supabase nunca acreditan Firebase.

Áreas de código afectadas: `mobile/lib/main.dart`, `mobile/lib/app/app_config.dart`,
`mobile/lib/features/account/data/`, composición de sesión, dependencias y lockfile,
configuración nativa Android/iOS, pruebas del adaptador y herramientas de integración.
Conservar UI/wireframes y reglas de negocio salvo cambio aprobado. No borrar todavía
`supabase/`: mantiene evidencia reproducible del estado anterior, no un segundo backend
activo. No migrar cuentas ni datos sin inventario y procedimiento explícitos.

## Puertas de cierre

- Este cambio no completa las ocho tareas pendientes de la implementación anterior.
- Las 37 tareas y sus resultados representan evidencia de la versión Supabase;
  no son un porcentaje de implementación Firebase.
- Builds Android/iOS, accesibilidad nativa, piloto, política revisada y aceptación
  siguen pendientes. No avanzar al spec 002.
- Commit y sincronización registran el borrador; no sustituyen aprobación del diseño.

## Referencias oficiales por contrastar

- https://firebase.google.com/docs/flutter/setup
- https://firebase.google.com/docs/auth/flutter/password-auth
- https://firebase.google.com/docs/auth/flutter/manage-users
- https://firebase.google.com/docs/auth/admin/email-action-links
- https://firebase.google.com/docs/auth/extend-with-blocking-functions
- https://firebase.google.com/docs/firestore/manage-data/transactions
- https://firebase.google.com/docs/rules/unit-tests

No se han emitido correos, creado proyectos Firebase, habilitado facturación,
desplegado reglas ni cambiado la autenticación ejecutable durante este análisis.

## Recuperación por enlace — cambio aprobado

El usuario aprobó sustituir el código de recuperación por enlace por correo,
utilizando directamente firebase_auth; rechazó Cloud Functions/Firestore. Usar
sendPasswordResetEmail: cambiar contraseña en el formulario alojado de Firebase
y volver a iniciar sesión en Priva. Solicitar enlace no crea usuarios ni concede
acceso. No ingresar código ni nueva contraseña en la app. Enlaces inválidos,
vencidos o usados deben rechazarse en Firebase y permiten solicitar otro en Priva.
Esto sustituye el requisito de código de CA-01.9/01.12/01.13 y sus contratos.
No cambia confirmación de alta, autorización de datos ni evidencia de consentimiento.
La caducidad de 600 segundos anterior NO se atribuye al enlace: comprobar política
y caducidad reales en Firebase. Reenvío cliente mínimo 60 s, sin afirmar límite
de servidor probado. Validación de correo/servicio real sigue pendiente.
