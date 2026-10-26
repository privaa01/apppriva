# Feature Specification: F01 — Crear cuenta, iniciar sesión y recuperar acceso

**Feature Branch**: `work` (borradores de descomposición; sin rama de implementación)
**Created**: 2026-10-21
**Status**: Borrador de análisis; pendiente de aprobación de constitución y alcance.
**Input**: Descomponer el spec aportado y asociarlo a las pantallas del PDF.
**Fuentes**: [Spec original](../../referencias/PRIVA_MOBILE_SPEC.md), [PDF](../../referencias/app.pdf).

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
sin exigir implementar otras historias durante esta revisión documental.
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
contrarios a §5 y CA-03.1 (D16): se propone retirarlos, sin aprobar un cambio de regla.
No aprobar proveedor, caducidad ni sesión por defecto.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase el índice para el reparto F06/F07.

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
No se autoriza `$speckit-plan`, tareas ni implementación con este borrador.
