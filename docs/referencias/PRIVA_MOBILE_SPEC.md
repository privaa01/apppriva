# SPEC — Priva móvil

**Versión:** 1.0 — consolidación para revisión  
**Fecha:** 21 de octubre de 2026  
**Metodología:** Spec-Driven Development (SDD)  
**Responsables:** Alison Mesa, Samantha Bolívar e Isabela Pinzón  
**Plataformas:** Android e iOS  
**Estado:** borrador funcional; pendientes explícitos en la sección 18.

## 1. Propósito y problema

Las personas comparten datos personales en internet sin conocer siempre los riesgos de reutilizar contraseñas, publicar información sensible, abrir enlaces sospechosos o interactuar con perfiles falsos. Priva ofrece educación y orientación sencilla para mejorar sus decisiones sobre privacidad y seguridad digital.

### Objetivo general

Brindar información comprensible, orientación mediante el asistente Zyro y una autoevaluación educativa que permita identificar aspectos de privacidad y seguridad que el usuario puede mejorar.

### Objetivos específicos

- Explicar prácticas de protección de datos mediante tips.
- Orientar sobre privacidad, seguridad y eliminación o desactivación de cuentas externas.
- Presentar diez preguntas por intento y recomendaciones según las respuestas.
- Facilitar el uso de la aplicación a personas entre 40 y 65 años.

## 2. Alcance y límites

La primera versión incluye cuenta de usuario, inicio, cuatro categorías de tips, chat IA Zyro, cuestionario, resultados orientativos y perfil. Todas las funciones requieren conexión a internet. La interfaz se adapta a móviles Android e iOS; no se incluye una versión de escritorio.

Quedan fuera de alcance:

- Acceso directo a cuentas externas, contraseñas o códigos de verificación.
- Eliminación automática de cuentas, bloqueo de perfiles o denuncias ejecutadas por Priva.
- Recuperación directa de cuentas comprometidas e investigación de incidentes.
- Protección automática del dispositivo o garantía de ausencia de filtraciones.
- Asesoría jurídica especializada y evaluaciones profesionales de seguridad.
- Historial persistente de respuestas y resultados del cuestionario.

## 3. Usuarios y actores

| Actor | Necesidad o responsabilidad |
| --- | --- |
| Usuario principal | Persona de 40 a 65 años que desea comprender riesgos y proteger mejor sus datos. |
| Equipo Priva | Mantener contenido, banco de preguntas, guías, pruebas y política de tratamiento. |
| Zyro | Orientar dentro de los límites establecidos; no ejecutar acciones externas. |
| Proveedor de autenticación e IA | Servicios técnicos por seleccionar; su tratamiento de datos debe evaluarse antes de producción. |

## 4. Glosario

- **Dato personal:** información vinculada o que pueda asociarse a una persona natural determinada o determinable.
- **Intento:** conjunto de diez preguntas seleccionadas al iniciar el cuestionario.
- **Riesgo orientativo:** indicador educativo derivado de las respuestas; no es una probabilidad real de filtración.
- **Eliminación de cuenta:** solicitud de supresión de una cuenta según las reglas de la plataforma externa.
- **Desactivación:** suspensión de una cuenta según las reglas de la plataforma; no equivale necesariamente a eliminarla.
- **Memoria temporal:** estado necesario durante el uso activo, sin persistir las respuestas en bases de datos, archivos o registros.

## 5. Mapa de pantallas y navegación

El alcance contiene **12 pantallas**, incluida Crear cuenta. Las preguntas se presentan sucesivamente en una misma vista.

| ID | Pantalla | Contenido principal |
| --- | --- | --- |
| P01 | Inicio | Presentación y acceso a las herramientas. |
| P02 | Tips | Tarjetas de las cuatro categorías. |
| P03 | Contraseñas seguras | Recomendaciones, ejemplo y consejo. |
| P04 | Cuida lo que subes | Recomendaciones sobre exposición de información. |
| P05 | Enlaces sospechosos | Señales de alerta y acciones preventivas. |
| P06 | Perfiles falsos | Señales de alerta y límites de su interpretación. |
| P07 | Chat IA — Zyro | Conversación y orientación paso a paso. |
| P08 | Cuestionario | Una pregunta a la vez, selección única y progreso. |
| P09 | Resultados | Porcentaje, nivel, explicación y recomendaciones. |
| P10 | Crear cuenta | Nombre, correo, contraseña y autorización aplicable. |
| P11 | Iniciar sesión | Acceso y recuperación de credenciales. |
| P12 | Perfil | Consulta y gestión de la cuenta y tamaño del texto. |

