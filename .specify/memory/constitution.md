# Priva Constitution

Estado: **ratificada — versión 1.1.0**.
Aplicación móvil para Android; metodología Spec-Driven Development (SDD).
Esta constitución complementa los requisitos funcionales sin reproducirlos.

## Core Principles

### I. Especificación como fuente de verdad

**Propósito:** desarrollar exclusivamente comportamientos documentados y aprobados.

**Reglas verificables:** cada cambio DEBE vincularse a un requisito y criterios de
aceptación del spec aprobado. Las propuestas, suposiciones y decisiones pendientes
DEBEN conservar su estado explícito; NO constituyen autorización para implementar.
Las discrepancias entre artefactos DEBEN resolverse y aprobarse antes de ejecutar
el trabajo afectado. La constitución gobierna el proceso; el spec aprobado define
el comportamiento del producto dentro de esas reglas. Los specs por funcionalidad
DEBEN conservar sus IDs y registrar las decisiones posteriores del usuario con su
fecha y alcance. Los originales se conservan como antecedentes; una decisión explícita
posterior solo sustituye las reglas afectadas, sin aprobar el resto del documento.
Los wireframes guían la presentación, pero NO autorizan funciones, datos ni garantías
por inferencia; sus diferencias con los requisitos DEBEN registrarse y resolverse.

**Evidencia:** versión del spec, registro de decisiones y aprobaciones, enlaces del
cambio a sus requisitos y resultados de aceptación.

### II. Privacidad desde el diseño

**Propósito:** reducir el tratamiento de datos a lo necesario y justificable.

**Reglas verificables:** cada dato personal tratado DEBE tener finalidad documentada,
justificación de necesidad, destinatarios y regla de conservación y eliminación.
El diseño DEBE identificar el fundamento aplicable, las autorizaciones cuando
correspondan y los mecanismos para ejercer los derechos de los titulares conforme
a la Ley 1581 de 2012 y su reglamentación aplicable. NO se recogerán datos por
conveniencia futura. Los proveedores y SDK DEBEN incluirse en la revisión de flujos.
Los plazos y obligaciones concretos DEBEN validarse con fuentes normativas vigentes
y revisión competente; esta constitución NO fija plazos legales ni presume cumplimiento.

**Evidencia:** inventario y diagrama de datos, finalidades, revisión normativa,
política de conservación justificada y pruebas de minimización y eliminación.

### III. Cuestionario sin persistencia

**Propósito:** permitir aprendizaje sin generar un historial de respuestas o resultados.

**Reglas verificables:** respuestas, resultados y derivados que permitan reconstruirlos
NO DEBEN guardarse en bases de datos, archivos, almacenamiento local, cachés persistentes,
copias de respaldo, analítica, registros técnicos ni informes de fallos. El procesamiento
DEBE ser temporal. Al completar las diez preguntas solo DEBE mantenerse en memoria
lo necesario para mostrar el resultado y sus recomendaciones; NO se exige borrarlo
antes de poder consultarlo. Al abandonar el intento o la vista de resultado, pasar
a segundo plano, cerrar la app o cerrar sesión, el estado del cuestionario y su
resultado DEBEN descartarse. Al regresar DEBE iniciarse un nuevo intento, sin restaurar
el anterior. El descarte del cuestionario NO implica cerrar automáticamente la sesión
de cuenta. Antes de empezar DEBE informarse la consecuencia de una interrupción. La instrumentación y los SDK NO DEBEN
capturarlos, incluidos cuerpos de solicitudes, trazas y capturas de diagnóstico.
La ubicación y los mecanismos del procesamiento quedan pendientes del plan aprobado;
cualquier componente interviniente DEBE respetar la misma prohibición. Las respuestas
NO DEBEN enviarse al proveedor de IA para calcular el resultado. La propuesta de
suspender el avance ante pérdida de red en primer plano sigue pendiente (PD-10);
NO DEBE presentarse como aprobada ni confundirse con el descarte obligatorio por
segundo plano. El resultado
DEBE presentarse como educativo y orientativo, sin garantía ni certificación de seguridad.

