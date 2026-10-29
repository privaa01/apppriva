# Feature Specification: F02 — Perfil y cuenta

**Feature Branch**: `work` (selección por directorio).
**Created**: 2026-10-21. **Updated**: 2026-10-29.
**Status**: Approved — usuario aprobó explícitamente esta revisión el 2026-10-29.
**SPECIFY_FEATURE_DIRECTORY**: `specs/002-perfil-cuenta`.
**Input**: «continua con el 002»; decisiones previas del usuario y wireframe P12.
**Gobierno**: [constitución v1.1.0](../../.specify/memory/constitution.md).
**Fuentes**: [spec original](../../docs/referencias/PRIVA_MOBILE_SPEC.md),
[referencia de P12](../../docs/referencias/ACTUALIZACION_PANTALLAS_2026-10-26.md),
[F01](../001-cuenta-acceso/spec.md),
[política vigente](../../docs/privacidad/politica-priva.md).

## User Scenarios & Testing *(mandatory)*

### HU-02 — Gestionar mi cuenta (RF-02 y RF-04; prioridad propuesta P1)

Como usuario de Priva, quiero consultar mi perfil, controlar mi sesión y conocer
cómo solicitar la eliminación de mis datos para gestionar mi propia cuenta.

**Por qué esta prioridad:** el perfil utiliza la cuenta de F01 y permite ejercer
control sobre su uso. P1 se propone para esta funcionalidad; no fija fechas ni
prioridad de los otros specs.

**Prueba independiente:** con dos cuentas de prueba distintas, abrir Perfil,
consultar datos propios, ejecutar las acciones permitidas, cerrar sesión e intentar
volver mediante retroceso/ruta directa. Comprobar solicitud de eliminación y salida
sin enviar correos reales automáticamente. No exige implementar Tips, chat,
cuestionario o resultados: se comprueban sus fronteras de acceso.

**Recorrido:** sesión válida → Perfil P12 → consulta → gestión permitida →
confirmación/error; o información de eliminación → redacción de solicitud por correo;
o cerrar sesión → acceso sin contenido privado.

**Criterios de aceptación:**

- **CA-02.1:** Dada una sesión válida, Perfil muestra nombre y correo de esa cuenta;
  otra identidad o un visitante no puede consultar ni modificar esos datos.
- **CA-02.2:** Al cerrar sesión desaparece inmediatamente el contenido protegido;
  retroceso, ruta directa y reapertura de Perfil no lo recuperan sin nuevo acceso.
- **CA-02.3:** Al consultar eliminación, se informa el canal
  `priva202611@gmail.com`, que debe enviarse la solicitud, el alcance a revisar y
  que cualquier conservación requiere fundamento; no se afirma eliminación realizada.
- **CA-02.4:** Nombre y correo coinciden con la cuenta activa. Carga o error no
  muestran valores de ejemplo como «Mariana» o datos de la sesión anterior.
- **CA-02.5:** No aparece teléfono, estado de riesgo ni historial del cuestionario.
  La fila vacía del wireframe no representa un campo ni una función nuevos.
- **CA-02.6:** El usuario puede
  cambiar únicamente el nombre de saludo. Guardar muestra éxito solo tras confirmar
  la actualización; al reabrir Perfil aparece el valor guardado.
- **CA-02.7:** En edición, cancelar no cambia el nombre. Un nombre
  vacío o compuesto solo por espacios no se guarda. Error/red caída conserva el
  nombre confirmado anterior y permite reintentar sin duplicar efectos.
- **CA-02.8:** El correo se muestra de solo lectura. No se ofrecen cambios de correo,
  contraseña, teléfono o identidad desde Perfil en este alcance.
- **CA-02.9:** Si la sesión deja de ser válida mientras se muestra o gestiona Perfil,
  no se concede acceso ni se acepta una modificación como otra identidad.
- **CA-02.10:** Cerrar sesión descarta datos de perfil visibles y datos temporales
  sensibles. No se conserva contenido privado accesible mediante retroceso.
- **CA-02.11:** Tras cerrar sesión, Tips sigue disponible sin cuenta. Los demás
  contenidos requieren nuevo acceso, aunque sus botones sean visibles.
- **CA-02.12:** Si falla la conexión al cerrar sesión, la app deja de mostrar datos
  privados. Informa el problema sin prometer revocación de todas las sesiones remotas.
- **CA-02.13:** La opción de eliminación prepara un correo dirigido al canal indicado;
  no lo envía automáticamente. Cancelar la redacción no elimina cuenta ni datos.
