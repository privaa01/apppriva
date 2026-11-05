# Feature Specification: F04 — Consultar las cuatro categorías de Tips

**Feature Branch**: `work` (selección por directorio).
**Created**: 2026-10-21. **Updated**: 2026-11-04.
**Status**: Alcance, textos A1–A5 y plan técnico aprobados; contraste externo de fuentes pendiente. Sin implementación ni aceptación de entrega.
**SPECIFY_FEATURE_DIRECTORY**: `specs/004-tips-educativos`.
**Input**: «continua con la 004», después del cierre aprobado de F03.
**Gobierno**: [constitución v1.1.0](../../.specify/memory/constitution.md).
**Fuentes**: [original §§5, 6, HU-04, 12 y 15](../../docs/referencias/PRIVA_MOBILE_SPEC.md),
[wireframes PDF](../../docs/referencias/app.pdf),
[mapa de pantallas y brechas](../../docs/descomposicion/README.md),
[decisiones de acceso](../../docs/referencias/ACTUALIZACION_PANTALLAS_2026-10-26.md).

## User Scenarios & Testing *(mandatory)*

### HU-04 — Consultar Tips (RF-06) (Priority: P1)

Como usuario, quiero consultar recomendaciones para proteger mis datos y comprender
sus límites, sin tener que crear una cuenta.

**Why this priority**: Tips es la herramienta pública de Priva para personas de
40–65 años. Sustituye los marcadores de navegación por contenido educativo revisado
sin depender de entregar el chat o el cuestionario. Prioridad de esta entrega de Tips.

**Independent Test**: como visitante y con sesión válida, abrir el catálogo y cada
categoría, revisar recomendaciones/ejemplo/consejo y volver. Forzar carga fallida,
contenido incompleto y reintento; comprobar texto ajustado, lector de pantalla y
límites editoriales. No requiere implementar F05–F07 ni evaluar una cuenta externa.

**Acceptance Scenarios**:

- **CA-04.1:** Tips presenta exactamente las cuatro categorías aprobadas y un control
  «Ver más» por categoría. Cada control se identifica también por su categoría para
  quien usa lector de pantalla; no hay cuatro acciones indistinguibles.
- **CA-04.2:** Al abrir una categoría se muestran título, recomendaciones, ejemplo
  ficticio y consejo revisados que corresponden a ella. No se mezclan contenidos
  de otra categoría ni se muestran ejemplos como información de la persona.
  «Ver ejemplo» revela la explicación educativa de esa categoría dentro del detalle,
  sin abrir enlaces externos ni duplicar contenido al activarlo repetidamente.
- **CA-04.3:** Si falla la carga, se muestra un error sencillo y una opción para
  reintentar el mismo destino. El fallo no se presenta como éxito o contenido vacío
  normal, no exige iniciar sesión para recuperarse y no expone detalles técnicos.
- **CA-04.4:** Visitante, cuenta aún no habilitada y sesión válida pueden consultar
  P02–P06 y sus rutas directas. El contenido y sus recomendaciones no cambian según
  nombre, correo, respuestas del cuestionario o conversaciones.
- **CA-04.5:** Al volver desde un detalle se muestra el catálogo sin bucles ni copias
  producidas por reseleccionar Tips. Tips se mantiene activo en los cuatro detalles,
  visualmente y para el lector de pantalla, usando los contratos de F03.
- **CA-04.6:** Mientras se espera contenido se muestra carga comprensible. Un registro
  ausente, desconocido o incompleto produce indisponibilidad con acción recuperable,
  no texto inventado ni el contenido de otra categoría como sustituto silencioso.
- **CA-04.7:** El material de enlaces explica que HTTPS cifra la conexión y no
  garantiza que el sitio sea legítimo. No identifica un enlace real como seguro o
  fraudulento ni ejecuta comprobaciones sobre enlaces de la persona.
- **CA-04.8:** El material de perfiles presenta señales como motivos para verificar
  o limitar interacción, no como prueba de fraude. Pocos seguidores, antigüedad o
  pocas publicaciones no bastan para concluir que un perfil es falso.
