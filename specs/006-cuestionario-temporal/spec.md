# Feature Specification: F06 — Realizar un intento temporal de diez preguntas

**Feature Branch**: `work` (rama actual; la funcionalidad se selecciona por directorio)
**Created**: 2026-10-21
**Status**: Completed — cierre y verificación funcional aprobados por el responsable el 2026-11-07.
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

### HU-06 — Responder el cuestionario (RF-10, RF-11 y RF-15)

Como usuario, quiero responder diez situaciones para identificar conocimientos que puedo mejorar.

- **CA-06.1:** Cada intento contiene diez preguntas activas y diferentes entre sí.
- **CA-06.2:** Cada pregunta permite una sola opción y muestra su posición de diez.
- **CA-06.3:** No puedo avanzar sin seleccionar respuesta; puedo revisar selecciones dentro del intento.
- **CA-06.4:** Cambiar el orden de las opciones no altera el porcentaje asociado a cada opción.
- **CA-06.5:** Al interrumpir la app se descarta el intento y al regresar se solicita comenzar uno nuevo.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias conforme a esta especificación; las pruebas aún no se han ejecutado.
**Recorrido:** Aviso de temporalidad → selección de diez preguntas → una respuesta por pregunta → revisión dentro del intento → diez respuestas completas.

### Edge Cases

Banco insuficiente; sin respuesta; cambio de opción; opciones reordenadas; salida
cancelada o confirmada; segundo plano; cierre; cierre de sesión; pérdida de red en
primer plano con pausa y recuperación.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-10**: Seleccionar diez preguntas del banco revisado para cada intento.
- **RF-11**: Mostrar opciones de selección única, progreso y controles para continuar o revisar.
- **RF-15**: Descartar respuestas y resultados según las reglas de temporalidad de la sección 9.

### Asociación a pantallas

P08 (PDF 7); transición a P09 (PDF 3).

**Brechas observadas:** El PDF actualizado sustituye el banco anterior y aporta tres opciones con porcentaje por cada pregunta completa.
P08 debe añadir aviso de temporalidad y estados de pausa, salida y error. La fórmula
y presentación del resultado pertenecen a F07.

### Decisiones confirmadas — actualización 2026-11-07

1. El banco activo contiene las 67 preguntas completas Q001–Q067 del PDF entregado el 2026-11-07. Q068 se excluye porque su opción C no tiene porcentaje; no se inventan Q069–Q100.
2. Cada pregunta ofrece exactamente tres opciones A/B/C. Cada opción conserva el porcentaje de vulnerabilidad indicado en el PDF.
3. Cada intento toma diez preguntas sin repetición: exactamente dos por cada uno de los cinco módulos. Preguntas y opciones se mezclan sin cambiar IDs ni porcentajes y permanecen fijas.
4. Si se pierde internet en primer plano, el avance se pausa y el intento permanece
   únicamente en RAM. Al recuperar conexión puede continuar. Pasar a segundo plano,
   cerrar sesión o terminar la app lo descarta inmediatamente.
5. Antes de comenzar se informa que las respuestas no se guardan y que una
   interrupción obliga a iniciar un intento nuevo.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase [el índice SDD](../README.md) para el reparto F06/F07.

### 9. Cuestionario y resultados

### 9.1 Naturaleza de la evaluación

El cuestionario evalúa conocimientos y decisiones declaradas ante situaciones de privacidad y seguridad. Una respuesta declarada no demuestra que el usuario aplique esa práctica. El resultado no es una medición de seguridad del dispositivo ni una probabilidad de filtración.

Aviso obligatorio: **«Este resultado es orientativo y se basa en tus respuestas. No mide la probabilidad real de que se filtren tus datos».**

### 9.2 Banco de preguntas

- Cada intento contiene exactamente diez preguntas.
- El banco activo contiene las 67 preguntas completas del PDF aprobado el 2026-11-07.
- Cada pregunta ofrece tres opciones, cada una con su porcentaje de vulnerabilidad aprobado.
- Cada registro contiene ID estable, versión, módulo, enunciado, opciones A/B/C, porcentaje por opción, fuente y fecha de revisión.
- Solo se seleccionan preguntas revisadas y activas. No se generan preguntas ni porcentajes libremente durante el intento.
- El banco cubre contraseñas; autenticación y acceso; redes; phishing e ingeniería social; y dispositivos y actualizaciones.
- La disponibilidad pública de un cuestionario no implica permiso para copiarlo; deben verificarse condiciones de uso o redactar contenido propio sustentado en fuentes.

### 9.3 Aleatoriedad

- Seleccionar diez preguntas sin repetición dentro del intento, con cobertura temática comparable.
- Aleatorizar preguntas y opciones sin alterar el porcentaje asociado a cada opción.
- Mantener preguntas y orden fijos mientras el intento esté activo.
- Al repetir, realizar una nueva selección. Puede haber coincidencias entre intentos.
- Como no se conserva historial, no se garantiza excluir todas las preguntas de intentos anteriores.
- Si no hay suficientes preguntas válidas, no iniciar un cuestionario incompleto; mostrar un error recuperable.

### 9.4 Interacción