- **CA-02.14:** Si no hay app de correo o no puede abrirse, se muestra el destinatario
  y se permite copiarlo, con instrucciones para enviar desde el correo asociado.
- **CA-02.15:** Abrir el redactor no se presenta como solicitud enviada, recibida,
  tramitada o completada; el envío lo realiza el usuario en su aplicación de correo.
- **CA-02.16:** El correo preparado no incluye automáticamente contraseña, tokens,
  códigos, respuestas/resultados, datos de otras personas ni información técnica.
- **CA-02.17:** La solicitud de eliminación no borra ni reescribe la evidencia de
  autorización por una acción directa del cliente. La supresión efectiva se tramita
  por el equipo de Priva con verificación proporcional de identidad y obligaciones.
- **CA-02.18:** Con texto al 200% y teclado abierto cuando corresponda, todas las
  acciones esenciales siguen alcanzables sin recortes ni desbordamientos.
- **CA-02.19:** Con el lector de pantalla de Android, datos, acciones, carga, errores
  y confirmaciones se identifican en un orden comprensible; los controles tienen
  nombre accesible y el estado no depende solo del color.

### Edge Cases

- Visitante, cuenta no verificada, sesión vencida/revocada o cambio de identidad.
- Carga lenta, datos incompletos o error al consultar perfil.
- Pulsaciones repetidas, salida durante guardado y respuesta tardía.
- Nombre con espacios, acentos o caracteres legítimos: no añadir reglas de identidad
  no justificadas ni modificar el correo por interpretar el nombre.
- Cierre de sesión con red caída o intento de volver a la pantalla privada.
- Dispositivo sin app de correo, cancelación o fallo al abrir redactor/copiar dirección.
- Cuestionario activo en módulos futuros: cierre descarta respuestas/resultados,
  pero este spec no crea ni persiste un cuestionario para demostrar esa frontera.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-02:** Permitir iniciar/cerrar sesión y recuperar acceso de forma segura.
  F02 implementa la presentación y comportamiento de cierre en Perfil, reutilizando
  las reglas aprobadas; registro, acceso y recuperación pertenecen a F01.
- **RF-04:** Consultar y gestionar la propia cuenta y solicitar eliminación.
  En F02 comprende nombre/correo, edición del nombre, cierre e información/redacción
  de solicitud por correo. No incluye eliminación instantánea ni administración de
  cuentas ajenas.
- **RF-04.a:** Mostrar los estados de carga, ausencia de datos, error recuperable
  y éxito sin exponer errores internos o credenciales.
- **RF-04.b:** Mantener aislamiento entre cuentas tanto en pantalla como al acceder
  a sus datos; cambiar una ruta o identificador no habilita datos ajenos.
- **RF-04.c:** Requerir autorización de sesión en cualquier gestión. Una casilla de
  consentimiento o un control visible no sustituye autenticación.
- **RF-04.d:** Equipo de Priva como responsable y `priva202611@gmail.com` como canal
  de eliminación, según decisión explícita del usuario. No inventar plazos de
  conservación, promesas de borrado inmediato ni garantías de cumplimiento jurídico.
- **RF-04.e:** No recoger datos nuevos para solicitar eliminación desde la app.
  Informar que la solicitud debe enviarse desde el correo de la cuenta; verificación
  adicional proporcional y tratamiento del caso corresponden al equipo responsable.
- **RF-04.f:** Las finalidades existentes se conservan: nombre para saludo y correo
  para identificación/recuperación. La evidencia de autorización de alta no se
  modifica por consultar Perfil o cambiar el nombre.

### Pantalla y límites visuales

P12 usa el wireframe corregido recibido el 2026-10-26: cabecera Inicio/Perfil,
saludo, correo y Cerrar sesión; menú Tips/Chat IA/Cuestionario según las fronteras
existentes. No añadir avatar personalizable, carga de fotos, teléfono, puntuación
de riesgo o historial por inferencia. Icono de perfil genérico, sin pedir permisos.

Los controles nuevos necesarios para RF-04 se revisan en el plan; no convertir la
fila vacía en dato. El usuario confirmó edición únicamente del nombre. La información de
eliminación debe ser accesible desde Perfil sin ocultar los controles esenciales.
El ajuste de tamaño propio de la app pertenece a F08; F02 respeta el tamaño del
sistema y no añade una preferencia incompleta o un botón sin función.

### Acceso y ciclo de datos

Solo una sesión válida con correo verificado puede gestionar Perfil; recuperación
o verificación pendiente no equivalen a acceso completo. Sin sesión, Tips y sus
cuatro categorías siguen públicos, además de los flujos de entrada de F01.