**Evidencia:** revisión del ciclo de vida y del flujo de datos; pruebas con datos
sintéticos de finalización, consulta de resultado, abandono, segundo plano, cierre,
cierre de sesión y reinicio; inspección de almacenamiento, tráfico,
logs y telemetría, sin persistir respuestas ni resultados reales en la evidencia.

### IV. Confiabilidad y límites de Zyro

**Propósito:** ofrecer orientación verificable sobre privacidad y seguridad.

**Reglas verificables:** las afirmaciones verificables DEBEN sustentarse en fuentes
identificables y revisadas, con fecha de revisión. Zyro DEBE reconocer incertidumbre,
falta de información y límites; NO DEBE inventar hechos ni presentar inferencias como
certezas. NO DEBE solicitar contraseñas, tokens, códigos de acceso u otras credenciales,
ejecutar acciones externas en nombre de la persona ni garantizar protección.
Su contenido DEBE mantener carácter educativo y orientativo. El mecanismo técnico
de Zyro NO queda decidido por esta constitución.

**Evidencia:** registro de fuentes y revisiones; pruebas de información incierta,
solicitud de credenciales, instrucciones para acciones externas y promesas de protección;
revisión del contenido y de las capacidades efectivamente habilitadas.

### V. Accesibilidad y usabilidad

**Propósito:** facilitar el uso por personas de 40 a 65 años.

**Reglas verificables:** las pantallas y mensajes DEBEN usar lenguaje sencillo,
texto ajustable y navegación comprensible. El ajuste de texto NO DEBE ocultar
contenido ni impedir acciones esenciales. El spec y el plan DEBEN definir criterios
medibles y escenarios de evaluación de accesibilidad y comprensión antes de implementar
las interacciones afectadas, sin presumir un estándar o umbral aún no aprobado.
Las evaluaciones DEBEN cubrir Android e iOS y tareas representativas del público objetivo.

**Evidencia:** criterios aprobados, revisión de textos y recorridos, resultados de
pruebas de texto ajustable, accesibilidad y uso con personas representativas del público.

### VI. Calidad y seguridad

**Propósito:** entregar comportamientos correctos y proteger los datos tratados.

**Reglas verificables:** cada entrega DEBE validar reglas de negocio aprobadas,
autenticación cuando corresponda al alcance, manejo de errores, compatibilidad móvil
y protección de datos. La exigencia de validar autenticación NO aprueba por sí misma
cuentas, un proveedor o un mecanismo concreto. Los controles visibles de navegación
NO DEBEN eludir las restricciones de acceso confirmadas en la sección siguiente.
El acceso directo o mediante retroceso DEBE respetar las mismas restricciones.
La matriz de versiones y dispositivos,
los controles y los criterios de severidad DEBEN aprobarse en el plan.
Los errores NO DEBEN exponer datos personales o credenciales. Los fallos que vulneren
estas reglas o criterios de aceptación DEBEN corregirse y volver a probarse antes
de aprobar la entrega; un resultado omitido o no ejecutado NO equivale a aprobado.

**Evidencia:** análisis de riesgos, matriz móvil aprobada, pruebas positivas y negativas,
resultados de autenticación aplicable, errores y protección de datos, defectos y repruebas.

### VII. Trazabilidad de extremo a extremo

**Propósito:** demostrar qué necesidad satisface cada cambio y cómo se valida.

**Reglas verificables:** requisitos, historias de usuario, criterios de aceptación,
tareas y pruebas DEBEN tener identificadores estables y relaciones verificables.
Cada requisito en alcance DEBE tener cobertura de aceptación; cada tarea y prueba
DEBE justificar su relación con un requisito o control constitucional.
Los cambios DEBEN actualizar los enlaces y registrar su impacto. Las pruebas pendientes,
fallidas, omitidas y aprobadas DEBEN distinguirse.

**Evidencia:** matriz requisito → historia → criterio → tarea → prueba → resultado,
referencias a commits y registro de cambios de cobertura.

