# Feature Specification: F07 — Comprender el resultado orientativo y repetir

**Feature Branch**: `work` (rama actual; la funcionalidad se selecciona por directorio)
**Created**: 2026-10-21
**Status**: Approved — spec y catálogo aprobados explícitamente por el responsable el 2026-11-07.
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

### HU-07 — Consultar resultados y repetir (RF-12 a RF-15)

Como usuario, quiero comprender el resultado y recibir acciones útiles.

- **CA-07.1:** Solo después de diez respuestas se muestra el promedio simple de los diez porcentajes asociados a las opciones elegidas.
- **CA-07.2:** El promedio exacto se clasifica: menor de 20 % bajo, desde 20 % y menor de 60 % medio, y desde 60 % alto; se presenta con un decimal solo cuando sea necesario.
- **CA-07.3:** El resultado muestra porcentaje, nivel en texto, explicación, aviso orientativo y acciones revisadas para los tres módulos con mayor promedio.
- **CA-07.4:** Repetir crea una nueva selección, sin prometer que todas las preguntas cambien.
- **CA-07.5:** No existe historial persistente de respuestas o resultados, tampoco en registros técnicos.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias conforme a esta especificación; las pruebas aún no se han ejecutado.
**Recorrido:** Diez respuestas → porcentaje y nivel educativos → recomendaciones vinculadas → repetir con selección nueva; descarte según §9.7.

### Edge Cases

Resultado parcial; fronteras 19/20 y 59/60; empate entre módulos; promedio con decimal; 0 % confundido con protección garantizada; persistencia en Perfil; repetición con preguntas coincidentes.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-12**: Calcular el resultado únicamente después de responder las diez preguntas.
- **RF-13**: Mostrar porcentaje de riesgo orientativo, nivel y recomendaciones relacionadas con las respuestas.
- **RF-14**: Permitir repetir el cuestionario mediante una nueva selección aleatoria.
- **RF-15**: Descartar respuestas y resultados según las reglas de temporalidad de la sección 9.

### Asociación a pantallas

P09 (PDF 3); repetición → P08 (PDF 7).

**Brechas resueltas/propuestas:** «Tu diagnóstico» se sustituye por «Resultado orientativo» y no se presenta como garantía. El 50 % del mockup es solo ejemplo. P09 debe incluir aviso, nivel textual, tres módulos prioritarios, acciones revisadas y Repetir cuestionario.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase [el índice SDD](../README.md) para el reparto F06/F07.

### 9. Cuestionario y resultados

### 9.1 Naturaleza de la evaluación

El resultado resume respuestas declaradas y no mide el dispositivo ni predice una filtración. Aviso obligatorio: **«Este resultado es orientativo y se basa en tus respuestas. No mide la probabilidad real de que se filtren tus datos».**

### 9.2 Entrada aprobada desde F06

F07 recibe en RAM un `CompletedAttempt` con diez preguntas, exactamente dos de cada módulo, una selección por pregunta y el porcentaje 0–100 asociado a cada opción. No lee el asset por separado para reconstruir respuestas, no acepta intentos parciales y no envía contenido a IA o backend.

### 9.3 Fórmula aprobada — 2026-11-07

**Porcentaje orientativo = suma de los porcentajes de las diez opciones elegidas ÷ 10.**

Todas las respuestas pesan igual. El cálculo usa el valor exacto; la interfaz muestra un decimal únicamente cuando el promedio no es entero. No se redondea antes de clasificar. Ejemplos: suma 375 → 37,5 %; suma 600 → 60 %.

| Promedio exacto | Nivel |
| --- | --- |
| 0 % ≤ promedio < 20 % | Bajo |
| 20 % ≤ promedio < 60 % | Medio |
| 60 % ≤ promedio ≤ 100 % | Alto |

Estos rangos completan los huecos del PDF por decisión explícita del responsable. El porcentaje sigue siendo educativo; 0 % no garantiza ausencia de riesgo.

