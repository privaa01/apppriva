# Implementation Plan: F02 — Perfil y cuenta

**Branch**: `work` | **Date**: 2026-10-29 | **Spec**: [spec.md](spec.md).
**Input**: `specs/002-perfil-cuenta/spec.md`, aprobado sobre a6c68a4.
**Status**: Approved — aprobado explícitamente por el usuario el 2026-10-29.

## Summary

Integrar P12 en la guarda actual de `/profile`: consultar nombre/correo de la cuenta,
editar solo nombre, cerrar sesión y abrir una solicitud por correo al equipo de
Priva. Conservar Flutter/Firebase del001 y el wireframe corregido. No crear backend,
colecciones, fotos, teléfono, borrado automático ni preferencias propias de texto.

Consultar nombre desde Firestore servidor y correo desde identidad Firebase, sin
copiarlo a la base. Un controlador propio de perfil descarta datos ante cierre o
cambio de identidad. Editar con transacción del documento existente y confirmación
servidor; mantener la evidencia de autorización intacta. Abrir `mailto` bajo acción
expresa y ofrecer copiar correo si no hay aplicación disponible.

## Technical Context

| Campo | Diseño propuesto |
| --- | --- |
| Language/Version | Baseline existente Flutter3.47.8 / Dart3.13.7, sin cambio. |
| Primary Dependencies | Mantener firebase_core5.1.0, firebase_auth7.0.1 y cloud_firestore7.1.0. Proponer url_launcher6.3.3; sin instalar en esta fase. |
| Storage | Documento existente `profiles/{uid}` con nombre; identidad existente Auth para correo; evidencia F01 sin modificaciones. Firestore continúa sin persistencia local. |
| Testing | Flutter unit/widget; dobles de plataforma para correo/portapapeles; reglas Firestore en emulador y validación controlada del servicio; Android con/sin cliente de correo. |
| Target Platform | Android API24+, matriz mínimo/actual y pantalla pequeña/grande, TalkBack y texto200%. iOS excluido. |
| Project Type | App móvil existente; módulo `features/profile` y servicios nativos mínimos. |
| Performance Goals | Reutilizar presupuestos de F01: feedback local≤1s, respuesta o aviso recuperable≤15s. No prometer envío/entrega de correo ni cancelación de transacción por timeout. |
| Constraints | Cuenta propia, correo verificado, método password y evidencia válida; cero datos del cuestionario, sin nuevas finalidades ni secretos administrativos. |
| Scale/Scope | Una pantalla principal P12, edición en la misma pantalla y explicación/redacción de solicitud. Sin nuevos volúmenes, SLA o plazos legales inventados. |

El Android transitivo contrastado de url_launcher es 6.3.33, minSdk24. Resolver y
versionar lockfile al implementar; detener y revisar si la resolución cambia mínimos.
No fijar transitorio como dependencia directa si no se importan sus APIs.

## Constitution Check

Puerta previa y posterior al diseño: **satisfactoria para proponer el plan**, no
certifica operación ni sustituye su aprobación.

| Principio | Control del diseño / evidencia prevista |
| --- | --- |
| I — spec | Spec aprobado y CA-02.1–02.19 conservados; contratos enlazan comportamientos. |
| II — privacidad | Reutilizar UID/nombre/correo, sin copiar correo al perfil ni crear solicitudes en servidor; no fijar retenciones. |
| III — cuestionario | Ninguna entidad o registro guarda respuestas/resultados; cierre mantiene frontera de descarte futuro. |
| IV — Zyro | No se integra IA ni se agregan capacidades del chat. |
| V — accesibilidad | Criterios medibles abajo; texto200%, lectores, foco, errores y teclado. |
| VI — seguridad | Guardas y reglas propias; sesión/UID capturados, respuesta tardía descartada, consentimiento inmutable. |
| VII — trazabilidad | [Contratos](contracts/perfil-cuenta.md) y [guía](quickstart.md) cubren todos los CA. |
| VIII — simplicidad | Un módulo pequeño y plugin para redactor; sin Cloud Functions, red de soporte o eliminación automática. |
| IX — etapas | Aprobación del spec registrada; plan pendiente. Commit/push del borrador no autoriza tareas. |

