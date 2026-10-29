# Implementation Plan: F01 — Cuenta y acceso

## Alcance de plataforma vigente — 2026-10-28

Decisión explícita del usuario: «solo preparala para android». Esta entrega se
prepara únicamente para Android (mínimo API24 del plan); iOS, VoiceOver y Xcode
quedan fuera del alcance actual. Las menciones anteriores a ambas plataformas
son históricas. Se mantienen todos los requisitos funcionales, de privacidad y
seguridad aplicables a Android. No implica aprobación de otros specs ni entrega.

**Branch**: `work` | **Date**: 2026-10-27 | **Spec**: [spec.md](spec.md)
**Input**: `/specs/001-cuenta-acceso/spec.md` — aprobado; constitución v1.0.0 ratificada.
**Status**: Approved — base y correcciones del análisis 001 aprobadas explícitamente el 2026-10-27. Evidencia local previa conservada; implementación no iniciada.

## Cambio de proveedor — 2026-10-27

El usuario indicó «vamos a configurarlo con firebase»: queda confirmada la elección
de Firebase en sustitución de Supabase. Flutter y los requisitos de producto se
conservan. El diseño dependiente de Supabase que sigue se mantiene como antecedente
aprobado, no como instrucciones para configurar el nuevo proveedor.

La [revisión de migración](firebase-migration.md) identifica conflictos y validaciones
pendientes. El diseño Firebase aún no está aprobado ni implementado; no continuar
con el despliegue Supabase ni trasladar sus resultados a Firebase. La evidencia de
implementación anterior está en `validation/`; la frase histórica «implementación
no iniciada» del estado base ya no describe el código existente.

## Summary

Implementar registro con nombre, correo y contraseña; verificar correo antes del acceso
protegido; permitir iniciar sesión y recuperar acceso con código al correo. Tips sigue
siendo público y la navegación conserva el wireframe sin saltarse autorización.

Tecnología confirmada por el usuario el 2026-10-26: Flutter/Dart para Android e iOS
y Supabase Auth para identidad,
con confirmación de correo y recuperación por código de un solo uso. Separar vistas,
estado del flujo y acceso al proveedor para probar errores y permisos sin depender
de servicios reales. La elección de Supabase no selecciona un proveedor de IA ni aprueba su
tratamiento de datos por el hecho de proponerse para autenticación.

## Technical Context

| Campo | Propuesta / estado |
| --- | --- |
| Language/Version | Baseline propuesta y verificada por metadatos: Flutter 3.47.8 (commit 737ba8f885dc774b53b442759999a312c9461e4e), Dart 3.13.7 incluido. SDK no instalado; resolución y lockfile en implementación. |
| Primary Dependencies | `supabase_flutter` 2.18.3 y `flutter_secure_storage` 11.2.0 como pins directos propuestos y contrastados; navegación central por estado. Revisar adaptación de Keychain/Keystore y generar lockfile al implementar. |
| Storage | Identidad/credenciales en Supabase Auth. Perfil mínimo y evidencia de autorización en Postgres con aislamiento por usuario; no crear banco de preguntas, chat ni resultados para F01. |
| Testing | `flutter_test`, pruebas de widgets y `integration_test`; proyecto de autenticación de pruebas y buzones sintéticos para aceptación real. No simular envío como prueba de entrega de correo. |
| Target Platform | Mayor cobertura móvil viable: baseline Android 7.0/API24 e iOS15 o posteriores, obtenida de metadatos del SDK y dependencias. Excluye Android API23 e inferiores e iOS14 e inferiores; no es compatibilidad ejecutada ni garantía universal. Matriz propuesta: mínimo y actual, pantalla pequeña/grande, emulador y dispositivo, TalkBack/VoiceOver. |
| Project Type | Aplicación móvil; proveedor gestionado de autenticación y correo transaccional. No servidor propio de contraseñas. |
| Performance Goals | Propuesta: confirmación visual local de envío ≤1 s; resultados de red o aviso de espera/error ≤15 s por operación. Medir en red/dispositivos definidos, sin incluir entrega de correo en ese límite. Son presupuestos propuestos, no resultados ni SLA del proveedor. |
| Constraints | Internet obligatorio, Tips público, correo verificado para contenido protegido, sin teléfono/SMS, sin credenciales externas ni secretos administrativos en app. |
| Scale/Scope | F01: P10/P11 y estados de verificación/recuperación; no se inventan volúmenes de usuarios ni capacidad. |