- **CA-04.9:** Los ejemplos son ficticios y consultables dentro de Priva, sin pedir
  contraseñas, fotos, ubicación, cuentas o enlaces de la persona. Ningún ejemplo
  requiere abrir una web externa, subir archivos o dar permisos al dispositivo.
- **CA-04.10:** Cada categoría entregada tiene contenido final aprobado y un registro
  editorial con fuentes identificables, fecha de revisión y versión. Una propuesta
  o una frase del wireframe no constituye por sí sola material revisado. Un cambio
  de contenido actualiza esa evidencia y sus pruebas antes de entregarse.
- **CA-04.11:** Texto al200% y lector de pantalla permiten recorrer catálogo, leer el
  detalle, activar su acción y volver sin ocultar contenido/acciones. El estado de
  carga/error/reintento es comprensible y el color no es la única señal.
- **CA-04.12:** Consultar o reintentar no registra historial de lectura, categorías
  visitadas, datos de cuenta ni respuestas/resultados. No incorpora favoritos,
  personalización, analítica de uso o un formulario para evaluar casos personales.

### Criterios de acceso preservados

- **CA-ACC-01:** Sin sesión se consulta Tips P02 y sus cuatro detalles P03–P06.
- **CA-ACC-02:** Los controles Inicio/Perfil/Chat IA/Cuestionario y Resultados siguen
  sujetos a F01/F03: sin acceso habilitado no muestran contenido protegido.
- **CA-ACC-03:** Una sesión válida habilita funciones sujetas a sus precondiciones;
  entregar Tips no implementa el chat ni habilita Resultados sin intento completado.
- **CA-ACC-04:** Al cerrar sesión, Tips sigue disponible; contenido protegido deja
  de estarlo y el estado temporal de cuestionario/resultados se descarta según F03.
- **CA-ACC-05:** P11 conserva la navegación del wireframe sin eludir restricciones.
  F04 no modifica registro, acceso, recuperación, Perfil o restauración de sesión.

Los IDs provienen de decisiones aprobadas; aquí se especifica su integración con
Tips, sin declarar pruebas ejecutadas de esta funcionalidad.

### Edge Cases

- Una URL directa a categoría desconocida no abre contenido de ejemplo ni convierte
  un destino arbitrario en una sección pública; aplicar el catálogo cerrado de F03.
- Pulsar varias veces «Ver más» o Reintentar no duplica vistas/contenido; una respuesta
  tardía no reemplaza el detalle que la persona eligió después.
- Falla la comprobación de cuenta, pero Tips puede cargarse: no transformar una
  herramienta pública en una pantalla que obligue a registrarse.
- Falla la red o el servicio de contenido: mostrar el estado recuperable sin prometer
  un modo sin conexión o que las recomendaciones se encuentran actualizadas.
- Fuentes o contenido inválidos/incompletos no se publican como revisados; las pruebas
  deben distinguir el caso de un material válido que no pudo cargarse.
- Ejemplo de contraseña enmascarado: explicar su carácter ilustrativo, sin presentarlo
  como una contraseña de la persona o una herramienta para generar/evaluar claves.
- Ejemplo de foto o perfil: ilustración ficticia, sin rostros, documentos o información
  reales que se recolecten de usuarios para demostrar funcionamiento.
- Referencia o URL ilustrativa: texto no accionable y sin dominio real que la persona
  deba visitar para completar el recorrido. No inferir un escáner por mostrarla.

## Requirements *(mandatory)*

### Functional Requirements

**RF-06**: mostrar cuatro categorías y sus detalles con recomendaciones, ejemplo y
consejo. Subcriterios locales para trazar tareas y pruebas, sin sustituir el ID:

- **RF-06.a:** ofrecer las cuatro categorías con título reconocible, resumen breve
  y «Ver más» claramente asociado a cada una, respetando la composición de P02.
