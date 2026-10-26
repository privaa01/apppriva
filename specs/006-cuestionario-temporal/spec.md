# Feature Specification: F06 — Realizar un intento temporal de diez preguntas

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

### HU-06 — Responder el cuestionario (RF-10 y RF-11)

Como usuario, quiero responder diez situaciones para identificar conocimientos que puedo mejorar.

- **CA-06.1:** Cada intento contiene diez preguntas activas y diferentes entre sí.
- **CA-06.2:** Cada pregunta permite una sola opción y muestra su posición de diez.
- **CA-06.3:** No puedo avanzar sin seleccionar respuesta; puedo revisar selecciones dentro del intento.
- **CA-06.4:** Cambiar el orden de las opciones no cambia la clave correcta.
- **CA-06.5:** Al interrumpir la app se descarta el intento y al regresar se solicita comenzar uno nuevo.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias conforme a esta especificación; las pruebas aún no se han ejecutado.
**Recorrido:** Aviso de temporalidad → selección de diez preguntas → una respuesta por pregunta → revisión dentro del intento → diez respuestas completas.

### Edge Cases

Banco insuficiente; sin respuesta; cambio de opción; opciones reordenadas; salida cancelada o confirmada; segundo plano; cierre; cierre de sesión; pérdida de red en primer plano pendiente.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-10**: Seleccionar diez preguntas del banco revisado para cada intento.
- **RF-11**: Mostrar opciones de selección única, progreso y controles para continuar o revisar.
- **RF-15**: Descartar respuestas y resultados según las reglas de temporalidad de la sección 9.

### Asociación a pantallas

P08 (PDF 7); transición a P09 (PDF 3).

**Brechas observadas:** La pregunta sí/no del PDF sobre práctica declarada no define por sí misma una clave educativa correcta; revisar alineación con §9.1. Falta advertencia de descarte al pasar a segundo plano. Puntaje y banco no aprobados.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase [el índice SDD](../README.md) para el reparto F06/F07.

### 9. Cuestionario y resultados

### 9.1 Naturaleza de la evaluación

El cuestionario evalúa conocimientos y decisiones declaradas ante situaciones de privacidad y seguridad. Una respuesta correcta no demuestra que el usuario aplique esa práctica. El resultado no es una medición de seguridad del dispositivo ni una probabilidad de filtración.

Aviso obligatorio: **«Este resultado es orientativo y se basa en tus respuestas. No mide la probabilidad real de que se filtren tus datos».**

### 9.2 Banco de preguntas

- Cada intento contiene exactamente diez preguntas.
- Se propone un banco inicial de al menos 30 preguntas; este tamaño y el contenido están pendientes de aprobación editorial.
- Cada pregunta ofrece varias opciones y una sola respuesta correcta.
- Cada registro contiene ID estable, versión, tema, enunciado, opciones con IDs estables, clave correcta, puntaje, explicación, recomendación, fuente y fecha de revisión.
- Solo se seleccionan preguntas revisadas y activas. No se generan preguntas ni claves libremente durante el intento.
- El banco debe cubrir contraseñas, autenticación, información compartida, enlaces y mensajes, perfiles, permisos y gestión de cuentas.
- La disponibilidad pública de un cuestionario no implica permiso para copiarlo; deben verificarse condiciones de uso o redactar contenido propio sustentado en fuentes.

### 9.3 Aleatoriedad

- Seleccionar diez preguntas sin repetición dentro del intento, con cobertura temática comparable.
- Aleatorizar el orden de las preguntas y sus opciones sin alterar la clave asociada a cada ID.
- Mantener preguntas y orden fijos mientras el intento esté activo.
- Al repetir, realizar una nueva selección. Puede haber coincidencias entre intentos.
- Como no se conserva historial, no se garantiza excluir todas las preguntas de intentos anteriores.
- Si no hay suficientes preguntas válidas, no iniciar un cuestionario incompleto; mostrar un error recuperable.

### 9.4 Interacción