**Entorno observado:** Linux x86_64; no se encontró Flutter/Dart ni Xcode. No hay
manifest de aplicación ni variables SUPABASE/SMTP/PRIVA presentes por nombre.
Esta etapa no requiere credenciales y no crea servicios externos. La compilación y
prueba de iOS requerirán macOS/Xcode y acceso a dispositivos o simuladores compatibles.

## Constitution Check

| Principio / puerta | Antes de investigación | Después del diseño propuesto |
| --- | --- | --- |
| I — fuente de verdad | Spec aprobado (`89c7647` registra aprobación) | RF y CA conservados; no se modifica spec ni se aprueban decisiones nuevas. |
| II — privacidad | Finalidades Q1 confirmadas; PD-05/06 pendientes | Modelo mínimo y aislamiento propuestos; despliegue real bloqueado hasta aprobar conservación, responsable, región y acuerdos. |
| III — cuestionario | F01 no procesa respuestas | Ninguna entidad ni contrato persiste respuestas/resultados; cierre futuro integra descarte sin logs. |
| IV — Zyro | Fuera del alcance de F01 | Sin proveedor de IA ni petición de credenciales externas. |
| V — accesibilidad | RNF aplicables identificados | Pruebas de texto, lector, foco y teclado exigidas; criterios definidos abajo; adiciones de esta corrección pendientes de ratificación. |
| VI — seguridad | Verificación obligatoria y código de recuperación aprobados | Estado restringido de recuperación, control de acceso y pruebas negativas; proveedor/correo aún por validar en proyecto de pruebas. |
| VII — trazabilidad | RF-01/02/03 y CA existentes | Contratos y guía enlazan CA; no se inventan tareas o pruebas ejecutadas. |
| VIII — simplicidad | Proyecto sin app | Un cliente móvil y autenticación gestionada; sin microservicios ni backend propio injustificado. |
| IX — aprobación | Constitución, spec base y plan base aprobados | Tareas generadas sin ejecutar; correcciones de esta revisión pendientes de ratificación antes de implementar. |

**Resultado:** diseño base aprobado con evidencia documental y prueba local; esta enmienda corrige el análisis y se somete a ratificación.
La prueba inicial falló el máximo exacto de cinco; el usuario retiró expresamente esa
regla y eligió límites nativos el 2026-10-27. No se aprueba una excepción en silencio.
La aprobación de este plan no certifica móviles ni configura un servicio hospedado.
Los requisitos de datos reales, SMTP, dispositivos y pruebas de entrega siguen siendo
puertas posteriores obligatorias, no resultados ya logrados.

## Project Structure

### Documentation (this feature)

```text
specs/001-cuenta-acceso/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── cuenta-acceso.md
└── checklists/requirements.md
```

`tasks.md` corresponde a una etapa posterior y no se crea ahora.

### Source Code (repository root)

Estructura propuesta; estos directorios de aplicación todavía no existen:

```text
mobile/
├── lib/
│   ├── app/                   # navegación y composición
│   └── features/account/
│       ├── presentation/      # P10/P11 y estados asociados
│       ├── application/       # coordinación de sesión y recuperación
│       └── data/              # adaptador del proveedor
├── test/features/account/     # estado, contratos del adaptador y widgets
└── integration_test/          # recorridos contra entorno de pruebas
supabase/
├── migrations/                # esquema y políticas revisables
└── tests/                     # aislamiento/autorización
```

**Structure Decision:** un cliente y un adaptador de autenticación, sin backend propio
que almacene contraseñas. Las carpetas de pruebas corresponden a obligaciones del
plan, no a pruebas creadas o ejecutadas. No se crea esquema de otros módulos.

## Diseño y seguridad propuestos

- Estados separados: visitante, verificación pendiente, autenticado y recuperación
  restringida. Una sesión que el proveedor emita al validar recuperación no debe
  interpretarse como acceso completo al contenido de la aplicación.
- Confirmación de correo activada en proveedor; una respuesta con usuario pero sin
  sesión no concede acceso. Propuesta para verificación de alta:
  código por correo dentro del flujo, evitando un requisito de enlaces profundos;
  esta decisión se incluyó en el plan base aprobado; los cambios de esta enmienda se identifican por separado.
- Recuperación: solicitar código al correo mediante `resetPasswordForEmail`, personalizar el template
  Reset password con `{{ .Token }}` en lugar del enlace, validar mediante
  `verifyOTP` con `OtpType.recovery`,
  permitir cambio de contraseña solo en ese flujo, cerrar su sesión temporal y pedir
  inicio de sesión normal. No usar un flujo OTP que cree usuarios automáticamente.