El cierre de F02 debe respetar el descarte obligatorio del cuestionario cuando se
integre F06/F07. La evidencia de pruebas usa datos sintéticos; nunca conservar
respuestas/resultados reales para demostrar descarte.

### Key Entities

- **Perfil propio:** identificador de cuenta y nombre de saludo. Nombre editable, correo solo lectura.
- **Identidad de acceso:** correo de la cuenta, solo lectura en F02.
- **Sesión actual:** concede o deniega gestión propia; cerrar aquí no promete cerrar
  automáticamente otros dispositivos.
- **Intención de solicitar eliminación:** información y borrador de correo controlado
  por la persona; abrir el redactor no crea un expediente recibido.
- **Evidencia de autorización:** antecedente de F01, sin escritura/modificación por
  las acciones de este perfil. Su conservación y supresión se gestionan por separado.

No se crea entidad de teléfono, historial del cuestionario, imagen personal, buzón
interno de solicitudes, chatbot de soporte ni lista de contactos.

## Success Criteria *(mandatory)*

- **SC-02.1:** En todos los casos de aislamiento aprobados, cero accesos o cambios a
  datos ajenos, sin sesión o después de cerrar sesión.
- **SC-02.2:** Todas las consultas muestran los datos de la identidad activa o un
  estado recuperable, sin datos de ejemplo o de la identidad anterior.
- **SC-02.3:** Todos los casos de edición aprobados distinguen
  guardar/cancelar/error; ningún guardado fallido se informa como exitoso.
- **SC-02.4:** En las pruebas con/sin aplicación de correo, el destinatario es correcto
  y siempre existe una vía de conocer/copiar el canal. Cero envíos automáticos o
  afirmaciones falsas de eliminación completada.
- **SC-02.5:** Consulta, cierre y solicitud por correo pueden completarse con texto200%
  y lector de pantalla Android; cero acciones esenciales inaccesibles en la matriz
  y estados definidos por el plan.

Estos resultados son objetivos, no pruebas ejecutadas ni una nueva muestra/plazo
inventados. El plan fijará la matriz y métodos de evaluación con trazabilidad.

## Assumptions

- Android únicamente, público de 40–65 años; internet para operaciones de cuenta.
- F01 aporta identidad, verificación, política y evidencia; F02 no vuelve a elegir
  proveedor ni sustituye su modelo de autorización.
- F03/F04/F05/F06/F07/F08 conservan sus propios alcances y puertas de aprobación.
- No hay cambios de correo o contraseña en Perfil. La contraseña se recupera por
  enlace en F01. El nombre no es un identificador para autenticar.
- La eliminación es una solicitud por correo al equipo, no borrado automático.
  La revisión operativa/jurídica de conservación del001 sigue registrada por separado;
  este spec no la declara ejecutada ni fija un plazo legal.

## Decisión confirmada — 2026-10-29

**Q1:** El usuario eligió «Editar nombre; correo de lectura (recomendado)».
Se permite editar solo el nombre de saludo; CA-02.6/02.7 y SC-02.3 forman parte del
alcance propuesto. La respuesta aprueba esa decisión, no el spec completo ni su plan.
No hay aclaraciones funcionales pendientes. La aprobación completa posterior se registra abajo.

## Gobierno y trazabilidad

El usuario confirmó que verificó los flujos del001 y luego indicó «continua con el
002». Esto autoriza revisar F02, sin afirmar nuevas pruebas independientes del001
ni aprobar por extensión este borrador, el plan o la implementación del002.

Se conservan HU-02, RF-02/RF-04 y CA-02.1–02.3. Los criterios adicionales concretan
consulta, errores, aislamiento y solicitud sin duplicar el detalle del001. PD-04
usa las finalidades confirmadas; proveedores y recuperación ya decididos se tratan
como antecedentes del001. PD-09 se concreta aquí en la edición del nombre confirmada. PD-05 no se cierra inventando
conservación: la solicitud remite al procedimiento del responsable.

Antes de planificar: aprobar explícitamente este spec revisado y su prioridad. Commit/push conserva borradores, no reemplaza aprobación.

## Aprobación del spec — 2026-10-29

El usuario respondió «lo apruebo» a la solicitud de aprobar el spec002 revisado
del commit a6c68a4 para elaborar el plan técnico. Quedan aprobados el alcance,
CA-02.1–02.19 y prioridad P1 propuestos, incluida la edición exclusiva del nombre.
Se autoriza preparar el plan, no generar/ejecutar tareas ni implementar F02.
La aprobación no modifica los resultados o aplazamientos registrados del001.
