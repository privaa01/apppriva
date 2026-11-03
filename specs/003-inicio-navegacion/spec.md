# Feature Specification: F03 — Inicio y navegación según estado de sesión

**Feature Branch**: `work` (selección por directorio).
**Created**: 2026-10-21. **Updated**: 2026-11-03.
**Status**: Approved — revisión aprobada explícitamente por el usuario el 2026-11-03.
**SPECIFY_FEATURE_DIRECTORY**: `specs/003-inicio-navegacion`.
**Input**: «continuemos con el 003», después del cierre aprobado de F02.
**Gobierno**: [constitución v1.1.0](../../.specify/memory/constitution.md).
**Fuentes**: [original §§5, 6, 10 y 12](../../docs/referencias/PRIVA_MOBILE_SPEC.md),
[wireframes](../../docs/referencias/app.pdf),
[mapa de pantallas](../../docs/descomposicion/README.md),
[decisión sobre navegación de acceso](../../docs/referencias/ACTUALIZACION_PANTALLAS_2026-10-26.md).

## User Scenarios & Testing *(mandatory)*

### HU-03 — Navegar (RF-05) (Priority: P1, propuesta para aprobación)

Como usuario, quiero encontrar fácilmente las herramientas y comprender dónde
estoy, con acceso acorde al estado de mi sesión.

**Why this priority**: Inicio y los controles comunes conectan las funciones y
permiten encontrar Tips sin cuenta, preservando las restricciones ya aprobadas.
La prioridad se propone en esta revisión; no modifica prioridades de otras historias.

**Independent Test**: recorrer Inicio y los destinos de navegación con visitante,
cuenta no habilitada y sesión válida. Usar destinos controlados para módulos aún
no implementados, sin presentarlos como contenido terminado. Probar retroceso,
estado activo y pérdida de sesión; para las fronteras del cuestionario usar un
intento sintético temporal. No depende de generar contenido de F04–F07.

**Acceptance Scenarios**:

- **CA-03.1 (revisado):** Dada una vista autenticada, se muestran Inicio y Perfil
  en cabecera y Tips, Chat IA y Cuestionario en el menú inferior. P11 conserva los
  controles de su wireframe; su visibilidad no concede acceso protegido. No se
  extiende ese diseño a P10 por inferencia.
- **CA-03.2:** Al elegir una sección autorizada se abre su vista y se identifica
  la opción activa visualmente y mediante una etiqueta accesible de selección;
  el color por sí solo no es suficiente.
- **CA-03.3:** Al volver desde un detalle se retorna a su vista anterior, sin
  duplicaciones producidas por pulsar de nuevo la sección activa ni bucles que
  impidan salir mediante el retroceso del sistema.
- **CA-03.4:** Dada una sesión habilitada, Inicio presenta las tres herramientas
  Tips, Chat IA y Cuestionario conforme a P01; cada tarjeta y su control equivalente
  del menú llevan al mismo destino, sin prometer protección o ausencia de riesgos.
- **CA-03.5:** Si una persona visitante selecciona un destino protegido, se le
  informa que debe iniciar sesión y se ofrece el acceso; no ve contenido privado.
  Puede seguir consultando Tips y sus detalles sin crear cuenta.
- **CA-03.6:** Al perder o cerrar la sesión, ninguna vista privada ya abierta,
  ruta directa o entrada del historial conserva acceso; Tips sigue disponible.
  La cuenta no verificada o sin autorización exigida por F01 no obtiene acceso pleno.
- **CA-03.7:** Durante un intento activo, retroceder desde una pregunta posterior
  permite revisar la anterior conservando únicamente en memoria las selecciones.
  Al intentar salir del intento por Inicio, Perfil, Tips, Chat IA o retroceso desde
  la primera pregunta, se advierte el descarte y se permite cancelar. Cancelar
  conserva la vista y el intento; confirmar descarta y completa la salida solicitada.
- **CA-03.8:** Abandonar Resultados descarta el resultado. Segundo plano, cierre de
  app, cierre o pérdida de sesión descartan intento y resultado sin depender de
  responder a un diálogo. Volver no restaura ese estado. No se cierra la sesión
  de cuenta solamente por pasar a segundo plano.
- **CA-03.9:** Un destino desconocido o un resultado solicitado sin intento
  completado no muestran datos inventados ni privados y ofrecen volver a una
  vista permitida. Si un módulo aún no está entregado, se informa de su estado sin
  simular su contenido; ello no acredita haber completado dicho módulo.
- **CA-03.10:** Con lector de pantalla y texto al 200 %, se identifican los cinco
  controles comunes, su destino y su selección; ningún control esencial queda
  inaccesible ni depende de entender un icono sin etiqueta.

### Criterios de acceso preservados

- **CA-ACC-01:** Sin sesión se accede a Tips P02 y sus cuatro detalles P03–P06.
- **CA-ACC-02:** Inicio, Perfil, Zyro, Cuestionario y Resultados requieren acceso
  habilitado por F01; la ruta directa y el retroceso respetan esta restricción.
- **CA-ACC-03:** Una sesión válida habilita funciones del alcance sujeto a sus
  precondiciones; no hay Resultados sin completar un intento.
