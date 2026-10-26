# Feature Specification: F03 — Inicio y navegación autenticada

**Feature Branch**: `work` (borradores de descomposición; sin rama de implementación)
**Created**: 2026-10-21
**Status**: Borrador de análisis; pendiente de aprobación de constitución y alcance.
**Input**: Descomponer el spec aportado y asociarlo a las pantallas del PDF.
**Fuentes**: [Spec original](../../referencias/PRIVA_MOBILE_SPEC.md), [PDF](../../referencias/app.pdf).

## User Scenarios & Testing *(mandatory)*

### HU-03 — Navegar (RF-05)

Como usuario, quiero encontrar fácilmente las herramientas.

- **CA-03.1:** Las vistas autenticadas muestran Inicio, Perfil y menú inferior; registro y acceso no los muestran.
- **CA-03.2:** Al elegir una sección, se abre su vista y se identifica la opción activa.
- **CA-03.3:** Al volver desde un detalle, regreso según el historial sin crear bucles de navegación.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias durante esta revisión documental.
**Recorrido:** Inicio → Tips, Zyro o Cuestionario; cabecera → Inicio/Perfil; retroceso según historial; salida de intento con advertencia y posibilidad de cancelar.

### Edge Cases

Registro o acceso con menú protegido; retroceso en bucle; salida accidental del cuestionario; sección activa solo identificada por color.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-05**: Mostrar inicio y navegación conforme a la sección 5.

### Asociación a pantallas

P01–P09 y P12: PDF 1, 4, 6, 8, 9, 10, 5, 7, 3, 11; exclusión P10/P11.

**Brechas observadas:** Revisar etiquetas accesibles y estado activo. La navegación dibujada no prueba comportamiento ni autorización.

**Revisión visual 2026-10-26:** la nueva P11 sí muestra Inicio, Perfil y menú
inferior. Esto contradice la exclusión de §5 y CA-03.1 (D16). Se propone retirarlos
de la vista de acceso; su aparición en la imagen no aprueba navegación sin sesión.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase el índice para el reparto F06/F07.

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
- Crear cuenta e Iniciar sesión no muestran dicha navegación.
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
No se autoriza `$speckit-plan`, tareas ni implementación con este borrador.