### Reglas de navegación

- En todas las pantallas autenticadas se muestran Inicio y Perfil, y un menú inferior con Tips, Chat IA y Cuestionario.
- Crear cuenta e Iniciar sesión no muestran dicha navegación.
- La sección activa se identifica visualmente y mediante etiquetas accesibles.
- El retroceso vuelve a la vista anterior según el historial. En el cuestionario permite revisar preguntas del intento activo y conserva temporalmente sus selecciones.
- Salir del cuestionario antes de finalizar descarta el intento. Debe informarse esta consecuencia y permitirse cancelar la salida.
- Los estados y acciones de recuperación de acceso y eliminación de cuenta pueden resolverse dentro de las vistas existentes; no se presupone una pantalla principal adicional.
- La aplicación no requiere abrir enlaces externos para presentar las guías de Zyro.

## 6. Requisitos funcionales

| ID | Requisito |
| --- | --- |
| RF-01 | Permitir crear cuenta con nombre, correo y contraseña, validando campos y formato. |
| RF-02 | Permitir iniciar y cerrar sesión y recuperar el acceso mediante un mecanismo seguro. |
| RF-03 | Mostrar errores de registro y acceso comprensibles sin exponer datos de terceros. |
| RF-04 | Permitir consultar y gestionar datos de la propia cuenta y solicitar su eliminación. |
| RF-05 | Mostrar inicio y navegación conforme a la sección 5. |
| RF-06 | Mostrar cuatro categorías de tips y su detalle con recomendaciones, ejemplo y consejo. |
| RF-07 | Permitir consultar a Zyro sobre privacidad y seguridad digital. |
| RF-08 | Ofrecer instrucciones verificadas para eliminar o desactivar cuentas admitidas. |
| RF-09 | Gestionar consultas fuera de alcance, incertidumbre y errores del chat. |
| RF-10 | Seleccionar diez preguntas del banco revisado para cada intento. |
| RF-11 | Mostrar opciones de selección única, progreso y controles para continuar o revisar. |
| RF-12 | Calcular el resultado únicamente después de responder las diez preguntas. |
| RF-13 | Mostrar porcentaje de riesgo orientativo, nivel y recomendaciones relacionadas con las respuestas. |
| RF-14 | Permitir repetir el cuestionario mediante una nueva selección aleatoria. |
| RF-15 | Descartar respuestas y resultados según las reglas de temporalidad de la sección 9. |
| RF-16 | Permitir ajustar el tamaño del texto manteniendo la paleta definida. |
| RF-17 | Mostrar aviso de falta de conexión y permitir reintentar sin duplicar operaciones. |

## 7. Cuenta y ciclo de uso

### Registro

La vista incluye nombre, correo, contraseña, Crear cuenta y acceso a Iniciar sesión. Debe identificar campos obligatorios, mostrar validaciones por campo y permitir consultar la política de tratamiento antes de autorizar lo que corresponda. La justificación de cada dato se incorporará antes del cierre del spec.

Al completar el registro correctamente, el usuario accede al inicio. No se almacenan contraseñas en texto legible. La política de contraseñas, verificación de correo y duración de sesión se concretan en el plan técnico.

### Acceso y recuperación

El usuario puede iniciar sesión, cerrar sesión y solicitar recuperación de acceso. El mecanismo de recuperación debe verificar el control del medio de recuperación y evitar revelar datos de otras cuentas. Deben definirse caducidad, reintentos y mensajes en el plan técnico.

### Perfil y eliminación

El perfil permite consultar y gestionar los datos de cuenta, ajustar texto, cerrar sesión y solicitar eliminación. Cambiar información relevante requiere las verificaciones de identidad correspondientes. La eliminación debe indicar qué se suprime y si existe una obligación de conservación, con su fundamento y plazo. El perfil no muestra historial del cuestionario.

## 8. Zyro: alcance y confiabilidad

### Temas admitidos