### VIII. Alcance controlado y simplicidad

**Propósito:** limitar el producto a necesidades justificadas por el spec.

**Reglas verificables:** NO se añadirán funcionalidades, dependencias o complejidad
sin necesidad documentada. El plan DEBE justificar las decisiones técnicas mediante
requisitos y alternativas proporcionales. Toda ampliación DEBE pasar por control de
cambios y aprobación antes de implementarse. Ningún ejemplo, recomendación de una
herramienta o preferencia del implementador constituye una decisión del proyecto.

**Evidencia:** comparación del alcance aprobado con la entrega, decisiones justificadas,
revisión de dependencias y solicitudes de cambio aprobadas.

### IX. Gobierno de cambios y aprobación por etapa

**Propósito:** mantener decisiones explícitas, auditables y compartidas.

**Reglas verificables:** cada modificación constitucional DEBE proponer motivo,
texto afectado, impacto en requisitos, plan, tareas y pruebas, conflictos y versión.
El responsable del proyecto DEBE aprobarla explícitamente antes de su ratificación.
El autor NO DEBE asumir aprobación por silencio, commit, sincronización o prueba exitosa.
NO se avanzará al siguiente spec ni a la siguiente etapa SDD hasta que todos los
artefactos y decisiones exigidos por la etapa actual estén aprobados y sus bloqueos
resueltos. En cada spec o etapa se DEBEN registrar los cambios mediante commit y
sincronizar el repositorio; un fallo de sincronización DEBE comunicarse y resolverse
antes de declarar cerrada la etapa. Un borrador puede sincronizarse sin quedar aprobado.

**Evidencia:** propuesta, aprobación con identidad y fecha, historial de versiones,
comunicación del cambio, hash del commit y confirmación de sincronización remota.

## Restricciones y decisiones pendientes

### Fuentes y estado del contraste

Se contrastó esta constitución con el [spec original](../../docs/referencias/PRIVA_MOBILE_SPEC.md),
el [registro de pantallas y decisiones del 2026-10-26](../../docs/referencias/ACTUALIZACION_PANTALLAS_2026-10-26.md),
el [análisis de discrepancias](../../docs/descomposicion/README.md) y la organización
de [ocho specs funcionales](../../specs/README.md). Es una revisión documental:
NO demuestra ejecución de pruebas, cumplimiento jurídico operativo ni aprobación.

### Decisiones de producto confirmadas

Las siguientes decisiones explícitas del usuario DEBEN respetarse sin duplicar
su detalle funcional en la constitución:

- Tips y sus cuatro categorías son contenido accesible sin sesión. Registro, acceso
  y recuperación permanecen disponibles como flujos de entrada. El resto del contenido
  de Priva requiere autenticación; una sesión válida habilita las funciones del alcance,
  sujetas a sus precondiciones y al control de la cuenta propia.
- Se conserva la navegación del wireframe de acceso. Ver un control NO concede acceso
  a contenido protegido. Al cerrar sesión, Tips sigue disponible y las funciones
  protegidas dejan de estarlo; el cuestionario y su resultado se descartan.
- Priva NO solicita número de teléfono en registro, perfil ni recuperación; NO se
  presume recuperación por SMS. El mecanismo concreto de recuperación sigue pendiente.
- Una fila vacía o un ejemplo visual NO constituye un requisito ni autoriza recopilar
  un dato o conservar un resultado. No se reincorpora el estado de riesgo en Perfil.

Estas decisiones NO aprueban el resto de los specs. La regla histórica que ocultaba
la navegación en acceso y cualquier interpretación de cuenta obligatoria para consultar
Tips quedan sustituidas únicamente en el alcance confirmado por el usuario.

### Conflictos y brechas identificados