- **RF-06.b:** entregar un detalle coherente por categoría con recomendaciones,
  ejemplo ficticio y consejo legibles, sin formularios, captura ni evaluación de datos.
- **RF-06.c:** mantener acceso público, rutas conocidas, selección Tips y retorno
  de F03; el contenido no depende de tener perfil ni de completar otra herramienta.
- **RF-06.d:** contemplar carga, error, indisponibilidad y reintento del mismo destino,
  sin confundir fallos con éxito ni revelar datos o excepciones de servicios.
- **RF-06.e:** cumplir las reglas editoriales y demostrar revisión/versionado/fuentes
  antes de implementar el material que se entregará. No usar promesas de protección.
- **RF-06.f:** soportar texto ajustado del sistema, lector de pantalla, foco, etiquetas
  específicas y señales comprensibles; concretar matriz/umbrales en el plan.
- **RF-06.g:** no añadir finalidades, permisos, historial o datos personales; conservar
  ejemplos y pruebas sintéticos sin recolectar respuestas/resultados del cuestionario.

### Asociación a pantallas y dirección editorial

| Pantalla / PDF | Categoría / contenido obligatorio | Límites de la revisión propuesta |
| --- | --- | --- |
| P02 /4 | Catálogo de las cuatro categorías y «Ver más» | Corregir ortografía, conservar identidad visual; no añadir búsqueda, filtros o categorías |
| P03 /6 | Contraseñas seguras: recomendaciones, ejemplo y consejo | Contraseñas largas/únicas y sin datos personales; no recomendar reutilizar una clave cambiando orden o símbolos ni confundir la política de acceso de Priva con una regla universal |
| P04 /8 | Cuida lo que subes: recomendaciones, ejemplo y consejo | Pensar antes de publicar, revisar audiencia y exposición; no afirmar borrado universal o imposibilidad absoluta de retirar información |
| P05 /9 | Enlaces sospechosos: recomendaciones, ejemplo y consejo | HTTPS no acredita legitimidad; atención a presión/remitente/destino y canales conocidos, sin clasificador ni URL real para visitar |
| P06 /10 | Perfiles falsos: recomendaciones, ejemplo y consejo | Señales orientativas y verificación por canal conocido, sin certificar personas ni concluir fraude por seguidores o antigüedad |

Esta tabla propone la dirección editorial para aprobación del spec; no acredita
que los textos finales ya tengan revisión de fuentes. El catálogo editorial final
(textos exactos, ejemplos, consejos, referencias, versión y revisión del responsable
del proyecto) será un artefacto concreto del plan, presentado para aprobar antes de
implementar. No se aprueba copiar automáticamente recomendaciones del PDF.

**Contenido excluido:** generador/medidor de contraseñas, apertura o análisis de
URLs/perfiles externos, acceso a fotos/ubicación/contactos, uploads, favoritos,
historial de lectura, resultados personalizados, IA generativa para producir Tips,
CMS/panel de administración y nuevos formularios. Las fuentes editoriales no implican
exigir enlaces externos para leer las guías. No añadir Zyro a pantallas no sustentadas
por el diseño; cualquier recurso debe ser ilustrativo y contar con uso autorizado.

### Key Entities

- **Categoría:** identidad estable, título y resumen, asociada a un único detalle.
- **Detalle educativo:** recomendaciones, ejemplo ficticio y consejo de una categoría;
  contenido común para todos, sin relaciones con cuentas o intentos de cuestionario.
- **Revisión editorial:** versión del material, fuentes, fecha de comprobación y
  aprobación del responsable; no es un historial de consultas de la persona.
- **Estado de consulta:** catálogo/detalle solicitado, carga/resultado/error/
  indisponibilidad y posibilidad de reintento; no presupone persistencia de visitas.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-04.1:** se muestran exactamente4 categorías; el100% de sus accesos y rutas
  directas permitidas funcionan con visitante y sesión válida. Cero exigencias de
  cuenta para leer Tips y cero aperturas privadas indebidas desde sus controles.
