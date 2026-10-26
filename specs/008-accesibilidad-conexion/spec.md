# Feature Specification: F08 — Lectura accesible y recuperación de conexión

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

### HU-08 — Personalizar lectura y recuperar conexión (RF-16 y RF-17)

Como usuario, quiero leer cómodamente y comprender los errores de conexión.

- **CA-08.1:** Al aumentar texto, el contenido sigue siendo legible y operable sin superposiciones.
- **CA-08.2:** Los colores se mantienen y los estados se distinguen también mediante texto o etiquetas.
- **CA-08.3:** Sin conexión se muestra un aviso y, al recuperarla, el reintento no duplica registros ni envíos.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias conforme a esta especificación; las pruebas aún no se han ejecutado.
**Recorrido:** Ajustar texto desde Perfil → contenido operable; sin conexión → aviso → reintento seguro. Aplicación transversal, no una decimotercera pantalla.

### Edge Cases

Texto grande; lector de pantalla; contraste insuficiente; teclado; tamaños móviles; solicitudes repetidas; desconexión con cuestionario activo.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-16**: Permitir ajustar el tamaño del texto manteniendo la paleta definida.
- **RF-17**: Mostrar aviso de falta de conexión y permitir reintentar sin duplicar operaciones.

### Asociación a pantallas

P12 para ajuste; P01–P12 para lectura, foco, teclado y errores.

**Brechas observadas:** No hay ajuste de texto ni estados de carga/error en el PDF; los diseños estáticos no prueban accesibilidad, foco, teclado ni compatibilidad.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase [el índice SDD](../README.md) para el reparto F06/F07.

### 12. Requisitos no funcionales y experiencia móvil

| ID | Requisito verificable o decisión pendiente |
| --- | --- |
| RNF-01 | Lenguaje comprensible para el público objetivo; validar con usuarios de 40 a 65 años. |
| RNF-02 | Permitir aumentar texto sin recortes, solapamientos ni controles inaccesibles; rango y tamaños de prueba por fijar. |
| RNF-03 | Controles con etiquetas accesibles, orden de foco coherente y resultados entendibles sin color; validar con lectores de pantalla. |
| RNF-04 | Mantener paleta visual definida y comprobar contraste suficiente; valores de aceptación por fijar antes de cerrar diseño. |
| RNF-05 | Ajustarse a distintos tamaños de móviles Android e iOS; matriz de dispositivos y versiones mínimas pendiente. |
| RNF-06 | Mostrar teclado al enfocar un campo editable y evitar que cubra mensaje o envío. |
| RNF-07 | Requerir internet y mostrar estados de carga, error y reintento. No se ofrece modo sin conexión. |
| RNF-08 | Aplicar temporalidad y controles de privacidad de las secciones 9 y 11. |
| RNF-09 | Definir presupuestos medibles para carga de vistas, respuesta de IA y expiración de solicitudes en el plan técnico; no se consideran cerrados todavía. |

### 13. Estados y errores

| Módulo | Estados y recuperación |
| --- | --- |
| Cuenta | Vacío, validación, enviando, éxito, fallo de acceso o conexión; corregir o reintentar. |
| Tips | Cargando, disponible, no disponible, error; reintentar. |
| Chat | Sin mensajes, escribiendo, procesando, respuesta, límite de alcance, información no verificada, error; reintentar. |
| Cuestionario | Inicio, pregunta pendiente, respondida, revisión, completado, interrumpido; nuevo intento cuando corresponda. |
| Resultado | Disponible temporalmente, descartado; realizar nuevo intento. |
| Perfil | Cargando, consulta, edición, validación, actualización o eliminación pendiente, error. |

Los mensajes deben indicar qué ocurrió y la acción posible sin revelar detalles internos ni datos de terceros.

### 14. Estrategia de pruebas

- **Funcionales:** cuenta completa, navegación, tips, consultas admitidas y rechazadas, reintentos y resultado.
- **Cuestionario:** selección sin duplicados, integridad de claves tras mezclar opciones, cobertura temática, respuestas obligatorias y fronteras del puntaje.
- **Interrupciones:** segundo plano, cierre, salida voluntaria, pérdida de red y retorno; comprobar descarte y ausencia de restauración.
- **Privacidad:** verificar que respuestas y resultados no aparecen en almacenamiento, analítica, registros ni copias. Auditar conservación del chat según proveedor.
- **Accesibilidad y compatibilidad:** texto ampliado, lector de pantalla, foco, teclado, diferentes móviles y versiones de la matriz aprobada.
- **Usabilidad:** participantes del público objetivo completan tareas y explican el significado del resultado sin interpretarlo como garantía.
- **Contenido:** revisar claves, explicaciones, guías y fechas; no confundir señales de alerta con pruebas concluyentes de fraude.

### 15. Métricas de éxito

Se mantienen las metas iniciales del documento base. Las mediciones se realizan mediante pruebas y datos agregados que no conserven respuestas individuales.

| Indicador | Meta | Método |
| --- | --- | --- |
| Participantes que completan registro | Al menos 80 % | Prueba de usuario. |
| Participantes que completan cuestionario | Al menos 70 % | Prueba de usuario. |
| Participantes que comprenden el resultado | Al menos 80 % | Pregunta de comprensión tras la tarea. |
| Participantes que comprenden los tips | Al menos 80 % | Prueba de comprensión. |
| Tareas completadas sin ayuda | Al menos 70 % | Prueba de usabilidad. |

Definir tamaño de muestra, denominador y condiciones antes de medir. No presentar estas metas como resultados obtenidos.

### Key Entities

Preferencia de lectura cuya persistencia no está definida; estado de conexión sin copiar respuestas del cuestionario.

## Success Criteria *(mandatory)*

### Measurable Outcomes

CA-08.1 a CA-08.3 satisfechos; tareas sin ayuda ≥70 % (§15); matriz móvil, rango de texto, contraste y tiempos pendientes.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Se conserva Android/iOS, público de 40–65 años e internet obligatorio (§§1–3).
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- Aplica a F01–F07; no reemplaza sus criterios. PD-10 debe resolverse antes de cerrar el comportamiento del cuestionario ante red.
- Aplican §§11–17 del spec: minimización, conservación justificada, seguridad,
  accesibilidad, estados de error y trazabilidad. No se presumen proveedores ni plazos.

## Decisiones y aprobación pendientes

Pendientes originales asociados: PD-07, PD-08, PD-10.
Consultar sus condiciones de cierre en §18 del spec fuente. Las brechas de pantalla
se resuelven en el registro del índice, sin modificar silenciosamente el original.
Antes de `$speckit-plan`, resolver los pendientes aplicables y obtener aprobación explícita de la constitución y de este spec. Separar el documento no constituye esa aprobación.
