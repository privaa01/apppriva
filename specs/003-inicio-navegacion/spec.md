# Feature Specification: F03 — Inicio y navegación según estado de sesión

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

### HU-03 — Navegar (RF-05)

Como usuario, quiero encontrar fácilmente las herramientas.

- **CA-03.1 (revisado):** Se conserva la navegación del wireframe de acceso; sin sesión solo se permite consultar Tips y sus detalles. El resto requiere autenticación.
- **CA-03.2:** Al elegir una sección, se abre su vista y se identifica la opción activa.
- **CA-03.3:** Al volver desde un detalle, regreso según el historial sin crear bucles de navegación.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias conforme a esta especificación; las pruebas aún no se han ejecutado.
**Recorrido:** Inicio → Tips, Zyro o Cuestionario; cabecera → Inicio/Perfil; retroceso según historial; salida de intento con advertencia y posibilidad de cancelar.

### Edge Cases

Control visible que concede contenido protegido sin sesión; retroceso en bucle; salida accidental del cuestionario; sección activa solo identificada por color.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-05**: Mostrar inicio y navegación conforme a la sección 5.

### Asociación a pantallas

P01–P09 y P12: PDF 1, 4, 6, 8, 9, 10, 5, 7, 3, 11; P11 conserva navegación según wireframe; no extender por inferencia ese diseño a P10.

**Brechas observadas:** Revisar etiquetas accesibles y estado activo. La navegación dibujada no prueba comportamiento ni autorización.

**Revisión visual 2026-10-26:** se conserva la navegación de P11 conforme al
wireframe y a la decisión del usuario. D16 queda resuelto: Tips es público y los
controles de las demás funciones no permiten abrir contenido sin autenticación.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase [el índice SDD](../README.md) para el reparto F06/F07.

### 5. Mapa de pantallas y navegación

El alcance contiene **12 pantallas**, incluida Crear cuenta. Las preguntas se presentan sucesivamente en una misma vista.

| ID | Pantalla | Contenido principal |
| --- | --- | --- |
| P01 | Inicio | Presentación y acceso a las herramientas. |
| P02 | Tips | Tarjetas de las cuatro categorías. |
| P03 | Contraseñas seguras | Recomendaciones, ejemplo y consejo. |
| P04 | Cuida lo que subes | Recomendaciones sobre exposición de información. |
| P05 | Enlaces sospechosos | Señales de alerta y acciones preventivas. |
| P06 | Perfiles falsos | Señales de alerta y límites de su interpretación. |
| P07 | Chat IA — Zyro | Conversación y orientación paso a paso. |
| P08 | Cuestionario | Una pregunta a la vez, selección única y progreso. |
| P09 | Resultados | Porcentaje, nivel, explicación y recomendaciones. |
| P10 | Crear cuenta | Nombre, correo, contraseña y autorización aplicable. |
| P11 | Iniciar sesión | Acceso y recuperación de credenciales. |
| P12 | Perfil | Consulta y gestión de la cuenta y tamaño del texto. |

### Reglas de navegación

- En todas las pantallas autenticadas se muestran Inicio y Perfil, y un menú inferior con Tips, Chat IA y Cuestionario.
- Iniciar sesión conserva la navegación del wireframe por decisión del usuario del 2026-10-26. Sin sesión solo Tips y sus detalles son accesibles; los controles protegidos requieren autenticación. No se modifica por inferencia el diseño de Crear cuenta.
- La sección activa se identifica visualmente y mediante etiquetas accesibles.
- El retroceso vuelve a la vista anterior según el historial. En el cuestionario permite revisar preguntas del intento activo y conserva temporalmente sus selecciones.
- Salir del cuestionario antes de finalizar descarta el intento. Debe informarse esta consecuencia y permitirse cancelar la salida.
- Los estados y acciones de recuperación de acceso y eliminación de cuenta pueden resolverse dentro de las vistas existentes; no se presupone una pantalla principal adicional.
- La aplicación no requiere abrir enlaces externos para presentar las guías de Zyro.

### Key Entities

Sección activa e historial de navegación; no constituyen historial persistente del cuestionario.

## Success Criteria *(mandatory)*

### Measurable Outcomes

CA-03.1 a CA-03.3 satisfechos; meta general de tareas sin ayuda ≥70 % (§15), con protocolo pendiente.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Se conserva Android/iOS, público de 40–65 años e internet obligatorio (§§1–3).
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- Requiere estado de sesión F01 y coordinación con descarte de F06/F07.
- Aplican §§11–17 del spec: minimización, conservación justificada, seguridad,
  accesibilidad, estados de error y trazabilidad. No se presumen proveedores ni plazos.

## Decisiones y aprobación pendientes

Pendientes originales asociados: ningún PD exclusivo; aplican los controles transversales y las brechas descritas.
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
