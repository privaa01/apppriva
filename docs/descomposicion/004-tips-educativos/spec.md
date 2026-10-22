# Feature Specification: F04 — Consultar las cuatro categorías de tips

**Feature Branch**: `work` (borradores de descomposición; sin rama de implementación)
**Created**: 2026-10-21
**Status**: Borrador de análisis; pendiente de aprobación de constitución y alcance.
**Input**: Descomponer el spec aportado y asociarlo a las pantallas del PDF.
**Fuentes**: [Spec original](../../referencias/PRIVA_MOBILE_SPEC.md), [PDF](../../referencias/app.pdf).

## User Scenarios & Testing *(mandatory)*

### HU-04 — Consultar tips (RF-06)

Como usuario, quiero consultar recomendaciones para proteger mis datos.

- **CA-04.1:** Tips presenta las cuatro categorías y un control «Ver más» por categoría.
- **CA-04.2:** Al abrir una categoría veo su contenido, ejemplo y consejo revisados.
- **CA-04.3:** Si falla la carga, se muestra un error y una opción para reintentar.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias durante esta revisión documental.
**Recorrido:** Tips → Ver más → detalle de categoría con recomendaciones, ejemplo y consejo → volver.

### Edge Cases

Contenido no disponible; fallo de carga; consejo engañoso; confundir HTTPS con garantía o indicios de perfiles con prueba de fraude.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-06**: Mostrar cuatro categorías de tips y su detalle con recomendaciones, ejemplo y consejo.

### Asociación a pantallas

P02 (PDF 4); P03 (6), P04 (8), P05 (9), P06 (10).

**Brechas observadas:** P05 necesita aclarar que HTTPS no demuestra legitimidad; P06 debe presentar indicios como señales, no conclusiones. Corregir lenguaje y ortografía sin cambiar alcance.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase el índice para el reparto F06/F07.

### Contenido y alcance de tips

Cuatro categorías: contraseñas seguras, cuida lo que subes, enlaces sospechosos y perfiles falsos. Cada detalle presenta recomendaciones, ejemplo y consejo revisados (§§5–6 y HU-04).

### Key Entities

Categoría, contenido, ejemplo, consejo y revisión editorial; no se aprueba una herramienta de administración.

## Success Criteria *(mandatory)*

### Measurable Outcomes

Cuatro categorías accesibles y CA-04.1 a CA-04.3 satisfechos; comprensión de tips ≥80 % (§15), protocolo pendiente.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Se conserva Android/iOS, público de 40–65 años e internet obligatorio (§§1–3).
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- Navegación F03, accesibilidad/conectividad F08 y controles editoriales transversales.
- Aplican §§11–17 del spec: minimización, conservación justificada, seguridad,
  accesibilidad, estados de error y trazabilidad. No se presumen proveedores ni plazos.

## Decisiones y aprobación pendientes

Pendientes originales asociados: ningún PD exclusivo; aplican los controles transversales y las brechas descritas.
Consultar sus condiciones de cierre en §18 del spec fuente. Las brechas de pantalla
se resuelven en el registro del índice, sin modificar silenciosamente el original.
No se autoriza `$speckit-plan`, tareas ni implementación con este borrador.
