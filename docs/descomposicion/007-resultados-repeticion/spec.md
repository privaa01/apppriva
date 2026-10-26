# Feature Specification: F07 — Comprender el resultado orientativo y repetir

**Feature Branch**: `work` (borradores de descomposición; sin rama de implementación)
**Created**: 2026-10-21
**Status**: Borrador de análisis; pendiente de aprobación de constitución y alcance.
**Input**: Descomponer el spec aportado y asociarlo a las pantallas del PDF.
**Fuentes**: [Spec original](../../referencias/PRIVA_MOBILE_SPEC.md), [PDF](../../referencias/app.pdf).

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

- **CA-07.1:** Solo después de diez respuestas se muestra el porcentaje calculado según la regla aprobada.
- **CA-07.2:** Los valores de frontera 40 % y 80 % se clasifican como bajo y medio respectivamente.
- **CA-07.3:** El resultado muestra nivel en texto, explicación, aviso orientativo y recomendaciones vinculadas a las respuestas.
- **CA-07.4:** Repetir crea una nueva selección, sin prometer que todas las preguntas cambien.
- **CA-07.5:** No existe historial persistente de respuestas o resultados, tampoco en registros técnicos.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias durante esta revisión documental.
**Recorrido:** Diez respuestas → porcentaje y nivel educativos → recomendaciones vinculadas → repetir con selección nueva; descarte según §9.7.

### Edge Cases

Resultado parcial; fronteras 40/80; 0 % confundido con protección garantizada; recomendaciones genéricas; persistencia en Perfil; repetición con preguntas coincidentes.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-12**: Calcular el resultado únicamente después de responder las diez preguntas.
- **RF-13**: Mostrar porcentaje de riesgo orientativo, nivel y recomendaciones relacionadas con las respuestas.
- **RF-14**: Permitir repetir el cuestionario mediante una nueva selección aleatoria.
- **RF-15**: Descartar respuestas y resultados según las reglas de temporalidad de la sección 9.

### Asociación a pantallas

P09 (PDF 3); repetición → P08 (PDF 7).

**Brechas observadas:** «Tu diagnóstico»/«Vulnerabilidad media» deben sustituirse por orientación educativa sin garantía; falta aviso obligatorio, repetir y evidencia de recomendaciones asociadas. El 50 % del mockup es un ejemplo, no resultado real.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase el índice para el reparto F06/F07.

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

Resultado y recomendaciones temporales; no historial, almacenamiento, analítica ni logs con respuestas o resultados.

## Success Criteria *(mandatory)*

### Measurable Outcomes

CA-07.1 a CA-07.5 verificados una vez aprobada la regla; comprensión ≥80 % (§15), protocolo pendiente. No usar el cumplimiento de ejemplos propuestos como aprobación de PD-02.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Se conserva Android/iOS, público de 40–65 años e internet obligatorio (§§1–3).
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- Depende del intento completo F06. Comparte reglas editoriales y privacidad; no puede validarse como cálculo final mientras PD-02 esté pendiente.
- Aplican §§11–17 del spec: minimización, conservación justificada, seguridad,
  accesibilidad, estados de error y trazabilidad. No se presumen proveedores ni plazos.

## Decisiones y aprobación pendientes

Pendientes originales asociados: PD-01, PD-02, PD-10.
Consultar sus condiciones de cierre en §18 del spec fuente. Las brechas de pantalla
se resuelven en el registro del índice, sin modificar silenciosamente el original.
No se autoriza `$speckit-plan`, tareas ni implementación con este borrador.