- Contraseñas, autenticación y verificación en dos pasos.
- Privacidad en redes sociales, permisos y exposición de información.
- Señales de alerta en mensajes, enlaces y perfiles.
- Eliminación o desactivación de cuentas externas incluidas en un catálogo inicial.
- Medidas iniciales ante una posible cuenta comprometida y orientación hacia canales oficiales.
- Conceptos generales de protección de datos, sin asesoría legal individualizada.

### Reglas obligatorias

1. Explicar con lenguaje sencillo y pasos breves cuando la consulta lo requiera.
2. No acceder a cuentas, ejecutar acciones externas ni solicitar contraseñas o códigos.
3. No garantizar que un enlace, perfil o mensaje sea seguro o fraudulento.
4. No ayudar a vulnerar sistemas, acceder a cuentas ajenas u obtener datos privados.
5. Si no hay información verificada, reconocerlo y evitar inventar rutas o pasos.
6. Si una consulta requiere intervención profesional, explicar el límite y orientar a un canal adecuado.
7. Diferenciar eliminar y desactivar y explicar las consecuencias verificadas de cada opción.
8. Mantener guías apoyadas en fuentes oficiales revisadas, con fecha de revisión y plataforma o versión aplicable cuando corresponda.
9. Presentar las instrucciones dentro del chat, sin exigir abrir enlaces externos. Las referencias oficiales se conservan internamente para revisión y trazabilidad.
10. Avisar al usuario que no comparta información sensible y explicar los límites de conservación del proveedor una vez seleccionado.

Mensaje de presentación propuesto: **«Soy Zyro, tu asistente para aprender sobre privacidad y seguridad digital. Te orientaré paso a paso».**

El catálogo inicial de plataformas y el procedimiento de actualización están pendientes. La disponibilidad de una IA no sustituye la revisión de las guías.

## 9. Cuestionario y resultados

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

## 10. Historias de usuario y criterios de aceptación

### HU-01 — Crear cuenta y acceder (RF-01 a RF-03)

Como usuario, quiero crear una cuenta e iniciar sesión para acceder a Priva.

- **CA-01.1:** Dado un formulario vacío o inválido, cuando intento registrarme, se muestran errores comprensibles y no se crea una cuenta incompleta.
- **CA-01.2:** Dado un registro válido y la autorización aplicable, cuando se confirma su creación, accedo a Inicio.
- **CA-01.3:** Dadas credenciales inválidas o un fallo de conexión, se muestra un mensaje recuperable y no se concede acceso.
- **CA-01.4:** Dado que olvidé mi contraseña, puedo iniciar el flujo seguro de recuperación.

### HU-02 — Gestionar mi cuenta (RF-02 y RF-04)

Como usuario, quiero gestionar mi cuenta para controlar mi información en Priva.

- **CA-02.1:** Al entrar en Perfil solo consulto y modifico información de mi propia cuenta, con las verificaciones necesarias.
- **CA-02.2:** Al cerrar sesión, deja de estar disponible el contenido protegido hasta un nuevo acceso.
- **CA-02.3:** Al solicitar eliminación, recibo información sobre alcance, procedimiento y conservación aplicable.

### HU-03 — Navegar (RF-05)

Como usuario, quiero encontrar fácilmente las herramientas.

- **CA-03.1:** Las vistas autenticadas muestran Inicio, Perfil y menú inferior; registro y acceso no los muestran.
- **CA-03.2:** Al elegir una sección, se abre su vista y se identifica la opción activa.
- **CA-03.3:** Al volver desde un detalle, regreso según el historial sin crear bucles de navegación.

### HU-04 — Consultar tips (RF-06)

Como usuario, quiero consultar recomendaciones para proteger mis datos.

- **CA-04.1:** Tips presenta las cuatro categorías y un control «Ver más» por categoría.
- **CA-04.2:** Al abrir una categoría veo su contenido, ejemplo y consejo revisados.
- **CA-04.3:** Si falla la carga, se muestra un error y una opción para reintentar.

### HU-05 — Consultar a Zyro (RF-07 a RF-09)

Como usuario, quiero resolver dudas sobre privacidad y seguridad con explicaciones sencillas.