### 9.4 Prioridad por módulo y empates

Se calcula también el promedio de las dos respuestas de cada módulo. P09 presenta los tres módulos con mayor promedio, en orden descendente. En empate se usa este orden estable: contraseñas; autenticación y acceso; redes y conectividad; phishing e ingeniería social; dispositivos y actualizaciones. El desempate solo ordena la presentación y no cambia el porcentaje ni el nivel.

### 9.5 Recomendaciones revisadas

Cada módulo prioritario muestra su nombre y las acciones fijas aprobadas en `catalogo-recomendaciones.md`. No se afirma que una acción resuelva todos los riesgos ni se inventa una recomendación por respuesta. Los otros dos módulos no se muestran para evitar una pantalla extensa.

### 9.6 Repetición

«Repetir cuestionario» descarta primero el resultado y el intento completado y abre P08 con un intento nuevo. F06 realiza otra selección aleatoria; puede repetir preguntas y no se promete un banco completamente distinto. Doble toque no crea dos intentos.

### 9.7 Temporalidad e interrupciones

- Las respuestas solo existen temporalmente durante el intento activo; no se guardan en bases de datos, archivos, analítica, registros de errores ni copias de seguridad.
- El procesamiento del cuestionario puede realizarse en memoria del dispositivo; no requiere enviar respuestas a la IA.
- Al terminar, se conserva en memoria únicamente lo necesario para mostrar el resultado y sus recomendaciones.
- Al abandonar el intento, pasar a segundo plano, cerrar la app o cerrar sesión, se descarta el estado del cuestionario y el resultado.
- Al regresar, debe iniciarse un nuevo intento; no se restaura el anterior.
- Reiniciar el cuestionario no significa cerrar automáticamente la sesión de cuenta.
- Antes de empezar, informar que una interrupción obliga a responder nuevamente.
- Ante pérdida de conexión en primer plano, conservar el resultado solo en RAM; al pasar a segundo plano, descartar. Esta regla fue aprobada y aplicada en F06.

### Key Entities

Resultado y recomendaciones temporales; no historial, almacenamiento, analítica ni logs con respuestas o resultados.

## Success Criteria *(mandatory)*

### Measurable Outcomes

CA-07.1 a CA-07.5 verificados con fronteras 19/20 y 59/60, promedios enteros/decimales y empates; comprensión objetivo ≥80 % (§15), protocolo pendiente. Las metas no se presentan como resultados obtenidos.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Android únicamente, mínimo API 24 vigente, público de 40–65 años e internet obligatorio.
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- Depende del intento completo F06. Comparte sus reglas editoriales y de privacidad; no persiste ningún derivado.
- Aplican §§11–17 del spec: minimización, conservación justificada, seguridad,
  accesibilidad, estados de error y trazabilidad. No se presumen proveedores ni plazos.

## Decisiones y aprobación pendientes

PD-01 y PD-10 fueron resueltos en F06. PD-02 queda resuelto para F07 por las decisiones explícitas del 2026-11-07 sobre promedio simple, rangos completos y tres módulos prioritarios. El spec y el catálogo fueron aprobados el 2026-11-07; el plan requiere aprobación separada. Las brechas de pantalla
se resuelven en el registro del índice, sin modificar silenciosamente el original.
Antes de `$speckit-plan`, resolver los pendientes aplicables y obtener aprobación explícita de la constitución y de este spec. Separar el documento no constituye esa aprobación.

## Alcance de plataforma vigente — 2026-10-28

Decisión explícita del usuario: «solo preparala para android». Esta entrega se
prepara únicamente para Android (mínimo API24 del plan); iOS, VoiceOver y Xcode
quedan fuera del alcance actual. Las menciones anteriores a ambas plataformas
son históricas. Se mantienen todos los requisitos funcionales, de privacidad y
seguridad aplicables a Android. No implica aprobación de otros specs ni entrega.
