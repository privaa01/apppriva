# Investigación de diseño — F02

Fecha: 2026-10-29. Diseño propuesto, no implementación ni prueba del servicio.
Se realizó revisión de código y fuentes de paquetes en paralelo según speckit-plan.
No quedan preguntas funcionales/tecnológicas para decidir el diseño; las pruebas de
entrega dependientes de entorno se conservan como pendientes, no como resultados.

## R1 — Consulta real e integración con F01

**Decisión:** módulo de perfil pequeño detrás de `/profile`, derivar correo de
FirebaseAuth.currentUser y nombre desde servidor. Repositorio propio sin romper
AccountRepository/F01 ni volver a llamar al alta.
**Motivo:** el router actual devuelve placeholder y AccountSession no contiene correo;
el nombre de sesión se carga solo al iniciar y puede quedar desactualizado.
**Alternativas:** usar el correo del formulario (no confiable como estado actual),
copiar email a Firestore (duplicación innecesaria) o ampliar todos los flujos F01.
**Evidencia:** `mobile/lib/app/account_router.dart`,
`features/account/application/account_state.dart`,
`features/account/data/firebase_registration_store.dart`.

## R2 — Edición y autorización

**Decisión:** transacción del perfil existente, actualización exclusiva de nombre;
validación en controlador/adaptador y reglas. No tocar autorización, correo o Auth.
**Motivo:** las reglas actuales niegan toda actualización. Usar `create` de F01
reescribiría evidencia. La transacción evita tratar una escritura offline como éxito.
**Alternativas:** guardar también displayName en Auth (dos fuentes), batch de alta o
cola local optimista (falsa confirmación/riesgo de cambios diferidos).
**Evidencia:** reglas existentes y fuentes instaladas de cloud_firestore7.1.0:
`lib/src/document_reference.dart`, `lib/src/transaction.dart`.
Las garantías de SDK y reglas se comprobarán en implementación; no se ejecutó emulador.

## R3 — Identidad, cierre y respuestas tardías

**Decisión:** controlador propio con UID/generación y estados confirmados; observar
AccountController para limpieza inmediata, descartar respuestas de otra identidad.
**Motivo:** AccountController ya protege operaciones F01 con generaciones; no debe
confundirse su fase de credenciales con edición de nombre. Firebase repo puede
revocar acceso, pero falta gestión de estado transitorio de perfil.
**Alternativas:** confiar solo en la guarda de navegación o hacer actualización de
nombre optimista sin asociarla a UID.
**Evidencia:** AccountController.initialize/signOut, FirebaseAccountRepository.sessionChanges,
fuente instalada FirebaseAuth7.0.1 signOut/idTokenChanges. SignOut no prueba cierre global.

## R4 — Redactor y fallback

**Decisión:** proponer url_launcher6.3.3; lanzamiento mailto directo con externalApplication,
manejo de false/excepción y Clipboard incorporado para dirección pública.
**Motivo:** realiza apertura explícita, sin envío automático ni permisos adicionales
para gestionar mensajes. canLaunchUrl puede producir falsos negativos y no debe
ocultar una opción que tiene fallback.
**Alternativas:** servidor de correo, plugin de envío o canLaunchUrl como gate; añaden
capacidad/complejidad no autorizadas o fallos evitables.
**Compatibilidad verificada por metadatos/fuente:** url_launcher6.3.3 requiere
Dart^3.11/Flutter≥3.41; Android transitivo6.3.33 requiere Dart^3.12/Flutter≥3.44 y
minSdk24. Baseline3.13.7/3.47.8 compatible por metadatos; builds reales pendientes.
**Fuentes consultadas:**
- https://pub.dev/api/packages/url_launcher
- https://pub.dev/api/archives/url_launcher-6.3.3.tar.gz (README y fuente URI)
- https://pub.dev/api/packages/url_launcher_android
- https://pub.dev/api/archives/url_launcher_android-6.3.33.tar.gz (Gradle y Android)

El README indica intentar launchUrl con fallback si corresponde y escapar asunto/
cuerpo para esquemas noHTTP con Uri.encodeComponent, no queryParameters que puede
convertir espacios en `+`. No se instalaron dependencias ni se abrió correo.

## R5 — No ampliar eliminación ni preferencias

**Decisión:** informar/preparar solicitud al correo aprobado; no almacenar expediente,
procesar borrado automático, decidir retenciones ni crear preferencia de texto F08.
**Motivo:** el spec confirma canal, responsable, aislamiento y texto del sistema;
no aprueba nuevas operaciones de eliminación o datos.
**Alternativas:** deleteUser de Auth, colección de solicitudes o campo teléfono; fuera
 del alcance y sin procedimiento operativo/jurídico aprobado.
**Evidencia:** decisiones del usuario, spec002 aprobado y política del001.

## Puertas posteriores

Nueva escritura de nombre necesita pruebas de reglas y publicación del cambio; la
postergación de reglas del001 no equivale a aprobación automática de este cambio.
Firestore real, lector, correo nativo y matriz requieren acceso/dispositivo; el bloqueo
conocido de descargas del runner no se resuelve modificando certificados o saltando
pruebas. No hay aprobación del plan, tareas o implementación en esta investigación.