- **CA-05.1:** El chat muestra la identidad Zyro, su función, campo de mensaje y control de envío.
- **CA-05.2:** Una consulta admitida obtiene orientación comprensible; las instrucciones se organizan en pasos cuando corresponde.
- **CA-05.3:** Una plataforma sin guía verificada produce una explicación del límite, sin pasos inventados.
- **CA-05.4:** Una consulta fuera de alcance o dañina recibe una respuesta de límite y una alternativa apropiada.
- **CA-05.5:** Un fallo del servicio muestra opción de reintento sin duplicar mensajes por envíos repetidos.
- **CA-05.6:** El campo y el botón de envío permanecen visibles cuando se abre el teclado.

### HU-06 — Responder el cuestionario (RF-10 y RF-11)

Como usuario, quiero responder diez situaciones para identificar conocimientos que puedo mejorar.

- **CA-06.1:** Cada intento contiene diez preguntas activas y diferentes entre sí.
- **CA-06.2:** Cada pregunta permite una sola opción y muestra su posición de diez.
- **CA-06.3:** No puedo avanzar sin seleccionar respuesta; puedo revisar selecciones dentro del intento.
- **CA-06.4:** Cambiar el orden de las opciones no cambia la clave correcta.
- **CA-06.5:** Al interrumpir la app se descarta el intento y al regresar se solicita comenzar uno nuevo.

### HU-07 — Consultar resultados y repetir (RF-12 a RF-15)

Como usuario, quiero comprender el resultado y recibir acciones útiles.

- **CA-07.1:** Solo después de diez respuestas se muestra el porcentaje calculado según la regla aprobada.
- **CA-07.2:** Los valores de frontera 40 % y 80 % se clasifican como bajo y medio respectivamente.
- **CA-07.3:** El resultado muestra nivel en texto, explicación, aviso orientativo y recomendaciones vinculadas a las respuestas.
- **CA-07.4:** Repetir crea una nueva selección, sin prometer que todas las preguntas cambien.
- **CA-07.5:** No existe historial persistente de respuestas o resultados, tampoco en registros técnicos.

### HU-08 — Personalizar lectura y recuperar conexión (RF-16 y RF-17)

Como usuario, quiero leer cómodamente y comprender los errores de conexión.

- **CA-08.1:** Al aumentar texto, el contenido sigue siendo legible y operable sin superposiciones.
- **CA-08.2:** Los colores se mantienen y los estados se distinguen también mediante texto o etiquetas.
- **CA-08.3:** Sin conexión se muestra un aviso y, al recuperarla, el reintento no duplica registros ni envíos.

## 11. Privacidad, seguridad y conservación

### Marco y obligaciones

La política se fundamentará en la Ley 1581 de 2012 y su reglamentación aplicable, incluido el capítulo 25 del Decreto 1074 de 2015. La ley no fija una tabla universal de años para todos los datos. Los plazos deben responder a finalidades y obligaciones justificadas; una tabla por sí sola no acredita cumplimiento.

Antes de recoger datos, definir al responsable, finalidades, datos necesarios, autorizaciones aplicables, canales de atención y procedimientos para ejercer derechos. Conservar la prueba de autorización conforme a la normativa. Distinguir la supresión solicitada de las excepciones de conservación legal o contractual aplicables.

### Matriz inicial de conservación

| Categoría | Finalidad | Conservación y eliminación |
| --- | --- | --- |
| Nombre y correo | Identificación y acceso; justificación detallada pendiente | Durante la finalidad de cuenta, con evento y plazo final por aprobar. No asumir conservación indefinida. |
| Credenciales protegidas | Autenticación | Según sistema elegido y ciclo de cuenta; nunca contraseña legible. |
| Evidencia de autorización | Acreditar tratamiento autorizado | Plazo y fundamento por definir según obligaciones aplicables. |
| Respuestas y resultados | Autoevaluación educativa | Solo memoria temporal; eliminación según sección 9.7. |
| Mensajes del chat | Responder consultas | Plazo, ubicación y eliminación por definir tanto en Priva como en el proveedor. |
| Registros técnicos | Seguridad y operación | Minimizar datos; plazo justificado pendiente. Excluir respuestas y resultados del cuestionario. |
| Solicitudes de derechos | Atender consultas y reclamos | Plazo y fundamento por definir. |