Mostrar «Pregunta X de 10», una pregunta por vista, opciones de selección única y Continuar. Seleccionar otra opción reemplaza la anterior. No avanzar sin respuesta. En la décima pregunta, el control indica que permite ver el resultado. Los porcentajes no se revelan antes de terminar el intento.

### 9.5 Puntaje y fórmula pendientes para F07

El banco aprobado asigna a cada opción un porcentaje de vulnerabilidad entre 0 % y 100 %. F06 conserva esos valores y la selección únicamente en RAM, pero no calcula ni presenta el resultado.

El PDF describe nivel bajo para 0 %–15 %, medio para 20 %–50 % y elevado para 60 %–100 %, pero no define cómo agregar diez respuestas ni cubre los intervalos 16 %–19 % y 51 %–59 %. F07 debe resolver y aprobar esas decisiones antes de implementar el resultado. La fórmula anterior de respuestas correctas/incorrectas queda sustituida por este banco.

### 9.6 Recomendaciones

F07 definirá recomendaciones a partir de módulos y porcentajes después de aprobar su regla editorial. El PDF no aporta explicaciones ni recomendaciones por pregunta, por lo que F06 no las inventa. El resultado incluye porcentaje, nombre del nivel, explicación y acciones concretas, sin depender solo del color.

### 9.7 Temporalidad e interrupciones

- Las respuestas solo existen temporalmente durante el intento activo; no se guardan en bases de datos, archivos, analítica, registros de errores ni copias de seguridad.
- El procesamiento del cuestionario puede realizarse en memoria del dispositivo; no requiere enviar respuestas a la IA.
- Al terminar, se conserva en memoria únicamente lo necesario para mostrar el resultado y sus recomendaciones.
- Al abandonar el intento, pasar a segundo plano, cerrar la app o cerrar sesión, se descarta el estado del cuestionario y el resultado.
- Al regresar, debe iniciarse un nuevo intento; no se restaura el anterior.
- Reiniciar el cuestionario no significa cerrar automáticamente la sesión de cuenta.
- Antes de empezar, informar que una interrupción obliga a responder nuevamente.
- Ante pérdida de conexión en primer plano: suspender el avance, mantener el estado
  solo en memoria y permitir continuar al recuperar conexión; si la app pasa a
  segundo plano, descartar el intento.

### Key Entities

Banco revisado con IDs y porcentajes por opción; intento y selecciones únicamente temporales. No enviar respuestas a IA.

## Success Criteria *(mandatory)*

### Measurable Outcomes

Diez preguntas válidas distintas por intento; porcentajes intactos tras aleatorizar; CA-06.1 a CA-06.5 satisfechos; finalización ≥70 % (§15), protocolo pendiente.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Android únicamente, mínimo API24 vigente, público de40–65 años e internet obligatorio.
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- F07 consume únicamente el intento completo en memoria. Requiere contenido editorial aprobado y F08.
- Aplican §§11–17 del spec: minimización, conservación justificada, seguridad,
  accesibilidad, estados de error y trazabilidad. No se presumen proveedores ni plazos.

## Decisiones y aprobación pendientes

PD-01 queda propuesto mediante `banco-preguntas.md` y requiere aprobación editorial.
PD-10 queda resuelto para F06 por la decisión de pausa en primer plano y descarte en
segundo plano. PD-02 corresponde al cálculo y presentación de F07; F06 conserva los porcentajes de las opciones sin calcular ni mostrar un resultado.

El responsable sustituyó el banco anterior y aprobó usar las 67 preguntas completas del PDF el 2026-11-07 mediante «utiliza solo esas». El plan, las tareas y la implementación se actualizan sin incorporar la pregunta 68 incompleta.
Consultar sus condiciones de cierre en §18 del spec fuente. Las brechas de pantalla
se resuelven en el registro del índice, sin modificar silenciosamente el original.
Antes de `$speckit-plan`, resolver los pendientes aplicables y obtener aprobación explícita de la constitución y de este spec. Separar el documento no constituye esa aprobación.

## Alcance de plataforma vigente — 2026-10-28

Decisión explícita del usuario: «solo preparala para android». Esta entrega se
prepara únicamente para Android (mínimo API24 del plan); iOS, VoiceOver y Xcode
quedan fuera del alcance actual. Las menciones anteriores a ambas plataformas
son históricas. Se mantienen todos los requisitos funcionales, de privacidad y
seguridad aplicables a Android. No implica aprobación de otros specs ni entrega.

## Cierre aprobado — 2026-11-07

El responsable confirmó la verificación del banco actualizado de 67 preguntas y
ordenó cerrar F06 mediante «apruebo lo que había que verificar». Se acepta el
recorrido Android observado, incluida la variación de preguntas y la correspondencia
entre enunciados y opciones. La ejecución automatizada `integration_test` sin un
dispositivo conectado y el estudio formal con cinco participantes se cierran como
dispensas explícitamente aceptadas, sin afirmar que fueron ejecutados. La validación
TalkBack ya había sido confirmada por el responsable. F07 conserva la responsabilidad
de aprobar la fórmula, los intervalos pendientes y la presentación del resultado.