- **CA-ACC-04:** Cerrar sesión revoca acceso privado y descarta intento/resultado;
  Tips continúa disponible, también después de retroceder.
- **CA-ACC-05:** La navegación visible de P11 sigue su wireframe y las restricciones
  anteriores. No se ocultan sus controles como solución a la autorización.

Estos IDs conservan la decisión del 2026-10-26. No son nuevas pruebas ejecutadas.

### Edge Cases

- Pulsaciones repetidas sobre la sección activa o rápidas entre destinos: no
  apilar copias de una misma vista ni mostrar una selección distinta del contenido.
- Tips detalle P03–P06: Tips sigue identificado como activo. Resultados pertenece
  al recorrido Cuestionario. P11 no se identifica como una sección privada activa.
- Cambio de identidad durante la navegación: no trasladar vistas con datos propios
  de la cuenta anterior; reutilizar los límites de F01 y F02.
- Invalidación de sesión mientras hay un aviso de salida: prevalecen la revocación
  y el descarte; cancelar el aviso no recupera permisos ni respuestas.
- Navegación desde Perfil mientras se guarda: respetar el contrato de F02 de
  operación pendiente, sin declarar cancelada una escritura remota.
- Retroceso en una raíz sin historial anterior: permitir la salida normal de
  Android; no crear automáticamente un ciclo Inicio–Tips–Inicio.
- Pérdida de red durante un intento en primer plano: PD-10 sigue pendiente;
  F03 no decide pausa, continuación ni modo sin conexión.

## Requirements *(mandatory)*

### Functional Requirements

**RF-05**: mostrar Inicio y navegación conforme al mapa aprobado, con estos
subcriterios locales de trazabilidad (no sustituyen el ID original):

- **RF-05.a:** P01 presenta las tres herramientas y la cabecera/menú del wireframe;
  mantener sus destinos coherentes y el carácter educativo de los textos.
- **RF-05.b:** aplicar las reglas de acceso de F01 antes de mostrar cada destino,
  también al cambiar la sesión, abrir rutas directas y volver por el historial.
- **RF-05.c:** mantener una única selección coherente con la vista actual y un
  historial de navegación comprensible, sin duplicar al reseleccionar.
- **RF-05.d:** permitir retorno desde detalles; coordinar salida, confirmación y
  descarte temporal con F06/F07 y el principio III constitucional.
- **RF-05.e:** ofrecer mensajes sencillos de acceso requerido o destino no
  disponible, con una acción válida y sin exponer datos personales.
- **RF-05.f:** controles con nombre accesible, selección perceptible además del
  color, orden de lectura comprensible y soporte del texto ajustado del sistema.
- **RF-05.g:** no añadir persistencia del historial con respuestas/resultados,
  analítica de navegación, datos personales nuevos, permisos ni enlaces externos
  para abrir las herramientas internas.

### Asociación a pantallas y límites

| Pantallas | Responsabilidad F03 | Responsabilidad ajena |
| --- | --- | --- |
| P01 (PDF 1) | Presentación y acceso a las tres herramientas | Sin métricas de riesgo ni historial personal |
| P02–P06 (PDF 4, 6, 8, 9, 10) | Acceso público, sección Tips y retorno al catálogo | Contenido y tarjetas educativas F04 |
| P07 (PDF 5) | Destino protegido y selección Chat IA | Conversación, fuentes y proveedor F05 |
| P08–P09 (PDF 7, 3) | Acceso, sección Cuestionario y contrato de salida/descarte | Preguntas, puntuación, resultados y repetición F06/F07 |
| P10 | Conservar entrada de registro de F01 sin inferir menú nuevo | Alta y autorización F01 |
| P11 (imagen posterior) | Mantener cabecera/menú visible con Tips público | Acceso, verificación y recuperación F01 |
| P12 (PDF 11 e imagen corregida) | Destino Perfil y retorno sin eludir sus controles | Consulta, edición y cierre F02 |

No se crean pantallas principales nuevas. Los avisos y estados auxiliares pueden
resolverse dentro de las vistas existentes. La entrega de F03 no implica entregar
F04–F07: sus destinos controlados y pruebas de contrato deben distinguirse de los
recorridos reales, que se validarán de nuevo al integrar cada módulo.

**Propuesta editorial P01**, para aprobar con este spec: Tips, «Aprende hábitos
para cuidar tu información»; Chat IA, «Consulta a Zyro sobre privacidad y seguridad»;
Cuestionario, «Reflexiona sobre tus hábitos digitales». No incluir «fuera de riesgo»,
«nivel de protección» ni garantías de seguridad. La composición sigue el wireframe;
no se añade Zyro a ubicaciones no respaldadas por los diseños.

### Key Entities

- **Estado de acceso:** habilitación existente de F01; F03 lo consulta, no define
  nuevas identidades, sesiones ni plazos de conservación.
- **Destino y sección activa:** vista actual y grupo de navegación asociado.
- **Historial transitorio:** vistas anteriores necesarias para retroceder; nunca
  transporta respuestas, resultados ni datos privados hacia una sesión distinta.