La matriz definitiva debe incluir ubicación, responsable, método de eliminación, copias de seguridad y fundamento. No afirmar «el chat no guarda datos» hasta verificar los servicios utilizados. Si el proveedor trata datos fuera de Colombia, evaluar el régimen aplicable a la transferencia o transmisión y los acuerdos necesarios.

### Controles mínimos

- Conexiones cifradas y control de acceso a datos de cuenta.
- Contraseñas gestionadas mediante mecanismos seguros de autenticación.
- Credenciales de servicios protegidas, sin secretos embebidos en la app.
- Minimización de mensajes, analítica y registros; evitar información sensible innecesaria.
- Procesos verificables de eliminación y atención de incidentes.
- No enviar las respuestas del cuestionario al proveedor de IA para calcular resultados.

## 12. Requisitos no funcionales y experiencia móvil

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

## 13. Estados y errores

| Módulo | Estados y recuperación |
| --- | --- |
| Cuenta | Vacío, validación, enviando, éxito, fallo de acceso o conexión; corregir o reintentar. |
| Tips | Cargando, disponible, no disponible, error; reintentar. |
| Chat | Sin mensajes, escribiendo, procesando, respuesta, límite de alcance, información no verificada, error; reintentar. |
| Cuestionario | Inicio, pregunta pendiente, respondida, revisión, completado, interrumpido; nuevo intento cuando corresponda. |
| Resultado | Disponible temporalmente, descartado; realizar nuevo intento. |
| Perfil | Cargando, consulta, edición, validación, actualización o eliminación pendiente, error. |

Los mensajes deben indicar qué ocurrió y la acción posible sin revelar detalles internos ni datos de terceros.

## 14. Estrategia de pruebas

- **Funcionales:** cuenta completa, navegación, tips, consultas admitidas y rechazadas, reintentos y resultado.
- **Cuestionario:** selección sin duplicados, integridad de claves tras mezclar opciones, cobertura temática, respuestas obligatorias y fronteras del puntaje.
- **Interrupciones:** segundo plano, cierre, salida voluntaria, pérdida de red y retorno; comprobar descarte y ausencia de restauración.
- **Privacidad:** verificar que respuestas y resultados no aparecen en almacenamiento, analítica, registros ni copias. Auditar conservación del chat según proveedor.
- **Accesibilidad y compatibilidad:** texto ampliado, lector de pantalla, foco, teclado, diferentes móviles y versiones de la matriz aprobada.
- **Usabilidad:** participantes del público objetivo completan tareas y explican el significado del resultado sin interpretarlo como garantía.
- **Contenido:** revisar claves, explicaciones, guías y fechas; no confundir señales de alerta con pruebas concluyentes de fraude.

## 15. Métricas de éxito

Se mantienen las metas iniciales del documento base. Las mediciones se realizan mediante pruebas y datos agregados que no conserven respuestas individuales.

| Indicador | Meta | Método |
| --- | --- | --- |
| Participantes que completan registro | Al menos 80 % | Prueba de usuario. |
| Participantes que completan cuestionario | Al menos 70 % | Prueba de usuario. |
| Participantes que comprenden el resultado | Al menos 80 % | Pregunta de comprensión tras la tarea. |
| Participantes que comprenden los tips | Al menos 80 % | Prueba de comprensión. |
| Tareas completadas sin ayuda | Al menos 70 % | Prueba de usabilidad. |

Definir tamaño de muestra, denominador y condiciones antes de medir. No presentar estas metas como resultados obtenidos.

## 16. Riesgos y mitigaciones

| Riesgo | Mitigación |
| --- | --- |
| Interpretar el porcentaje como probabilidad real | Aviso visible, lenguaje educativo y pruebas de comprensión. |
| Guías externas desactualizadas | Fuentes oficiales, fecha de revisión y respuesta de incertidumbre. |
| Información inventada por la IA | Contenido verificado, límites de respuesta y pruebas de consultas sin soporte. |
| Recoger datos sensibles en el chat | Advertencia, minimización y revisión del proveedor. |
| Retención oculta en servicios o registros | Revisar configuración, contratos y trazabilidad de datos. |
| Frustración al perder cuestionario por segundo plano | Aviso antes de empezar y mensaje claro al regresar. |
| Intentos de dificultad desigual | Selección por temas y revisión editorial de dificultad. |
| Barreras de lectura o navegación | Texto ajustable y validación con público objetivo. |