- Mínimo de contraseña de 12 caracteres aceptado por el usuario, sujeto a validación
  del proveedor. Decisión incluida en el diseño base: permitir frases largas y pegado,
  sin reglas arbitrarias de mezcla; al menos 64 caracteres aceptados si el proveedor
  lo soporta, nunca truncado silencioso. Verificar límites y políticas del proveedor.
- Parámetros confirmados: contraseña mínima de 12, código de 10 minutos y reenvío
  no antes de 60 segundos. Probados contra Auth local con configuración explícita.
  El 2026-10-27 el usuario retiró el máximo exacto de cinco fallos: usar el rate limit
  nativo de verificación, no un contador local. La prueba observó HTTP 429 al agotar
  la cuota; no equivale a bloqueo por identidad o por código. Documentar y revisar
  la cuota concreta del proyecto alojado antes de usuarios reales.
- Autorización privada del lado del servicio: exigir `sub` propio y un método firmado
  `password` en `amr`, además del flujo de correo verificado. El código de recuperación
  produce método `otp`, no necesariamente `recovery`; negar solo `recovery` es incorrecto.
  Tras confirmar alta por OTP, pedir acceso normal por contraseña antes de la app.
  Las tablas y funciones privadas deben aplicar la misma política; no basarse en
  metadatos editables. El informe distingue prueba SQL de despliegue RLS real.
- Persistir solo tokens de sesión en almacenamiento seguro del sistema operativo,
  nunca la contraseña o los códigos. No depender de persistencia local insegura
  predeterminada del SDK. TLS obligatorio; no desactivar validación de certificados.
- Propuesta de duración: acceso corto gestionado por proveedor y renovación segura;
  cierre por 30 días de inactividad y máximo absoluto 90 días si el plan/servicio
  seleccionado lo permite. Confirmar disponibilidad comercial/técnica antes de
  adoptar esos valores; no sustituirlo por un temporizador de UI.
- Errores públicos de registro y recuperación no revelan si el correo existe. Revisar
  tanto respuestas como diferencias observables; los errores de infraestructura
  del proveedor no se muestran literalmente al usuario.
- Revisar configuración anti-enumeración: la documentación de alta describe respuesta
  ofuscada para correo existente cuando Confirm email y Confirm phone están activos,
  incluso con proveedor de teléfono desactivado. Ese ajuste de privacidad NO autoriza
  recolectar teléfono ni implementar SMS. Validar respuestas reales y mensajes públicos.
- Configurar SMTP propio evaluado para producción: el correo predeterminado de Supabase
  tiene restricciones de destinatarios y no constituye un servicio de entrega productivo.
- Una identidad única por correo según reglas del proveedor evita duplicados de
  cuenta; bloqueo de doble envío y reintentos controlados en cliente. No repetir
  ciegamente una operación cuyo resultado es desconocido.
- Lectura de Tips sin sesión no habilita consultas de tablas de cuenta. RLS y autorización
  del proveedor protegen datos; guardas de navegación solo complementan estos controles.

## Pruebas y evidencia previstas

| Requisito / CA | Validación prevista | Evidencia sin datos personales reales |
| --- | --- | --- |
| RF-01 / CA-01.1/01.5/01.6 | Campos, errores, política, autorización y ausencia de teléfono | Resultados de widgets y revisión de pantallas con datos sintéticos. |
| RF-01/02 / CA-01.2/01.11 | Registro no verificado no concede acceso; confirmación sí habilita acceso normal | Traza sanitizada de estados y prueba contra Auth de pruebas. |
| RF-02 / CA-01.4/01.9/01.12/01.13 | Código correcto/incorrecto/vencido/usado; cambio permitido solo al validar; regreso a acceso | Resultados con buzones de prueba; nunca registrar códigos o tokens. |
| RF-03 / CA-01.3/01.8/01.10 | Credenciales inválidas, correo existente/inexistente, red, doble pulsación | Mensajes públicos comparados, recuento de cuentas sintéticas sin volcar credenciales. |
| CA-01.7 / RNF-01–06 | Texto hasta 200 % propuesto, TalkBack/VoiceOver, foco, teclado y móviles aprobados | Checklist por dispositivo y capturas con datos sintéticos. |
| CA-ACC-01–05 | Tips público; controles protegidos no eluden sesión; recuperación tampoco habilita app | Pruebas de navegación y autorización negativa. |
| SC-001 | Meta ≥80 % de registro | Protocolo propuesto de 10 participantes de 40–65 años, éxito ≥8; muestra y condiciones deben aprobarse, no generalizar estadísticamente. |

