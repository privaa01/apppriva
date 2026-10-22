# Priva Constitution

Estado: **borrador pendiente de contraste con el spec y aprobación explícita**.
Aplicación móvil para Android e iOS; metodología Spec-Driven Development (SDD).
Esta constitución complementa los requisitos funcionales sin reproducirlos.

## Core Principles

### I. Especificación como fuente de verdad

**Propósito:** desarrollar exclusivamente comportamientos documentados y aprobados.

**Reglas verificables:** cada cambio DEBE vincularse a un requisito y criterios de
aceptación del spec aprobado. Las propuestas, suposiciones y decisiones pendientes
DEBEN conservar su estado explícito; NO constituyen autorización para implementar.
Las discrepancias entre artefactos DEBEN resolverse y aprobarse antes de ejecutar
el trabajo afectado. La constitución gobierna el proceso; el spec aprobado define
el comportamiento del producto dentro de esas reglas.

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
DEBE ser temporal y los valores DEBEN descartarse al terminar o abandonar el flujo;
NO se restaurarán tras reiniciar la aplicación. La instrumentación y los SDK NO DEBEN
capturarlos, incluidos cuerpos de solicitudes, trazas y capturas de diagnóstico.
La ubicación y los mecanismos del procesamiento quedan pendientes del plan aprobado;
cualquier componente interviniente DEBE respetar la misma prohibición. El resultado
DEBE presentarse como educativo y orientativo, sin garantía ni certificación de seguridad.

**Evidencia:** revisión del ciclo de vida y del flujo de datos; pruebas con datos
sintéticos de abandono, cierre y reinicio; inspección de almacenamiento, tráfico,
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
cuentas, un proveedor o un mecanismo concreto. La matriz de versiones y dispositivos,
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

`PRIVA_MOBILE_SPEC.md` no está disponible en el entorno al redactar esta versión.
Por tanto, NO se ha comprobado la concordancia ni se han identificado conflictos
concretos con su contenido. El contraste es obligatorio antes de ratificar.

| Asunto por contrastar | Regla para resolverlo |
| --- | --- |
| Historial, analítica o diagnóstico del cuestionario | Si el spec exige persistencia, registrar la incompatibilidad y proponer retirar esa persistencia; obtener aprobación sin implementarla. |
| Facultades y afirmaciones de Zyro | Si exige credenciales, acciones externas o garantías, proponer orientación educativa y límites explícitos; someter el cambio a aprobación. |
| Datos, finalidades y conservación | Completar y validar el inventario y los fundamentos; no inventar plazos ni aprobaciones legales. |
| Accesibilidad, autenticación y compatibilidad | Resolver criterios y alcance pendientes en los artefactos correspondientes; no elegir tecnologías ni reglas de negocio por defecto. |

Estos son riesgos de conflicto por revisar, NO hallazgos del spec.
Cada conflicto real DEBE registrar referencia exacta del spec, regla afectada,
propuesta de resolución y decisión aprobada. Ningún documento se modifica en silencio.
No quedan aprobados framework, backend, proveedor, arquitectura de Zyro, plazos
legales, reglas de negocio ni versiones móviles por la emisión de esta constitución.

## Controles de revisión por etapa

Cada control DEBE registrar artefacto y versión, responsable, fecha, evidencia,
resultado y aprobación explícita. Un control incumplido o pendiente bloquea el cierre.

| Puerta | Comprobaciones obligatorias antes de aprobar |
| --- | --- |
| Constitución | Incorporar el spec fuente; contrastar conflictos; resolver decisiones de gobierno; aprobar el texto y registrar ratificación. |
| Spec | Requisitos e historias identificados; criterios verificables; alcance explícito; decisiones necesarias resueltas; privacidad, cuestionario, Zyro y accesibilidad conformes; matriz de trazabilidad revisada. |
| Plan técnico | Spec aprobado; decisiones justificadas; flujos y conservación revisados; ausencia de persistencia del cuestionario diseñada; límites de Zyro verificables; matriz móvil, autenticación aplicable, riesgos y estrategia de pruebas definidos; tareas trazables. |
| Entrega | Plan y tareas aprobados; criterios ejecutados y satisfechos; pruebas de negocio, seguridad, privacidad, accesibilidad y compatibilidad completadas; defectos bloqueantes resueltos; trazabilidad actualizada; commit y sincronización confirmados; aceptación explícita. |

Una revisión documental NO sustituye pruebas de implementación. Las pruebas futuras
se expresan aquí como obligaciones; NO se declaran ejecutadas en este borrador.

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
justificación, fecha y aprobación. La ratificación inicial dará lugar a 1.0.0;
0.1.0 identifica esta propuesta inicial y NO acredita aprobación.

Pendientes obligatorios: aportar `PRIVA_MOBILE_SPEC.md`, completar su contraste,
resolver los conflictos reales que aparezcan y obtener aprobación explícita.
La fecha de ratificación solo se consignará al recibir esa aprobación.

**Version**: 0.1.0 | **Ratified**: pendiente de aprobación | **Last Amended**: 2026-10-21