- **SC-04.2:** los4 detalles contienen recomendaciones, ejemplo y consejo coherentes;
  el100% del material entregado tiene aprobación editorial y fuentes/revisión
  registradas. Cero afirmaciones que equiparen HTTPS o señales de perfil con certeza.
- **SC-04.3:** todos los escenarios previstos de carga fallida, registro ausente o
  incompleto y reintento muestran su estado correcto y permiten recuperarse o volver;
  sin duplicaciones ni sustitución por contenido inventado/de otra categoría.
- **SC-04.4:** en la matriz Android que apruebe el plan, catálogo, detalle, error y
  reintento se leen/operan con lector de pantalla y texto200%, sin ocultar acciones
  esenciales ni depender solo del color. Los4 controles «Ver más» se distinguen.
- **SC-04.5:** al menos80% de los participantes de40–65años comprenden los Tips según
  la meta del original §15: identifican una acción preventiva por categoría y los
  límites de interpretar HTTPS/perfiles. El plan definirá antes de implementar
  muestra, preguntas, rúbrica y denominador por participante, sin guardar respuestas
  individuales ni presentar una prueba automática como medición con personas.

Las metas son requisitos para validar, no resultados ya obtenidos. No se trasladan
las excepciones de cierre de F03 como aprobación de controles de F04.

## Assumptions

- Solo Android conforme a la decisión ratificada del2026-10-28; público40–65años.
- Se mantiene internet obligatorio, sin modo offline nuevo. La ubicación, distribución
  y recuperación del contenido se decidirán en el plan, sin escoger proveedor aquí.
- Se reutilizan navegación/sesión de F03 y guardas F01. El cierre de F03 conserva
  sus límites de evidencia; F04 generará pruebas propias de integración y regresión.
- Accesibilidad/conectividad F08 siguen siendo transversales. El plan concretará
  contraste, objetivos táctiles, geometrías, versiones y presupuestos de respuesta
  conforme a las decisiones ya aprobadas, sin prometer todos los dispositivos.
- Secciones escritas e imágenes son antecedentes: no justifican recopilar datos
  porque se vea una foto, contraseña enmascarada, perfil o enlace en el diseño.
- Banco/puntuación F06/F07, proveedor y guías Zyro F05 y PD-10 de desconexión durante
  intento no se resuelven con Tips ni bloquean su lectura pública independiente.
- No hay un PD de negocio exclusivo de F04 por resolver en este spec. Los textos,
  fuentes, protocolo y decisiones técnicas se concretarán como parte del plan para
  revisión, sin implementar contenidos aún no aprobados.

## Conflictos, trazabilidad y aprobación

Contraste textual del PDF y mapa existente: conservar jerarquía de catálogo/detalles,
corregir lenguaje engañoso sin atribuir al wireframe requisitos nuevos.

| Fuente / brecha | Tratamiento propuesto |
| --- | --- |
| P02 «concejos», «cuidartu» y otras erratas | Redacción sencilla y corregida, sin cambiar las cuatro categorías |
| P03 «cambia el orden, utiliza caracteres distintos» | Evitar enseñar variaciones de una clave reutilizada; apoyar la redacción final en fuentes revisadas |
| P04 «puede quedarse para siempre» | Explicar posibles copias/redistribución sin certezas absolutas o promesas de eliminación |
| P05 «enlace seguro» por HTTPS y URL defectuosa | Explicar cifrado frente a legitimidad y usar ilustración inerte, sin enlaces de prueba reales |
| P06 seguidores/antigüedad como detección de falsedad | Presentarlos solo como contexto insuficiente para concluir fraude |
| Borrador histórico Android/iOS | Aplicar Android ya ratificado; no reabrir otra plataforma |
| Diseños sin estados de carga/error | Especificar recuperación y accesibilidad, sin suponer un backend o eliminar CA-04.3 |