La conservación, eliminación y acuerdos operativos del001 no se declaran probados
por F02. Este módulo informa la solicitud por correo y no promete supresión realizada.
La postergación de pruebas de reglas aceptada para el001 no aprueba reglas nuevas
de escritura de F02 sin validarlas: documentar cualquier bloqueo antes de entrega.

## Project Structure

### Documentation

`spec.md`, `plan.md`, `research.md`, `data-model.md`, `contracts/perfil-cuenta.md`,
`quickstart.md`, `checklists/requirements.md`. `tasks.md` se genera solo tras aprobar
el plan. Los registros de validación F02 se crearán al ejecutar sus pruebas.

### Source Code — propuesto, no creado

```text
mobile/lib/features/profile/
├── application/profile_controller.dart
├── application/profile_state.dart
├── data/profile_repository.dart
├── data/firestore_profile_repository.dart
├── data/profile_details.dart
├── data/deletion_contact_service.dart
└── presentation/profile_screen.dart
mobile/test/features/profile/
mobile/integration_test/profile_account_test.dart
```

Integración mínima en `main.dart`, `PrivaApp`/`AccountRouter`, controlador/estado de
cuenta para sincronizar nombre confirmado y limpieza. Reutilizar `AccountScaffold`.
Modificar `firebase/firestore.rules` y añadir pruebas a la suite de reglas existente.
No añadir rutas de contenidos F03–F08 ni sustituir los builders de pruebas de F01.

## Diseño propuesto

### Consulta y edición

- `ProfileRepository` pequeño con `loadCurrent()` y `updateName(name)`; el adaptador
  deriva UID de Auth, nunca de un campo editable o ruta. Valida identidad vigente,
  método password, correo verificado y evidencia del001. Correo transitorio de Auth.
- Carga explícita de servidor al abrir P12; no usar el nombre capturado al iniciar
  sesión como fuente definitiva ni datos de ejemplo. Error/vacío distinto de éxito.
- `ProfileController` separado del flujo de credenciales: confirmado, borrador,
  cargando, editando, guardando, error y resultado desconocido. Draft solo en memoria.
- Nombre con `trim`, obligatorio y sin reglas arbitrarias sobre apellidos, longitud
  máxima o caracteres legítimos. Validar también en servicio el nombre no vacío/solo
  espacios. Cancelar antes de enviar restaura el valor confirmado; no escribe.
- Transacción Firestore sobre el perfil existente, sin crear otro documento, modificar
  Auth.displayName o tocar evidencia. Leer/validar dentro del intento; cambiar solo
  `name`. Las transacciones no se convierten en una cola offline de cambios optimistas.
- Capturar UID/generación antes de cada operación; comprobar vigencia al resolver y
  en reintentos de transacción. Bloquear doble envío. No confundir timeout con
  cancelación: conservar el confirmado, avisar resultado desconocido y reconciliar
  con lectura del servidor antes de reintentar. No permitir un nuevo guardado mientras
  el anterior no se haya resuelto. Una escritura enviada puede finalizar al salir.
- Tras éxito actualizar el nombre confirmado de Perfil y, mediante método guardado
  por UID en AccountController, su nombre de sesión en memoria; no cambiar permisos,
  identidad o estado autenticado. Una respuesta vieja no concede acceso.

### Reglas y cierre

- Hoy `profiles.update` está denegado. Permitirlo solo para UID propio, correo
  verificado, método password y evidencia válida; `affectedKeys` solo `name`, nombre
  válido y sin campos adicionales. Pruebas directas negativas antes de publicar.
- Mantener create F01 sin cambios, evidencia inmutable y denegación por defecto.
  No permitir editar correo, insertar teléfono, cambiar UID o borrar perfiles por SDK.
- Reutilizar AccountController.signOut: limpia estado local antes de esperar Auth.
  Vaciar perfil/borrador, invalidar futuras respuestas y retirar rutas privadas del
  historial. Tips sigue público. Error remoto sanitizado sin restaurar el perfil.
- No revocar otros dispositivos, eliminar cuenta ni prometer cancelar operaciones
  remotas ya enviadas. El descarte de cuestionario se prueba como frontera cuando
  exista su módulo, sin implementar persistencia o un cuestionario en F02.

### Solicitud por correo