- **Estado del recorrido temporal:** existencia de intento o resultado para decidir
  salida/descarte, sin persistir su contenido ni definir cómo se puntúa.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-03.1:** el 100 % de los casos de la matriz de destinos públicos/protegidos
  respeta CA-ACC-01–05 en visitante, cuenta no habilitada y sesión válida, incluidos
  acceso directo, retroceso e invalidación. Cero exposiciones privadas indebidas.
- **SC-03.2:** cada herramienta se abre desde P01 con una acción; tarjetas y menú
  coinciden en destino. Veinte reselecciones consecutivas no añaden copias de la
  vista activa; cada detalle vuelve a su catálogo y el retroceso puede salir.
- **SC-03.3:** en todos los recorridos sintéticos de CA-03.7/03.8, cancelar conserva
  el intento únicamente en memoria y confirmar o interrumpir lo descarta. Cero
  restauraciones de respuestas/resultados tras los eventos de descarte.
- **SC-03.4:** los cinco controles comunes se pueden identificar y activar con
  lector de pantalla y texto al 200 % en la matriz Android que apruebe el plan;
  ninguna acción esencial queda oculta o identificada solo por color.
- **SC-03.5:** al menos el 70 % de las tareas de encontrar una herramienta y volver
  se completa sin ayuda por personas de 40–65 años, según la meta del original §15.
  Antes de implementar, el plan debe aprobar muestra, recorridos, denominador y
  registro sanitizado del protocolo; no se presume una medición ya realizada.

## Assumptions

- Solo Android, conforme a la decisión ratificada del 2026-10-28. No se reabre iOS.
- Se reutilizan F01 y F02 aceptados con sus limitaciones documentadas; no se
  introducen nuevas reglas de autenticación, cambios de proveedor o de política.
- Se conserva la entrada de acceso existente para visitantes y el destino Inicio
  para sesiones habilitadas. No se introduce redirección automática posterior al
  acceso hacia una ruta privada previamente solicitada.
- No se añaden nuevas capacidades sin conexión. La regla de acceso público a Tips
  no implica que su contenido pueda consultarse sin red.
- F08 mantiene su alcance transversal. El plan debe concretar compatibilidad,
  contraste, objetivos táctiles, orden de foco y presupuestos de respuesta usando
  las decisiones aprobadas del proyecto; no se inventan métricas ya obtenidas.
- PD-01/02/03, conservación de chat y PD-10 siguen en sus specs. No impiden preparar
  navegación con destinos controlados, pero bloquean entregar la funcionalidad
  dependiente mientras no se resuelvan. No se cambia silenciosamente otro spec.

## Conflictos, trazabilidad y aprobación

| Fuente / conflicto | Propuesta y estado |
| --- | --- |
| Original §5 y CA-03.1 ocultan navegación en acceso | Decisión del usuario del 2026-10-26 prevalece: conservar P11, Tips público, resto protegido. Resuelto previamente. |
| Original P01 sugiere protección o ausencia de riesgo | Sustituir por la propuesta editorial educativa de esta revisión; pendiente de aprobación del spec. |
| Borrador incluye Android/iOS | Aplicar alcance Android ya ratificado; no constituye nueva decisión técnica. |
| Borrador no concreta salida del intento | Precisar cancelación frente a descarte y eventos de interrupción conforme a constitución III; no resolver PD-10 por inferencia. |
| Módulos dependientes aún no implementados | Separar pruebas de navegación con destinos controlados de aceptación funcional de F04–F07. |

| Requisito | Historia / criterios | Evidencia prevista |
| --- | --- | --- |
| RF-05.a | HU-03 / CA-03.1/03.4 | Comparación con P01/P11 y destinos de tarjetas/menú |
| RF-05.b | HU-03 / CA-03.5/03.6, CA-ACC-01–05 | Matriz de autorización positiva/negativa y cambios de sesión |
| RF-05.c | HU-03 / CA-03.2/03.3/03.9 | Historial, repetición, selección y destinos desconocidos |
| RF-05.d | HU-03 / CA-03.7/03.8 | Contrato sintético de salida y ciclo de vida; integración posterior F06/F07 |
| RF-05.e/f | HU-03 / CA-03.5/03.9/03.10 | Mensajes, lector de pantalla, texto ajustado y protocolo de uso |
| RF-05.g | HU-03 / CA-03.6/03.8 | Revisión de datos, almacenamiento y ausencia de captura de respuestas |

El 2026-11-03 el usuario solicitó continuar con F03 después de aprobar F02. Esto
permite preparar y revisar este spec; no aprueba su prioridad, propuesta editorial,
plan, tareas o implementación. Se solicita aprobación de esta versión antes del
plan técnico conforme al principio IX y a la puerta Spec de la constitución.

## Registro de aprobación — 2026-11-03

El usuario respondió «lo apruebo» a la revisión del commit `d8c4a55`. Quedan
aprobados el alcance de F03, la prioridad P1, los criterios y la propuesta editorial
de esa revisión. Se autoriza preparar el plan técnico, no generar o ejecutar tareas
ni implementar. El registro anterior de aprobación pendiente es histórico.