## 17. Definición de terminado y trazabilidad SDD

La versión podrá considerarse terminada cuando:

- Las doce vistas y el ciclo de cuenta estén implementados y revisados.
- Los pendientes que afectan comportamiento, seguridad y compatibilidad estén resueltos.
- El banco definitivo tenga claves y recomendaciones revisadas y autorizadas para su uso.
- El cálculo aprobado sea reproducible y sus fronteras estén comprobadas.
- Zyro cumpla los límites y el catálogo aprobado tenga fuentes verificadas.
- La ausencia de persistencia del cuestionario se haya verificado.
- La política de tratamiento y la matriz de conservación estén aprobadas y aplicadas en los servicios elegidos.
- Se hayan ejecutado los criterios de aceptación y las pruebas con evidencia documentada.
- Se hayan corregido los defectos que impidan completar tareas o comprometan datos.
- El equipo haya aprobado el spec actualizado y la entrega.

Cada tarea de implementación debe referenciar RF/RNF y cada prueba los criterios CA correspondientes. Mantener separados constitución, spec funcional, plan técnico y tareas; este documento no fija una tecnología ni constituye aprobación jurídica de la operación.

## 18. Decisiones pendientes y propuestas

| ID | Pendiente | Condición de cierre |
| --- | --- | --- |
| PD-01 | Banco definitivo y tamaño inicial propuesto de 30 | Aprobar preguntas, opciones, claves, fuentes y derechos de uso. |
| PD-02 | Puntaje binario de igual peso propuesto | Aprobar fórmula y significado educativo; conservar umbrales acordados. |
| PD-03 | Catálogo inicial de plataformas de Zyro | Aprobar plataformas, guías y responsable de revisión. |
| PD-04 | Justificación de nombre, correo y cuenta obligatoria | Incorporar finalidad y necesidad de cada dato. |
| PD-05 | Conservación de cuenta, chat y registros | Aprobar plazos, eventos, fundamento, ubicaciones y eliminación. |
| PD-06 | Proveedores y arquitectura | Evaluar autenticación, IA y tratamiento de datos. |
| PD-07 | Compatibilidad mínima | Fijar versiones de Android/iOS y matriz de móviles. |
| PD-08 | Parámetros medibles de calidad | Fijar contraste, texto, tiempos y condiciones de prueba. |
| PD-09 | Detalle de cuenta | Fijar campos editables, verificaciones, recuperación y duración de sesión. |
| PD-10 | Pérdida de red durante intento activo | Aprobar la propuesta de suspensión en memoria de la sección 9.7. |

## 19. Fuentes y antecedentes

- **Documento base:** «Priva (1).pdf», 23 páginas, aportado por el equipo.
- **Decisiones posteriores:** aclaraciones del equipo sobre Android/iOS, alcance general de Zyro, navegación, internet obligatorio, ausencia de historial y umbrales de riesgo.
- [Ley 1581 de 2012 — compilación oficial de MinTIC](https://normograma.mintic.gov.co/mintic/compilacion/docs/ley_1581_2012.htm).
- [Decreto 1074 de 2015 — compilación oficial de Cancillería](https://www.cancilleria.gov.co/sites/default/files/Normograma/docs/decreto_1074_2015.htm), especialmente capítulo 25 y artículo 2.2.2.25.2.8 sobre limitación temporal.
- [INCIBE — tests de autoevaluación](https://www.incibe.es/ciudadania/formacion/autoevaluacion).
- [INCIBE — conocimientos generales](https://www.incibe.es/ciudadania/formacion/autoevaluacion/conocimientos-generales/preguntas).
- [INCIBE — refresca tus conocimientos en ciberseguridad](https://www.incibe.es/ciudadania/formacion/autoevaluacion/refresca-tus-conocimientos-en-ciberseguridad/preguntas).

Los recursos de INCIBE se identifican como referencias educativas. No se afirma haber integrado un banco externo con puntajes de vulnerabilidad ni disponer de una escala validada. La revisión normativa utilizada fundamenta esta propuesta documental; no reemplaza la validación de obligaciones concretas antes de operar.