**Ejecutado:** sonda local reproducible de Auth/Postgres/correo simulado y política SQL;
verificación de metadatos, checksums de paquetes, documentos y rutas de Spec Kit.
[Resultados y límites](validation/README.md).
**No ejecutado:** instalación del SDK, compilación, app, correo externo, proyecto
Supabase alojado, despliegue de RLS/PostgREST, accesibilidad y usabilidad en móviles.

## Cierre del diseño y puertas posteriores

**Decisiones consolidadas:** Flutter + Supabase, finalidades Q1, confirmación Q2,
recuperación por código Q3, 12 caracteres/600 s/60 s y sustitución explícita del máximo
exacto de cinco por límites nativos. El informe registra resultados y el fallo inicial.

**Material incluido en la aprobación del plan base:** pins y mínimos técnicos,
verificación de alta por código seguida de acceso normal con contraseña, política AMR
para recursos privados, sesión propuesta de 30 días inactiva/90 absolutos si se contrata
un plan que lo soporte, presupuestos de 1/15 segundos, texto hasta 200 % y protocolo
piloto de 10 participantes con meta de al menos 8 registros completos. La aprobación de diseño no demuestra operación ni constituye promesa de servicio;
las condiciones dependientes del proveedor deben comprobarse antes de entrega.

**Puertas antes de aceptación/usuarios reales:**

1. Resolver dependencias con Flutter fijado, registrar lockfile y verificar builds
   Android/iOS y dispositivos de la matriz; si un transitorio eleva mínimos, detener
   el cambio y revisar la compatibilidad en lugar de ampliar exclusiones en silencio.
2. Configurar y probar Supabase hospedado: límites, plantillas, SMTP, verificación,
   refresh, sesiones y aislamiento con solicitudes HTTP directas a tablas/funciones.
   La prueba local no sustituye pruebas en la versión/configuración desplegadas.
3. Definir responsable, región, proveedor SMTP, acuerdos, textos de autorización,
   conservación y eliminación con revisión competente antes de tratar datos reales.
   No se fijan plazos jurídicos ni se aceptan términos por el usuario en esta etapa.
4. Ejecutar los CA, accesibilidad, compatibilidad, seguridad y usabilidad de la guía;
   no declarar cumplimiento de SC-001 sin la muestra y condiciones aprobadas.

La revisión de diseño puede aprobarse sin declarar cumplidas esas puertas de entrega.
No se crean tareas ni implementación sin aprobación explícita de este plan.

## Complexity Tracking

No se propone excepción constitucional ni backend propio de contraseñas. Si los
límites de OTP/privacidad del proveedor exigen infraestructura adicional, volver a
revisar alternativas y aprobar su impacto antes de ampliar esta estructura.

## Artefactos y estado de las fases

- [Investigación](research.md): mecanismos y restricciones contrastados, pins propuestos
  fijados y decisión de límite nativo registrada. Investigación de diseño cerrada con
  las limitaciones de validación operacional explícitas.
- [Modelo](data-model.md), [contratos](contracts/cuenta-acceso.md) y
  [guía](quickstart.md): diseño base aprobado y correcciones pendientes de ratificar, no implementación ni pruebas
  finales del producto. [Informe](validation/README.md) y sonda reproducible adjuntos.
- [Tareas](tasks.md) generadas y no ejecutadas; su aprobación sigue pendiente. La
  aprobación expresa del plan base se registra abajo y no se extiende por inferencia
  a las correcciones actuales, tareas o implementación.

## Registro de respuestas del usuario — 2026-10-26

- Compatibilidad: «que sea compatible con todos los dispositivos». Se registra como
  objetivo de cobertura máxima viable de móviles Android/iOS, sin certificar equipos
  antiguos o no soportados. Falta comprobar y documentar límites reales.
- Seguridad: «Sí, sujeto a validación del proveedor» para contraseña mínima de 12
  caracteres, código de 10 minutos, reenvío cada 60 segundos y máximo de 5 fallos
  antes de nuevo desafío. No aprueba por extensión todos los otros parámetros.
- Estas respuestas no aprueban el plan completo ni autorizan tareas o implementación.

## Cambio confirmado — 2026-10-27

El usuario eligió «Usar límites nativos y retirar el máximo exacto de cinco» después
de conocer la limitación del proveedor. Se conserva evidencia de la prueba inicial
fallida y se repite la sonda con el criterio revisado, sin ocultar el cambio de regla.