| Requisito | Historia / criterios | Evidencia prevista |
| --- | --- | --- |
| RF-06.a/b | HU-04 / CA-04.1/04.2 | Catálogo,4 detalles, comparación textual/visual y registro editorial |
| RF-06.c | HU-04 / CA-04.4/04.5, CA-ACC-01–05 | Matriz público/sesión, rutas y retorno, regresión F01–F03 |
| RF-06.d | HU-04 / CA-04.3/04.6 | Fallos/ausencia/incompleto/reintento y respuesta tardía |
| RF-06.e | HU-04 / CA-04.7–04.10 | Fuentes fechadas, texto aprobado y revisión de límites |
| RF-06.f | HU-04 / CA-04.11 | Lector de pantalla, texto ajustado y acciones accesibles |
| RF-06.g | HU-04 / CA-04.9/04.12 | Revisión de datos, permisos y ausencia de historial/captura |
| SC-04.1–04.5 | HU-04 | Matriz de aceptación, cobertura editorial y protocolo de comprensión |

**Registro anterior, previo a recibir los textos:** el2026-11-04 el usuario solicitó continuar con F04. Esa solicitud autorizaba revisar el spec,
sin aprobar automáticamente esta prioridad, dirección editorial, plan o tareas. El registro posterior delimita lo confirmado después.
Antes de `$speckit-plan`, obtener aprobación de esta revisión según constitución IX.
No se generan tareas, cambian reglas Firebase o implementan pantallas en esta etapa.


## Decisión del responsable — 2026-11-04

El usuario confirmó «sí» al alcance de las cuatro categorías y aportó los textos
exactos de cada una, incluyendo recomendaciones, ejemplos, explicaciones,
consejos e iconografía sugerida. Indicó «conserva el diseño, y hazlo todo según
los wireframes». Se registra la aprobación de ese alcance y preferencia visual;
no se le vuelve a solicitar una confirmación genérica de esos puntos.

Los textos quedan conservados en [contenido-editorial.md](contenido-editorial.md).
Sustituyen las redacciones históricas del PDF; se conserva su composición visual.
P02 se contrastó visualmente con la página4 y P03 con la página6 del PDF en esta
revisión. No se presenta esta inspección como prueba de pantallas implementadas.

Quedan propuestas concretas A1–A5: completar la explicación de contraseña,
usar dominio reservado e inerte, explicar HTTPS, precisar el límite de pocas
publicaciones y evitar una promesa absoluta sobre otras cuentas. No se atribuye
aprobación de estas frases nuevas al mensaje que aportó los textos originales.
CA-04.7–04.10 mantienen sus exigencias; revisión de fuentes y planificación siguen
pendientes. No se ha aprobado un plan que todavía no existe ni se generan tareas
o código en esta revisión documental.


## Aprobación editorial y apertura de planificación — 2026-11-04

El responsable contestó «si los apruebo» a la lista concreta A1–A5 presentada
después de confirmar categorías, textos y fidelidad a wireframes. Se registran
como aprobados los cinco ajustes y se incorpora su versión final en
[contenido-editorial.md](contenido-editorial.md), versión1.0.0. Este registro
sustituye el estado pendiente de esos ajustes en la entrada anterior.

La solicitud de continuar con F04 y esta aprobación permiten preparar el plan
anunciado. No aprueban por anticipado arquitectura, matriz/protocolo ni un plan
que el responsable no ha revisado. El contraste externo de fuentes permanece
visible en [fuentes-editoriales.md](fuentes-editoriales.md); no modifica lo
aprobado por el usuario ni se presenta como validación de producto.


## Aprobación del plan técnico — 2026-11-05

El responsable expresó su acuerdo con el plan F04 y reiteró conservar wireframes,
cuatro categorías, «Ver ejemplo» y demás comportamientos propuestos. Se registra
la aprobación en [plan.md](plan.md), sin alterar contenido ni alcance. La revisión
externa de fuentes continúa bloqueada; no se considera dispensada por esa aprobación.
El desglose [tasks.md](tasks.md) es preparación documental, no evidencia de ejecución.
