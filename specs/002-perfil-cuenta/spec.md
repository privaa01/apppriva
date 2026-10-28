# Feature Specification: F02 — Gestionar perfil, cerrar sesión y solicitar eliminación

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

### HU-02 — Gestionar mi cuenta (RF-02 y RF-04)

Como usuario, quiero gestionar mi cuenta para controlar mi información en Priva.

- **CA-02.1:** Al entrar en Perfil solo consulto y modifico información de mi propia cuenta, con las verificaciones necesarias.
- **CA-02.2:** Al cerrar sesión, deja de estar disponible el contenido protegido hasta un nuevo acceso.
- **CA-02.3:** Al solicitar eliminación, recibo información sobre alcance, procedimiento y conservación aplicable.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias conforme a esta especificación; las pruebas aún no se han ejecutado.
**Recorrido:** Perfil → consulta/gestión propia → confirmación o error; cerrar sesión; solicitud de eliminación con alcance informado.

### Edge Cases

Acceso a cuenta ajena; cambio sensible sin verificación; actualización fallida; conservación legal sin fundamento definido; cierre de sesión con cuestionario activo.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-02**: Permitir iniciar y cerrar sesión y recuperar el acceso mediante un mecanismo seguro. Cierre de sesión corresponde a F02; acceso y recuperación a F01.
- **RF-04**: Permitir consultar y gestionar datos de la propia cuenta y solicitar su eliminación.

### Asociación a pantallas

P12 (imagen corregida del 2026-10-26; sustituye la referencia visual de PDF 11); P10/P11 al terminar acceso protegido.

**Revisión 2026-10-26:** teléfono retirado del perfil; el usuario confirma que Priva
no pide número de teléfono. Esta exclusión es una decisión explícita, no un pendiente.
El diseño nuevo tampoco muestra «Estado de tus datos: Medio».

**Brechas observadas:** permanece una fila vacía cuya función no está definida; no
interpretarla como resultado ni añadir un campo sin requisito aprobado. Faltan edición,
solicitud de eliminación y ajuste de texto. No inferir conservación de resultados.

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

### 11. Privacidad, seguridad y conservación

### Marco y obligaciones

La política se fundamentará en la Ley 1581 de 2012 y su reglamentación aplicable, incluido el capítulo 25 del Decreto 1074 de 2015. La ley no fija una tabla universal de años para todos los datos. Los plazos deben responder a finalidades y obligaciones justificadas; una tabla por sí sola no acredita cumplimiento.

Antes de recoger datos, definir al responsable, finalidades, datos necesarios, autorizaciones aplicables, canales de atención y procedimientos para ejercer derechos. Conservar la prueba de autorización conforme a la normativa. Distinguir la supresión solicitada de las excepciones de conservación legal o contractual aplicables.

### Matriz inicial de conservación

| Categoría | Finalidad | Conservación y eliminación |
| --- | --- | --- |
| Nombre y correo | Identificación y acceso; justificación detallada pendiente | Durante la finalidad de cuenta, con evento y plazo final por aprobar. No asumir conservación indefinida. |
| Credenciales protegidas | Autenticación | Según sistema elegido y ciclo de cuenta; nunca contraseña legible. |
| Evidencia de autorización | Acreditar tratamiento autorizado | Plazo y fundamento por definir según obligaciones aplicables. |
| Respuestas y resultados | Autoevaluación educativa | Solo memoria temporal; eliminación según sección 9.7. |
| Mensajes del chat | Responder consultas | Plazo, ubicación y eliminación por definir tanto en Priva como en el proveedor. |
| Registros técnicos | Seguridad y operación | Minimizar datos; plazo justificado pendiente. Excluir respuestas y resultados del cuestionario. |
| Solicitudes de derechos | Atender consultas y reclamos | Plazo y fundamento por definir. |

La matriz definitiva debe incluir ubicación, responsable, método de eliminación, copias de seguridad y fundamento. No afirmar «el chat no guarda datos» hasta verificar los servicios utilizados. Si el proveedor trata datos fuera de Colombia, evaluar el régimen aplicable a la transferencia o transmisión y los acuerdos necesarios.

### Controles mínimos

- Conexiones cifradas y control de acceso a datos de cuenta.
- Contraseñas gestionadas mediante mecanismos seguros de autenticación.
- Credenciales de servicios protegidas, sin secretos embebidos en la app.
- Minimización de mensajes, analítica y registros; evitar información sensible innecesaria.
- Procesos verificables de eliminación y atención de incidentes.
- No enviar las respuestas del cuestionario al proveedor de IA para calcular resultados.

### Key Entities

Datos de la cuenta, solicitud de eliminación y obligaciones de conservación por definir; ningún historial del cuestionario.

## Success Criteria *(mandatory)*

### Measurable Outcomes

CA-02.1 a CA-02.3 satisfechos; ningún acceso a datos ajenos ni contenido protegido tras cerrar sesión en los casos de prueba aprobados.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Se conserva Android/iOS, público de 40–65 años e internet obligatorio (§§1–3).
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- Depende funcionalmente del acceso F01; ajuste de texto pertenece a F08.
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

## Alcance de plataforma vigente — 2026-10-28

Decisión explícita del usuario: «solo preparala para android». Esta entrega se
prepara únicamente para Android (mínimo API24 del plan); iOS, VoiceOver y Xcode
quedan fuera del alcance actual. Las menciones anteriores a ambas plataformas
son históricas. Se mantienen todos los requisitos funcionales, de privacidad y
seguridad aplicables a Android. No implica aprobación de otros specs ni entrega.
