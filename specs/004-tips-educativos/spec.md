# Feature Specification: F04 — Consultar las cuatro categorías de tips

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

### HU-04 — Consultar tips (RF-06)

Como usuario, quiero consultar recomendaciones para proteger mis datos.

- **CA-04.1:** Tips presenta las cuatro categorías y un control «Ver más» por categoría.
- **CA-04.2:** Al abrir una categoría veo su contenido, ejemplo y consejo revisados.
- **CA-04.3:** Si falla la carga, se muestra un error y una opción para reintentar.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias conforme a esta especificación; las pruebas aún no se han ejecutado.
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
no duplicación de responsabilidad; véase [el índice SDD](../README.md) para el reparto F06/F07.

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
Antes de `$speckit-plan`, resolver los pendientes aplicables y obtener aprobación explícita de la constitución y de este spec. Separar el documento no constituye esa aprobación.

## Criterios de aceptación de acceso añadidos

- **CA-ACC-01:** Sin sesión, abrir Tips y cada una de sus cuatro categorías permite consultar contenido sin exigir cuenta.
- **CA-ACC-02:** Sin sesión, intentar abrir Inicio, Perfil, Zyro, Cuestionario o Resultados no muestra contenido protegido e informa que se requiere iniciar sesión.
- **CA-ACC-03:** Con una sesión válida se puede acceder a todas las funciones del alcance, sujeto a sus precondiciones; no se muestran resultados sin completar un intento.
- **CA-ACC-04:** Tras cerrar sesión, Tips sigue disponible y el contenido protegido deja de estarlo, incluido mediante retroceso; respuestas y resultados se descartan.
- **CA-ACC-05:** La navegación visible de P11 se conserva conforme al wireframe sin eludir las restricciones anteriores.

Estos criterios documentan la decisión; aún no son pruebas ejecutadas.
