# Feature Specification: F01 — Crear cuenta, iniciar sesión y recuperar acceso

**Feature Branch**: `work` (rama actual; la funcionalidad se selecciona por directorio)
**Created**: 2026-10-21
**Status**: Draft — especificación funcional separada; pendiente de aprobación.
**Separated**: 2026-10-26
**Input**: Especificar esta funcionalidad a partir de PRIVA_MOBILE_SPEC.md, sus pantallas y las decisiones explícitas del usuario.
**Fuentes**: [Spec original](../../docs/referencias/PRIVA_MOBILE_SPEC.md), [PDF](../../docs/referencias/app.pdf).

## Regla de acceso confirmada — 2026-10-26

Decisión explícita del usuario: sin iniciar sesión solo se accede al contenido de
Tips (P02 y sus cuatro detalles P03–P06). Crear cuenta, iniciar sesión y recuperar
acceso siguen disponibles como flujos de entrada, no como contenido protegido.
Con sesión iniciada se habilitan todas las funcionalidades de Priva dentro de su
alcance aprobado; Perfil solo permite gestionar la propia cuenta.

Se conserva la navegación del wireframe de acceso. Que un control esté visible
NO concede acceso: Inicio, Perfil, Chat IA, Cuestionario y Resultados requieren
sesión. Sin sesión, seleccionar una opción protegida debe indicar que se necesita
iniciar sesión y no mostrar su contenido. El detalle visual del aviso no se fija aquí.
Al cerrar sesión se revoca el acceso protegido y se descarta el cuestionario y su
resultado; Tips continúa disponible. No se añade modo sin conexión.

Esta decisión sustituye la exclusión visual del menú en acceso y la interpretación
de que toda la app necesita cuenta. Los extractos del spec original que se conservan
más abajo son antecedentes: ante discrepancia prevalece esta revisión explícita.
No aprueba el resto del spec ni autoriza el cambio de etapa.

## User Scenarios & Testing *(mandatory)*

### HU-01 — Crear cuenta y acceder (RF-01 a RF-03)

Como usuario, quiero crear una cuenta e iniciar sesión para acceder a Priva.

- **CA-01.1:** Dado un formulario vacío o inválido, cuando intento registrarme, se muestran errores comprensibles y no se crea una cuenta incompleta.
- **CA-01.2:** Dado un registro válido y la autorización aplicable, cuando se confirma su creación, accedo a Inicio.
- **CA-01.3:** Dadas credenciales inválidas o un fallo de conexión, se muestra un mensaje recuperable y no se concede acceso.
- **CA-01.4:** Dado que olvidé mi contraseña, puedo iniciar el flujo seguro de recuperación.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias conforme a esta especificación; las pruebas aún no se han ejecutado.
**Recorrido:** Registro → Inicio; acceso válido → contenido protegido; recuperación desde P11 sin nueva pantalla principal obligatoria.

### Edge Cases

Datos inválidos; credenciales incorrectas; falta de red; reintento sin duplicar registro; no revelar existencia o datos de otras cuentas.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-01**: Permitir crear cuenta con nombre, correo y contraseña, validando campos y formato.
- **RF-02**: Permitir iniciar y cerrar sesión y recuperar el acceso mediante un mecanismo seguro. Cierre de sesión corresponde a F02; acceso y recuperación a F01.
- **RF-03**: Mostrar errores de registro y acceso comprensibles sin exponer datos de terceros.

### Asociación a pantallas

P10 (PDF 2), P11 (imagen de acceso recibida el 2026-10-26); destino P01 (PDF 1).

**Revisión 2026-10-26:** P11 ya tiene diseño con correo, contraseña y botón Iniciar sesión.
El usuario confirma que la app no pide teléfono; no añadirlo a registro o recuperación.

**Brechas observadas:** Faltan política y autorización consultables en registro, estados
de validación/error y recuperación. P11 muestra Inicio, Perfil y menú inferior,
conservados por decisión del usuario; D16 queda resuelto mediante la nueva regla de acceso.
No aprobar proveedor, caducidad ni sesión por defecto.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase [el índice SDD](../README.md) para el reparto F06/F07.

### 7. Cuenta y ciclo de uso

### Registro

La vista incluye nombre, correo, contraseña, Crear cuenta y acceso a Iniciar sesión. Debe identificar campos obligatorios, mostrar validaciones por campo y permitir consultar la política de tratamiento antes de autorizar lo que corresponda. La justificación de cada dato se incorporará antes del cierre del spec.

Al completar el registro correctamente, el usuario accede al inicio. No se almacenan contraseñas en texto legible. La política de contraseñas, verificación de correo y duración de sesión se concretan en el plan técnico.

### Acceso y recuperación

El usuario puede iniciar sesión, cerrar sesión y solicitar recuperación de acceso. El mecanismo de recuperación debe verificar el control del medio de recuperación y evitar revelar datos de otras cuentas. Deben definirse caducidad, reintentos y mensajes en el plan técnico.

### Perfil y eliminación

El perfil permite consultar y gestionar los datos de cuenta, ajustar texto, cerrar sesión y solicitar eliminación. Cambiar información relevante requiere las verificaciones de identidad correspondientes. La eliminación debe indicar qué se suprime y si existe una obligación de conservación, con su fundamento y plazo. El perfil no muestra historial del cuestionario.

### Key Entities

Cuenta, nombre, correo, credenciales protegidas y autorización aplicable.

## Success Criteria *(mandatory)*

### Measurable Outcomes

Al menos 80 % de participantes completa registro (§15); muestra y condiciones pendientes.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Se conserva Android/iOS, público de 40–65 años e internet obligatorio (§§1–3).
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- Ninguna dependencia de implementación aprobada. Comparte el ciclo de cuenta con F02; navegación F03 y controles F08.
- Aplican §§11–17 del spec: minimización, conservación justificada, seguridad,
  accesibilidad, estados de error y trazabilidad. No se presumen proveedores ni plazos.

## Decisiones y aprobación pendientes

Pendientes originales asociados: PD-04, PD-05, PD-06, PD-09.
Consultar sus condiciones de cierre en §18 del spec fuente. Las brechas de pantalla
se resuelven en el registro del índice, sin modificar silenciosamente el original.
Antes de `$speckit-plan`, resolver los pendientes aplicables y obtener aprobación explícita de la constitución y de este spec. Separar el documento no constituye esa aprobación.

## Criterios de aceptación de acceso añadidos

- **CA-ACC-01:** Sin sesión, abrir Tips y cada una de sus cuatro categorías permite consultar contenido sin exigir cuenta.
- **CA-ACC-02:** Sin sesión, intentar abrir Inicio, Perfil, Zyro, Cuestionario o Resultados no muestra contenido protegido e informa que se requiere iniciar sesión.
- **CA-ACC-03:** Con una sesión válida se puede acceder a todas las funciones del alcance, sujeto a sus precondiciones; no se muestran resultados sin completar un intento.
- **CA-ACC-04:** Tras cerrar sesión, Tips sigue disponible y el contenido protegido deja de estarlo, incluido mediante retroceso; respuestas y resultados se descartan.
- **CA-ACC-05:** La navegación visible de P11 se conserva conforme al wireframe sin eludir las restricciones anteriores.

Estos criterios documentan la decisión; aún no son pruebas ejecutadas.