Mostrar «Pregunta X de 10», una pregunta por vista, opciones de selección única y Continuar. Seleccionar otra opción reemplaza la anterior. No avanzar sin respuesta. En la décima pregunta, el control indica que permite ver el resultado. Las claves o explicaciones no se revelan antes de terminar el intento.

### 9.5 Puntaje y fórmula propuestos

La propuesta inicial asigna igual peso a todas las preguntas: respuesta correcta = 0 puntos de riesgo; incorrecta = 1 punto. Esta regla es propia de Priva, no una ponderación atribuida a un banco externo, y requiere validación antes de aprobarse.

**Porcentaje de riesgo orientativo = (respuestas incorrectas / 10) × 100.**

Se calcula solo con las diez preguntas respondidas. No se divide entre un número variable de respuestas para emitir resultados parciales.

| Porcentaje | Nivel |
| --- | --- |
| 0 % a 40 %, inclusive | Bajo |
| Mayor que 40 % y hasta 80 %, inclusive | Medio |
| Mayor que 80 % y hasta 100 %, inclusive | Alto |

Con esta propuesta los valores son 0, 10, 20…100. Ejemplos: tres incorrectas = 30 %, bajo; seis incorrectas = 60 %, medio; nueve incorrectas = 90 %, alto. Cero no equivale a ausencia de riesgos reales.

Los umbrales son una regla educativa del producto, sin validación científica de probabilidad de filtración. Si se adoptan pesos distintos, se debe actualizar la fórmula, sus ejemplos y pruebas antes de implementar.

### 9.6 Recomendaciones

Relacionar cada respuesta incorrecta con su explicación y recomendación revisadas. Agrupar recomendaciones equivalentes. No mostrar una lista genérica como si fuera personalizada. Si todas las respuestas son correctas, mostrar consejos de mantenimiento. El resultado incluye porcentaje, nombre del nivel, explicación y acciones concretas, sin depender solo del color.

### 9.7 Temporalidad e interrupciones

- Las respuestas solo existen temporalmente durante el intento activo; no se guardan en bases de datos, archivos, analítica, registros de errores ni copias de seguridad.
- El procesamiento del cuestionario puede realizarse en memoria del dispositivo; no requiere enviar respuestas a la IA.
- Al terminar, se conserva en memoria únicamente lo necesario para mostrar el resultado y sus recomendaciones.
- Al abandonar el intento, pasar a segundo plano, cerrar la app o cerrar sesión, se descarta el estado del cuestionario y el resultado.
- Al regresar, debe iniciarse un nuevo intento; no se restaura el anterior.
- Reiniciar el cuestionario no significa cerrar automáticamente la sesión de cuenta.
- Antes de empezar, informar que una interrupción obliga a responder nuevamente.
- Propuesta ante pérdida de conexión en primer plano: suspender el avance, mantener el estado solo en memoria y permitir reintentar; si la app pasa a segundo plano, descartar el intento. Pendiente de validación del equipo.

### Key Entities

Banco revisado con IDs y claves; intento y selecciones únicamente temporales. No enviar respuestas a IA.

## Success Criteria *(mandatory)*

### Measurable Outcomes

Diez preguntas válidas distintas por intento; clave intacta tras aleatorizar; CA-06.1 a CA-06.5 satisfechos; finalización ≥70 % (§15), protocolo pendiente.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Se conserva Android/iOS, público de 40–65 años e internet obligatorio (§§1–3).
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- F07 consume únicamente el intento completo en memoria. Requiere contenido editorial aprobado y F08.
- Aplican §§11–17 del spec: minimización, conservación justificada, seguridad,
  accesibilidad, estados de error y trazabilidad. No se presumen proveedores ni plazos.

## Decisiones y aprobación pendientes

Pendientes originales asociados: PD-01, PD-02, PD-10.
Consultar sus condiciones de cierre en §18 del spec fuente. Las brechas de pantalla
se resuelven en el registro del índice, sin modificar silenciosamente el original.
Antes de `$speckit-plan`, resolver los pendientes aplicables y obtener aprobación explícita de la constitución y de este spec. Separar el documento no constituye esa aprobación.