| Referencia | Resultado del contraste | Tratamiento obligatorio |
| --- | --- | --- |
| Spec §§9.7 y 11 frente a principio III anterior | «Descartar al terminar» era ambiguo para consultar el resultado; faltaba segundo plano | Distinguir fin de respuestas de abandono de resultado, mantener solo lo necesario en memoria y descartar en los eventos definidos, como precisa esta versión. |
| D01: P11 ausente del PDF original | Diseño de acceso aportado el 2026-10-26; brecha visual subsanada | Revisar recuperación y estados de error aún pendientes; no declarar listo todo el flujo. |
| D02: teléfono en Perfil original | Resuelto por el diseño corregido y confirmación del usuario | No recopilar teléfono ni usarlo como supuesto de autenticación. |
| D16: navegación visible en acceso frente a spec §5 y CA-03.1 original | Resuelto por decisión explícita: conservar wireframe, Tips público, resto protegido | Revisar navegación y autorización juntas; no ocultar controles por la regla histórica ni liberar funciones protegidas. |
| D03: estado de riesgo en Perfil original | Retirado visualmente; permanece fila vacía | No inferir una función, campo o historial; resolver su presentación en el spec correspondiente. |
| D04/D10/D11: garantías de protección, HTTPS y perfiles en mockups | Textos pueden sugerir certezas no admitidas por §§8–9 | Proponer y aprobar lenguaje educativo y límites; revisar fuentes antes de entregar contenido. |
| D05/D06/D12/D14: recomendaciones, repetición, cuenta y accesibilidad | Los wireframes no cubren todos los requisitos escritos | Completar y aprobar estados y criterios en cada funcionalidad; no eliminar requisitos por no estar dibujados. |
| D07/D08/D09/D13 y PD-01/02/03/10 | Banco, puntaje, guías y desconexión aún contienen propuestas | Resolver editorialmente y aprobar la regla aplicable antes de implementar; ejemplos e imágenes no equivalen a aprobación. |

Cada conflicto real DEBE registrar referencia de fuente, regla afectada, propuesta,
estado y decisión. Un conflicto de una funcionalidad NO se resolverá modificando
silenciosamente otra ni se considerará cerrado por un commit.

### Pendientes que conservan su estado

- **PD-01/PD-02:** banco y tamaño inicial, claves, derechos de uso y puntaje propuesto.
  La fórmula de igual peso NO queda aprobada por esta constitución ni por los ejemplos.
- **PD-03:** catálogo y guías verificadas de Zyro, con responsable de revisión.
- **PD-04:** justificar nombre, correo y necesidad de cuenta para funciones protegidas;
  NO extender esa necesidad a Tips público.
- **PD-05/PD-06:** conservación, ubicaciones, eliminación, proveedores y arquitectura,
  con evaluación de tratamiento de datos y obligaciones aplicables.
- **PD-07/PD-08:** matriz móvil, contraste, texto y presupuestos medibles de calidad.
- **PD-09:** campos editables, verificaciones, recuperación y duración de sesión,
  respetando que no se pide teléfono.
- **PD-10:** pérdida de conexión durante intento en primer plano; no modifica la regla
  de descarte al pasar a segundo plano.

Estos pendientes se cierran en la etapa y funcionalidad correspondientes. NO impiden
aprobar reglas de gobierno que exigen resolverlos; sí bloquean aprobar el artefacto
que depende de ellos. No se exige una decisión técnica propia del plan para cerrar
la constitución. Ningún framework, backend, proveedor, plazo legal o regla de negocio
pendiente queda seleccionado por esta revisión.

## Controles de revisión por etapa

Cada control DEBE registrar artefacto y versión, responsable, fecha, evidencia,
resultado y aprobación explícita. Un control incumplido o pendiente bloquea el cierre.

| Puerta | Comprobaciones obligatorias antes de aprobar |
| --- | --- |
| Constitución | Revisar fuentes, decisiones y conflictos documentados; resolver decisiones de gobierno; aprobar explícitamente el texto y registrar ratificación, sin convertir PD funcionales/técnicos en decisiones aprobadas. |
| Spec | Requisitos e historias identificados; criterios verificables; alcance explícito; decisiones necesarias resueltas; privacidad, cuestionario, Zyro y accesibilidad conformes; matriz de trazabilidad revisada. |
| Plan técnico | Spec aprobado; decisiones justificadas; flujos y conservación revisados; ausencia de persistencia del cuestionario diseñada; límites de Zyro verificables; matriz móvil, autenticación aplicable, riesgos y estrategia de pruebas definidos; tareas trazables. |
| Entrega | Plan y tareas aprobados; criterios ejecutados y satisfechos; pruebas de negocio, seguridad, privacidad, accesibilidad y compatibilidad completadas; defectos bloqueantes resueltos; trazabilidad actualizada; commit y sincronización confirmados; aceptación explícita. |

