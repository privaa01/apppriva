# Implementation Plan: F01 — Cuenta y acceso

**Branch**: `work` | **Date**: 2026-10-26 | **Spec**: [spec.md](spec.md)
**Input**: `/specs/001-cuenta-acceso/spec.md` — aprobado; constitución v1.0.0 ratificada.
**Status**: Propuesta de plan técnico, no aprobada. No habilita tareas ni implementación.

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
| Language/Version | Flutter estable y su Dart incluido; fijar versión exacta y lockfile al preparar implementación, tras verificar soporte de la matriz aprobada. No se declara SDK instalado. |
| Primary Dependencies | SDK oficial `supabase_flutter`; navegación central con control por estado; almacenamiento de sesión respaldado por Keychain/Keystore mediante adaptador seguro evaluado. Versiones exactas deberán quedar fijadas y auditadas antes de implementar. |
| Storage | Identidad/credenciales en Supabase Auth. Perfil mínimo y evidencia de autorización en Postgres con aislamiento por usuario; no crear banco de preguntas, chat ni resultados para F01. |
| Testing | `flutter_test`, pruebas de widgets y `integration_test`; proyecto de autenticación de pruebas y buzones sintéticos para aceptación real. No simular envío como prueba de entrega de correo. |
| Target Platform | Android e iOS con la mayor cobertura de móviles viable, objetivo confirmado por el usuario. Determinar el mínimo compatible común del SDK estable y las dependencias, documentar exclusiones y validar la matriz; no prometer todos los dispositivos ni elegir aún un mínimo numérico sin comprobarlo. |
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

**Resultado:** diseño documental revisable, sin excepción constitucional autorizada.
No se declara plan cerrado mientras sigan pendientes matriz móvil y decisiones de seguridad indicadas a continuación. No se afirma validación
operativa del proveedor ni cumplimiento jurídico. No se deben esconder estos bloqueos
mediante un estado «listo para implementar».

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
- Parámetros aceptados por el usuario, sujetos a validación del proveedor: validez
  de código de 10 minutos, reenvío no antes de 60 segundos y, tras 5 fallos de
  verificación, exigir nuevo desafío. Uso único y espera adicional siguen como
  controles técnicos del diseño que deben concretarse. El proveedor debe
  imponer el límite real: una cuenta regresiva local no es una defensa suficiente.
  No construir un servicio propio de OTP sin reevaluar complejidad y privacidad.
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

**No ejecutado:** instalación de SDK, compilación, pruebas de app, correo, proveedor,
accesibilidad y usabilidad. Solo se verificó organización de documentos y resolución
de la funcionalidad en Spec Kit.

## Decisiones necesarias para cerrar el plan

1. Flutter + Supabase ya están confirmados. Fijar SDK/dependencias con evidencia
   de compatibilidad antes de cerrar el plan, sin inventar versiones instaladas.
2. El usuario solicita la mayor cobertura de dispositivos. Cerrar PD-07 comprobando
   el mínimo común del SDK y las dependencias, arquitecturas y una matriz de móviles
   pequeños/grandes, versiones mínima/actual y capacidades accesibles; presentar
   exclusiones verificadas antes de aprobar una afirmación de compatibilidad.
   No interpretar «todos los dispositivos» como tablets, escritorio o plataformas
   adicionales fuera del alcance móvil Android/iOS aprobado.
3. Validar que el proveedor imponga los valores aceptados (12 caracteres, código
   de 10 minutos, reenvío de 60 segundos y máximo de 5 fallos); si no los soporta,
   documentar la diferencia y proponer corrección antes de modificar la regla.
   Duración de sesión, presupuestos de tiempos, texto ampliado, política adicional
   de contraseña y protocolo de usabilidad siguen pendientes de aprobación.
4. Resolver responsable de datos, región, proveedor de correo, acuerdos, conservación
   y eliminación. No es correcto inventar plazos jurídicos para cerrar esta sección.
5. **Bloqueo de seguridad por demostrar:** la documentación no garantiza una sesión
   recovery-only a nivel de servidor. Validar que una sesión emitida en recuperación
   no pueda saltarse la frontera del contrato mediante llamadas directas; si no se
   puede imponer, revisar el diseño y aprobar la corrección antes de tareas.
6. Verificar comportamiento real de códigos, sesión de recuperación, anti-enumeración,
   persistencia segura, límites y correo en entorno de pruebas antes de aceptar entrega.

Flutter + Supabase y los cuatro parámetros de seguridad indicados tienen aprobación
expresa en el alcance registrado; los parámetros están condicionados a validación
del proveedor. El objetivo de cobertura amplia no equivale a una matriz certificada.
Las demás propuestas siguen siendo material para aprobación del plan, no recursos desplegados. La investigación y contratos siguientes son un
diseño condicionado por esas decisiones. No pasar a tareas si esta puerta está abierta.

## Complexity Tracking

No se propone excepción constitucional ni backend propio de contraseñas. Si los
límites de OTP/privacidad del proveedor exigen infraestructura adicional, volver a
revisar alternativas y aprobar su impacto antes de ampliar esta estructura.

## Artefactos y estado de las fases

- [Investigación](research.md): documentación oficial contrastada y decisiones registradas;
  quedan comprobaciones del proveedor y parámetros pendientes. Fase 0 no cerrada.
- [Modelo](data-model.md), [contratos](contracts/cuenta-acceso.md) y
  [guía de validación](quickstart.md): diseños preliminares para revisión, no fase 1
  declarada completa mientras estén abiertos los bloqueos de fase 0.
- No se generan tareas ni implementación. El plan se guarda como borrador concreto
  para continuar la revisión, no como aprobación ni verificación ejecutada.

## Registro de respuestas del usuario — 2026-10-26

- Compatibilidad: «que sea compatible con todos los dispositivos». Se registra como
  objetivo de cobertura máxima viable de móviles Android/iOS, sin certificar equipos
  antiguos o no soportados. Falta comprobar y documentar límites reales.
- Seguridad: «Sí, sujeto a validación del proveedor» para contraseña mínima de 12
  caracteres, código de 10 minutos, reenvío cada 60 segundos y máximo de 5 fallos
  antes de nuevo desafío. No aprueba por extensión todos los otros parámetros.
- Estas respuestas no aprueban el plan completo ni autorizan tareas o implementación.
