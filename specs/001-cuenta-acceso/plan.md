# Implementation Plan: F01 — Cuenta y acceso

**Branch**: `work` | **Date**: 2026-10-27 | **Spec**: [spec.md](spec.md)
**Input**: `/specs/001-cuenta-acceso/spec.md` — aprobado; constitución v1.0.0 ratificada.
**Status**: Approved — aprobación explícita del usuario registrada el 2026-10-27. Validación local y límites documentados en el [informe](validation/README.md); implementación no iniciada.

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
| V — accesibilidad | RNF aplicables identificados | Pruebas de texto, lector, foco y teclado exigidas; criterios numéricos propuestos sujetos a aprobación. |
| VI — seguridad | Verificación obligatoria y código de recuperación aprobados | Estado restringido de recuperación, control de acceso y pruebas negativas; proveedor/correo aún por validar en proyecto de pruebas. |
| VII — trazabilidad | RF-01/02/03 y CA existentes | Contratos y guía enlazan CA; no se inventan tareas o pruebas ejecutadas. |
| VIII — simplicidad | Proyecto sin app | Un cliente móvil y autenticación gestionada; sin microservicios ni backend propio injustificado. |
| IX — aprobación | Constitución y F01 aprobados | Este plan sigue pendiente; no crear `tasks.md` ni código antes de aprobación. |

**Resultado:** diseño preparado para aprobación con evidencia documental y prueba local.
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
  esta decisión técnica no estaba fijada por Q2 y requiere aprobación del plan.
- Recuperación: solicitar código al correo mediante `resetPasswordForEmail`, personalizar el template
  Reset password con `{{ .Token }}` en lugar del enlace, validar mediante
  `verifyOTP` con `OtpType.recovery`,
  permitir cambio de contraseña solo en ese flujo, cerrar su sesión temporal y pedir
  inicio de sesión normal. No usar un flujo OTP que cree usuarios automáticamente.
- Mínimo de contraseña de 12 caracteres aceptado por el usuario, sujeto a validación
  del proveedor. Propuesta adicional aún no aprobada: permitir frases largas y pegado,
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

**Material concreto que se somete a aprobación del plan:** pins y mínimos técnicos,
verificación de alta por código seguida de acceso normal con contraseña, política AMR
para recursos privados, sesión propuesta de 30 días inactiva/90 absolutos si se contrata
un plan que lo soporte, presupuestos de 1/15 segundos, texto hasta 200 % y protocolo
piloto de 10 participantes con meta de al menos 8 registros completos. Son propuestas
revisables, no decisiones ya aprobadas ni promesas de servicio.

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
  [guía](quickstart.md): diseño revisado para aprobación, no implementación ni pruebas
  finales del producto. [Informe](validation/README.md) y sonda reproducible adjuntos.
- `tasks.md` no creado. No se registra aprobación por la frase «completa validaciones
  y damos aprobación»: se entrega primero este resultado revisable.

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