## Registro de aprobación — 2026-10-27

El usuario respondió «apruebo el pan 001» a la solicitud de aprobación del plan 001
revisado del commit `fcefa6a`. Por el contexto, «pan» se interpreta como «plan».
Queda aprobado el diseño técnico revisado de F01, incluida la baseline propuesta,
los mínimos Android 7.0/API24 e iOS15 y los límites nativos de verificación aceptados.

La aprobación incluye el alcance y las condiciones del plan, no afirma builds,
compatibilidad ejecutada o configuración hospedada inexistentes; tampoco acepta
contratos comerciales o legales ni aporta credenciales. Se mantienen todas las
puertas de datos reales y de aceptación del producto indicadas arriba.

Se cierra la puerta de planificación. La siguiente etapa puede generar tareas
para este plan aprobado cuando se solicite. Este registro no crea `tasks.md`,
no inicia implementación ni aprueba las otras funcionalidades.

## Correcciones propuestas del análisis 001 — 2026-10-27

### C1 — Severidad y controles verificables

| Severidad | Criterio | Regla de cierre |
| --- | --- | --- |
| Crítica | Acceso a cuenta/datos ajenos, bypass de autenticación, exposición de secretos o incumplimiento de una prohibición de privacidad | Bloquea entrega; corregir, repetir pruebas y revisar alcance del incidente. |
| Alta | Imposibilidad de completar registro, verificación o recuperación; enumeración de cuentas; pérdida/corrupción de evidencia de autorización | Bloquea entrega; corregir y repetir los CA afectados. |
| Media | Problema recuperable sin exposición que degrada uso o incumple un umbral medible | Corregir antes de entregar si incumple un CA/umbral; no rebajarlo de categoría para declarar éxito. |
| Baja | Defecto cosmético sin afectar comprensión, accesibilidad, seguridad ni CA | Registrar y someter cualquier aplazamiento a aceptación explícita; no equivale a prueba satisfactoria. |

Todo CA incumplido bloquea aceptación, independientemente de su etiqueta de severidad.
No se autoriza una excepción constitucional. Como criterio medible adicional para
la revisión: contraste mínimo 4,5:1 para texto normal y 3:1 para texto grande según
definición WCAG 2.2 AA y para componentes/estados visuales significativos; texto 200 %
sin recortes ni acciones inaccesibles. Registrar mediciones por estado en T037.
Estos criterios son reglas de calidad propuestas en esta corrección, no cumplimiento
normativo ya medido ni requisitos aprobados por publicar el documento.

### U1 — Alta y evidencia de autorización en una transacción

Usar el mismo Postgres de Supabase: un trigger AFTER INSERT sobre auth.users crea
perfil mínimo y evidencia inmutable dentro de la transacción de alta del proveedor.
La migración T021 completa la función creada por T020 antes de habilitar el registro.
No se requiere una sesión cliente para esa escritura ni un servicio de contraseñas propio.

La solicitud signUp lleva nombre y una declaración explícita de autorización con
versión de política/acción. El trigger valida esa declaración frente a una versión
publicada en una tabla de políticas controlada por el servidor, obtiene el ID desde
NEW.id y asigna fecha en servidor. Estos datos de entrada no conceden permisos ni
prueban identidad o comprensión por sí mismos; la verificación de correo sigue siendo
obligatoria. No aceptar un ID de titular o fecha de evidencia elegidos por el cliente.

La función tiene privilegios mínimos, búsqueda de esquema fija y escritura reservada
al alta; no exponerla como RPC pública ni permitir que la edición de user_metadata
modifique evidencia existente. Una política ausente/inactiva, falta de declaración
o fallo al insertar evidencia hace fallar toda la transacción: sin cuenta o perfil
huérfanos. En pruebas sintéticas se publica una política de prueba, nunca una política
provisional presentada como definitiva para usuarios reales.

La identidad única por correo y una clave única de evidencia inicial por usuario,
versión y acción evitan duplicados. Reintentar tras respuesta perdida no sobrescribe
la evidencia ni añade autorizaciones: el cliente reconcilia por el flujo seguro de
confirmación/acceso con mensaje uniforme. Un cambio posterior de política requiere
su propio procedimiento, fuera de esta alta inicial; no inferir nueva autorización.
T018/T031 deben probar rollback, reintento, versión inválida, modificación de metadata
y escritura directa no permitida; T033 repite autorización por HTTP en el entorno final.
La sonda local previa NO probó este trigger: se mantiene como validación de implementación.