Una revisión documental NO sustituye pruebas de implementación. Las pruebas futuras
se expresan aquí como obligaciones; NO se declaran ejecutadas por esta ratificación.

## Governance

Esta constitución establece las reglas transversales del proyecto. Un conflicto
con el spec o el plan DEBE resolverse expresamente antes del trabajo afectado;
no autoriza a reinterpretar o alterar requisitos unilateralmente.

Las enmiendas DEBEN seguir: propuesta documentada → análisis de impacto y conflictos →
aprobación explícita del responsable → actualización de versión y artefactos afectados →
commit y sincronización → comunicación de la versión y decisiones a las personas
que especifican, planifican, implementan y validan. Si hay migración necesaria,
su alcance y comprobación DEBEN aprobarse antes de aplicar el cambio.

Se usa versionado semántico: MAJOR para eliminar o redefinir incompatiblemente
principios; MINOR para añadir principios o ampliar obligaciones compatibles;
PATCH para aclaraciones sin cambio de obligación. Cada cambio DEBE registrar su
justificación, fecha y aprobación. La ratificación inicial se registra como 1.0.0.
Las versiones 0.x identifican propuestas previas a ratificación y NO acreditan aprobación.

### Historial de enmiendas

| Versión | Fecha | Cambio y estado |
| --- | --- | --- |
| 0.1.0 | 2026-10-21 | Propuesta inicial de nueve principios sin acceso al spec fuente; no ratificada. |
| 0.2.0 | 2026-10-26 | Amplía reglas de trazabilidad y seguridad, precisa temporalidad con §9.7 e incorpora fuentes, decisiones y conflictos revisados; propuesta posteriormente aprobada. |
| 1.0.0 | 2026-10-26 | Ratificación inicial por aprobación explícita del usuario de la propuesta 0.2.0; sin cambios a sus principios. |

### Registro de ratificación

El 2026-10-26, el usuario responsable del proyecto aprobó explícitamente la propuesta
v0.2.0 mediante el mensaje «si, apruebo», en respuesta a la solicitud de aprobación
de esa versión. Se registra su adopción inicial como v1.0.0, sin modificar los nueve
principios ni aprobar decisiones funcionales o técnicas pendientes.

Esta aprobación cierra únicamente la puerta de constitución. Los ocho specs siguen
pendientes de sus propias revisiones y aprobaciones. No se inicia planificación,
tareas ni implementación por el hecho de ratificar este documento.

**Version**: 1.0.0 | **Ratified**: 2026-10-26 | **Last Amended**: 2026-10-26

## Cambio de alcance ratificado — 2026-10-28 — v1.1.0

El responsable del proyecto indicó explícitamente «solo preparala para android».
La preparación, implementación, compatibilidad y aceptación actuales se limitan a
Android. Esta decisión sustituye las exigencias de validar ambas plataformas de
esta constitución y de los artefactos anteriores: iOS/VoiceOver/Xcode quedan fuera
del alcance actual, sin calificarse como pruebas aprobadas. Se mantienen TalkBack,
texto ajustable y las demás reglas de privacidad, seguridad, trazabilidad y calidad.

Motivo: reducción explícita de plataformas solicitada por el usuario. Impacto:
actualizar specs, plan, matriz y tareas F01; no borrar evidencias ni originales.
Los archivos iOS existentes son scaffolding histórico, sin entrega ni mantenimiento
prometidos. Reintroducir iOS requerirá control de cambios. Versión menor por reducción
de alcance sin eliminar principios. Se comunica mediante documentación, commit y push.
