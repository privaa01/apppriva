# Feature Specification: F08 — Lectura accesible y recuperación de conexión

**Feature Branch**: `work` (rama actual; la funcionalidad se selecciona por directorio)
**Created**: 2026-10-21
**Status**: Closed — implemented, tested and explicitly accepted by the responsible user on 2026-11-09.
**Separated**: 2026-10-26
**Input**: Especificar esta funcionalidad a partir de PRIVA_MOBILE_SPEC.md, sus pantallas y las decisiones explícitas del usuario.
**Fuentes**: [Spec original](../../docs/referencias/PRIVA_MOBILE_SPEC.md), [PDF](../../docs/referencias/app.pdf).

## Clarifications

### Session 2026-11-09

- Q: Cuando una persona cambie el tamaño del texto desde Perfil, ¿la aplicación debe recordar esa elección después de cerrarse o cerrar sesión? → A: Recordar el tamaño en el dispositivo, incluso después de cerrar la app o la sesión.
- Q: ¿Qué opciones de tamaño de texto debe mostrar Priva dentro de Perfil? → A: Pequeño 90 %, Normal 100 %, Grande 125 % y Muy grande 150 %.
- Q: Cuando se pierda Internet durante una operación, ¿cómo debe recuperarse la aplicación sin duplicar acciones? → A: Mostrar aviso, detener la operación y permitir reintentar manualmente cuando vuelva Internet.
- Q: ¿Qué partes de Priva deben seguir funcionando cuando no haya Internet? → A: Tips y Zyro local siguen funcionando; solo se bloquean las operaciones que realmente necesitan Internet.
- Q: ¿Qué nivel mínimo de contraste deben cumplir textos y controles para facilitar la lectura? → A: Contraste mínimo 4.5:1 para texto normal y 3:1 para texto grande y controles.

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

**Prioridad:** P1 aprobada para implementación transversal en Android.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias conforme a esta especificación; las pruebas aún no se han ejecutado.
**Recorrido:** Ajustar texto desde Perfil → contenido operable; sin conexión → aviso → reintento seguro. Aplicación transversal, no una decimotercera pantalla.

### Edge Cases

Texto grande; lector de pantalla; contraste insuficiente; teclado; tamaños móviles; solicitudes repetidas; doble toque en Reintentar; conexión que vuelve durante un reintento; desconexión con cuestionario activo.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-16**: Permitir ajustar el tamaño del texto desde Perfil mediante cuatro opciones: Pequeño 90 %, Normal 100 %, Grande 125 % y Muy grande 150 %. Normal es el valor inicial. Recordar la elección localmente en el dispositivo, incluso después de cerrar la app o la sesión, sin asociarla a la cuenta ni sincronizarla, y mantener la paleta definida.
- **RF-17**: Mostrar aviso de falta de conexión y permitir reintentar sin duplicar operaciones.
- **RF-17.a**: Ante una pérdida de Internet, detener la operación afectada, explicar qué ocurrió y ofrecer reintento manual cuando la conexión regrese. No reenviar automáticamente registros, cambios ni envíos.
- **RF-17.b**: Mantener disponibles sin Internet los Tips y el asistente Zyro local. Bloquear y mostrar recuperación solo en operaciones que requieren red; no crear una cola oculta para enviarlas posteriormente.

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
| RNF-02 | Permitir Pequeño 90 %, Normal 100 %, Grande 125 % y Muy grande 150 % sin recortes, solapamientos ni controles inaccesibles. |
| RNF-03 | Controles con etiquetas accesibles, orden de foco coherente y resultados entendibles sin color; validar con lectores de pantalla. |
| RNF-04 | Mantener la paleta visual y comprobar contraste mínimo 4.5:1 para texto normal y 3:1 para texto grande y controles. |
| RNF-05 | Ajustarse a Android API24 y API36 en 320×720 y 412×915 dp; iOS permanece fuera del alcance vigente. |
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

Preferencia de lectura local, no personal y persistente en el dispositivo; estado de conexión sin copiar respuestas del cuestionario.

## Success Criteria *(mandatory)*

### Measurable Outcomes

CA-08.1 a CA-08.3 satisfechos; las pantallas y acciones esenciales permanecen operables al 90 %, 100 %, 125 % y 150 %; contraste mínimo 4.5:1 para texto normal y 3:1 para texto grande/controles; matriz Android API24/API36 en 320×720 y 412×915; tareas sin ayuda ≥70 % (§15). Los presupuestos de tiempo se fijan en el plan.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Se conserva Android como plataforma vigente y el público de 40–65 años. Internet es obligatorio solo para las operaciones remotas; Tips y Zyro local permanecen disponibles sin conexión.
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- Aplica a F01–F07; no reemplaza sus criterios. PD-10 debe resolverse antes de cerrar el comportamiento del cuestionario ante red.
- Aplican §§11–17 del spec: minimización, conservación justificada, seguridad,
  accesibilidad, estados de error y trazabilidad. No se presumen proveedores ni plazos.

## Decisiones y aprobación

PD-07 queda resuelto con Android API24/API36 y 320×720/412×915 dp. PD-08 queda
resuelto con cuatro tamaños de texto y los umbrales de contraste aprobados. PD-10
conserva la regla aprobada en F06: una pérdida de conexión en primer plano pausa el
cuestionario en RAM; pasar a segundo plano lo descarta. Las demás operaciones remotas
se detienen y requieren reintento manual; Tips y Zyro local continúan disponibles.
Consultar sus condiciones de cierre en §18 del spec fuente. Las brechas de pantalla
se resuelven en el registro del índice, sin modificar silenciosamente el original.
Antes de `$speckit-plan`, resolver los pendientes aplicables y obtener aprobación explícita de la constitución y de este spec. Separar el documento no constituye esa aprobación.

## Alcance de plataforma vigente — 2026-10-28

Decisión explícita del usuario: «solo preparala para android». Esta entrega se
prepara únicamente para Android (mínimo API24 del plan); iOS, VoiceOver y Xcode
quedan fuera del alcance actual. Las menciones anteriores a ambas plataformas
son históricas. Se mantienen todos los requisitos funcionales, de privacidad y
seguridad aplicables a Android. No implica aprobación de otros specs ni entrega.