### A1 — Mensajes sin enumeración

CA-01.11 usa el mismo aviso de acceso fallido para correo inexistente, contraseña
incorrecta y correo no verificado. No revelar ese último estado por recibir un error
crudo de Auth. T015/T027/T031/T039 comparan textos y resultados públicos entre casos;
el servicio no debe ofrecer datos identificadores o una vía pública alternativa para
consultar existencia. Tiempos y respuestas del proveedor se revisan en el entorno real,
sin afirmar indistinguibilidad de red demostrada por una prueba de widgets.

### G1 — Medición de tiempos, no solo builds

T045 mide con reloj monotónico feedback local desde pulsación (≤1 s) y respuesta de
red o aviso de espera/error (≤15 s). Preparar 20 repeticiones por operación y perfil de
red, con dispositivo/OS y condiciones definidos en la matriz; validar también una
respuesta artificialmente lenta para comprobar el aviso y el manejo de respuestas tardías.
No incluir la entrega del correo dentro de 15 s ni usar un timeout para afirmar que
Auth completó la operación. Guardar duraciones/resultados sin nombres, correos o tokens.
Cualquier exceso es un fallo del presupuesto, no una media que oculte casos lentos.

**Dependencia final:** T045 precede a la consolidación T043 y al cierre T044; no
cambia sus IDs estables. Las cinco correcciones se someten a revisión/ratificación
antes de implementar. El mensaje «si» autorizó editar y repetir análisis, no ejecutar tareas.

## Ratificación de correcciones — 2026-10-27

El usuario respondió «lo apruebo» a la solicitud de aprobación de las correcciones
y las 45 tareas del commit a7b99a4. Quedan ratificadas C1, U1, G1, A1 e I1, incluidos
criterios de calidad, diseño transaccional de autorización, mensajes uniformes y
medición de tiempos. Las pruebas y condiciones de entrega continúan obligatorias;
esta aprobación no acredita implementación ni validaciones nuevas ejecutadas.

## Adaptación Firebase — 2026-10-28

Solicitud explícita del usuario: revisar, adaptar y validar. [Estado parcial y
evidencia](validation/firebase-results.md). Firebase sustituye al proveedor en el arranque;
el diseño Supabase anterior queda como antecedente. Registro, evidencia y códigos
siguen pendientes de diseño validado; no se cambia el comportamiento aprobado.

## Propuesta de cierre Firebase

Ver [diseño candidato completo](firebase-completion-plan.md). La compensación de
identidad Auth deshabilitada y transacción Firestore sustituiría la atomicidad U1:
requiere aprobación expresa, no se considera aprobada por una prueba o commit.

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

## Alta nativa y evidencia Firestore autorizadas

El usuario identificó al equipo de Priva como responsable, indicó
priva202611@gmail.com para eliminación y autorizó expresamente implementar el
alta y conservar evidencia en una colección Firebase. Se usa Cloud Firestore, sin
Cloud Functions. Política cliente versionada `priva-1.0.0`, perfil mínimo y evidencia
en `authorization_evidence/{uid}`: UID, versión, finalidades, acción, aceptación y
fecha de servidor. Sin contraseña, correo duplicado, IP ni dispositivo en evidencia.
Perfil y evidencia se escriben en un batch atómico Firestore; Auth NO comparte
transacción: si el batch falla se intenta eliminar la cuenta recién creada. Si esa
compensación falla, sigue denegado el acceso por ausencia de evidencia; requiere
reconciliación del responsable. No se afirma rollback atómico entre servicios.
Se sustituye el diseño U1/Postgres por este flujo dependiente del proveedor elegido.

Confirmación de alta usa enlace nativo de Firebase Auth, con pantalla de reenvío
y comprobación mediante reload antes de volver al acceso normal; no código.
La creación/confirmación no concede acceso a contenido protegido. El inicio exige
correo verificado, método password y evidencia leída del servidor; se retira el
claim priva_account_ready porque la evidencia y reglas lo sustituyen. Firestore
sin caché persistente en cliente. Las reglas niegan escritura/modificación/borrado
cliente de evidencia salvo creación propia validada, y niegan datos del cuestionario.

Implementación local probada, reglas preparadas pero sin ejecutar emulador por
descarga bloqueada. No están desplegadas; faltan validación del proyecto real,
región/acuerdos/calendario revisados, APK, dispositivos y piloto. No se declara
aceptación final de política/servicio ni cierre de T039/T042 por este cambio.