- Usar `url_launcher6.3.3`, `launchUrl(mailto, mode: externalApplication)` directamente
  tras pulsar; no bloquear por `canLaunchUrl`, que puede dar falsos negativos.
- Destinatario fijo `priva202611@gmail.com`, asunto/cuerpo genéricos sin UID, correo
  de cuenta, credenciales, datos de cuestionario ni diagnóstico. Escapar componentes
  con Uri.encodeComponent para evitar espacios `+` en esquemas noHTTP.
- Manejar `false`/excepción con dirección visible y Copiar correo (Clipboard de Flutter).
  No escribir portapapeles sin pulsación, ni solicitar permisos/listar apps/contactos.
- No requerir queries de Android si no se consulta canLaunchUrl; validar apertura
  real en Android11+ y API24. No añadir permisos por inferencia.
- Texto: «Se abrirá tu app de correo. Envía la solicitud desde el correo de tu cuenta.
  Abrir este borrador no elimina tus datos». No mostrar «enviado» ni crear expediente.

## Validación y criterios de severidad

- Crítica: acceso ajeno/sin sesión, escritura fuera de nombre, evidencia modificada,
  secretos/cuestionario persistidos. Bloquea entrega; corregir y repetir.
- Alta: cierre restaura datos, guardado informa falso éxito, solicitud se presenta
  como eliminación o se envía sin decisión. Bloquea entrega.
- Cualquier CA incumplido bloquea aceptación, aunque el defecto sea visual.
- Etiquetas y objetivos Android≥48dp, contraste≥4.5:1 normal y ≥3:1 texto grande y
  componentes significativos, texto200% sin pérdida de acciones; TalkBack manual.
- Matriz: API24 y Android actual soportado al ejecutar, pequeña320×720 y grande;
  registrar modelos/versiones, con/sin cliente correo. No inventar ejecuciones.
- Medir feedback1s/aviso15s con reloj monotónico; avisar guardado pendiente sin usar
  timeout como prueba de finalización. Heredar protocolo de 20 repeticiones por
  operación/perfil de red del001 para carga/guardado; correo mide apertura/fallback,
  nunca entrega de mensaje por otro proveedor.

Antes de aprobar spec: alcance resuelto (cumplido). Antes de aprobar plan: contratos,
modelo y riesgos concretos revisados. Antes de entregar: pruebas de CA, reglas nuevas,
nativos, regresión del001 y evidencia trazable, sin declarar aprobadas pruebas omitidas.

## Complexity Tracking

Sin excepción constitucional propuesta. Se reutiliza un cliente Firebase y un plugin
para el redactor. La edición autoriza solo nombre; un servicio adicional de datos o
solicitudes no aporta valor al alcance aprobado.

## Estado y límites

Investigación completada con repositorio y fuentes de paquetes: [research.md](research.md).
Diseño y contratos preparados. No se han añadido dependencias al proyecto, cambiado
reglas, desplegado, creado tareas, implementado pantallas ni ejecutado pruebas F02.
El código de F01 sirve de baseline; sus69 pruebas no acreditan F02. Hooks: no existe
`.specify/extensions.yml`, sin hooks que ejecutar antes/después. Plan pendiente de aprobación.

## Registro de aprobación del plan — 2026-10-29

El usuario respondió «lo apruebo» a la solicitud de aprobar el plan002 del commit
1d01d98 para generar tareas. Quedan aprobados diseño, modelo, contratos, guía y
criterios de validación de esa revisión. Se autoriza generar tasks.md, no ejecutarlo
ni iniciar implementación. La aprobación no demuestra reglas desplegadas, pruebas
nativas realizadas o nueva aceptación de datos reales. Las referencias anteriores
a plan pendiente describen el estado previo a esta aprobación.

## Generación de tareas posterior a la aprobación

Se creó [tasks.md](tasks.md) con34 tareas pendientes,18 asociadas a HU-02.
Ninguna ha sido ejecutada. Esta lista requiere su propia aprobación antes de
implementar; los estados previos de este documento se conservan como historial.

## Implementación autorizada y estado actual

El usuario indicó «inicia la implementación» sobre las tareas de5611047. Se
implementaron los componentes y pruebas locales; ver validation/current-results.json.
Los estados anteriores se conservan como historia de diseño. Sin entrega final,
reglas publicadas por el asistente o avance al003;8 validaciones finales pendientes.
