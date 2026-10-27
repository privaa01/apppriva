# Feature Specification: F01 — Cuenta y acceso

**Feature Branch**: `work` (selección por directorio, sin rama nueva)
**Created**: 2026-10-21
**Updated**: 2026-10-27
**Status**: Base funcional aprobada el 2026-10-26; aclaración de mensajes del análisis 001 pendiente de ratificación, sin cambio de alcance.
**SPECIFY_FEATURE_DIRECTORY**: `specs/001-cuenta-acceso`
**Input**: `/speckit-specify001`, interpretado como revisión de la funcionalidad existente F01.
**Gobierno**: [constitución v1.0.0 ratificada](../../.specify/memory/constitution.md).
**Fuentes**: [spec original §§5–7, 10–15 y 18](../../docs/referencias/PRIVA_MOBILE_SPEC.md),
[wireframes](../../docs/referencias/app.pdf) y
[decisiones confirmadas](../../docs/referencias/ACTUALIZACION_PANTALLAS_2026-10-26.md).

## User Scenarios & Testing *(mandatory)*

### HU-01 — Crear cuenta y acceder (prioridad: P1)

Como usuario de Priva, quiero crear una cuenta, iniciar sesión y recuperar el acceso
para utilizar las funciones protegidas sin perder la posibilidad de consultar Tips
cuando no tengo sesión.

**Why this priority:** es la entrada a las funciones protegidas. P1 expresa el orden funcional aprobado con este spec, no un calendario
ni autorización de implementación.

**Independent Test:** con una cuenta de prueba y las precondiciones de autorización
aprobadas, ejecutar registro, acceso válido e inválido y recuperación; comprobar que
Tips sigue siendo público y que solo una sesión válida habilita contenido protegido.
No se exige implementar el contenido de Zyro o el cuestionario para validar la puerta
de acceso. Este documento define pruebas futuras, no declara resultados ejecutados.

**Acceptance Scenarios — IDs originales preservados:**

- **CA-01.1:** Dado un formulario vacío o inválido, cuando intento registrarme, se muestran errores comprensibles y no se crea una cuenta incompleta.
- **CA-01.2 (revisado por decisión del usuario):** Dado un registro válido y la autorización aplicable, la creación de cuenta no habilita por sí sola las funciones protegidas. Tras verificar el correo y establecer una sesión válida, accedo a Inicio. Hasta entonces puedo consultar Tips sin acceso al resto del contenido protegido.
- **CA-01.3:** Dadas credenciales inválidas o un fallo de conexión, se muestra un mensaje recuperable y no se concede acceso.
- **CA-01.4:** Dado que olvidé mi contraseña, puedo iniciar el flujo seguro de recuperación.

**Escenarios adicionales trazables:**

- **CA-01.5:** Dado P10, cuando reviso los campos, veo nombre, correo y contraseña, sus etiquetas y obligatoriedad; no se solicita teléfono.
- **CA-01.6:** Antes de la autorización aplicable al registro, puedo consultar la política de tratamiento; no se presupone aceptación por abrir la app o por escribir datos.
- **CA-01.7:** Dado P11, puedo introducir correo y contraseña y activar Iniciar sesión; el teclado no oculta el campo enfocado ni la acción necesaria.
- **CA-01.8:** Dado un fallo o envío repetido de registro, el reintento no crea cuentas duplicadas; el mensaje no expone datos de otras personas.
- **CA-01.9:** Dado un intento de recuperación, se utiliza un código enviado al correo asociado. No se permite cambiar credenciales sin validar el código y el control de ese medio; los mensajes no permiten identificar cuentas ajenas. No se solicita teléfono.
- **CA-01.10:** Dado un fallo recuperable, se informa qué ocurrió y qué puede hacer el usuario, sin mostrar credenciales ni detalles técnicos internos.
- **CA-01.11:** Dada una cuenta con correo no verificado, un intento de acceso no habilita contenido protegido. El mensaje público es el mismo para correo inexistente, contraseña incorrecta y correo no verificado: «No pudimos iniciar sesión. Revisa tus datos o verifica el correo con el que te registraste». No confirma que la cuenta exista o esté pendiente de verificación; Tips continúa disponible.
- **CA-01.12:** Dado un código de recuperación incorrecto o vencido según la configuración aprobada del plan, no se cambian credenciales; se ofrece una acción recuperable sin revelar datos de otras cuentas.
- **CA-01.13:** Dada la recuperación mediante código válido, puedo completar el cambio de credenciales y volver a iniciar sesión conforme a las reglas de verificación; no se presupone inicio automático de sesión por recuperar acceso.

**Criterios compartidos de acceso ya confirmados:**

- **CA-ACC-01:** Sin sesión, abrir Tips y cada una de sus cuatro categorías permite consultar contenido sin exigir cuenta.
- **CA-ACC-02:** Sin sesión, intentar abrir Inicio, Perfil, Zyro, Cuestionario o Resultados no muestra contenido protegido e informa que se requiere iniciar sesión.
- **CA-ACC-03:** Con una sesión válida se puede acceder a todas las funciones del alcance, sujeto a sus precondiciones; no se muestran resultados sin completar un intento.
- **CA-ACC-04:** Tras cerrar sesión, Tips sigue disponible y el contenido protegido deja de estarlo, incluido mediante retroceso; respuestas y resultados se descartan. El cierre y descarte se implementan en F02/F06/F07; F01 verifica su frontera de acceso.
- **CA-ACC-05:** La navegación visible de P11 se conserva conforme al wireframe sin eludir las restricciones anteriores.

### Edge Cases

- Campos obligatorios vacíos o formato inválido: señalar el campo y permitir corregirlo;
  la política concreta de contraseñas queda para el plan, no se inventa aquí.
- Correo ya asociado, credenciales incorrectas o solicitud de recuperación para otra
  persona: no revelar existencia ni información de cuentas; validar los mensajes
  para evitar que distingan casos que deberían permanecer indistinguibles.
- Falta de internet, fallo del servicio o doble pulsación: recuperación comprensible
  sin crear registros duplicados ni dar acceso sin autenticación válida.
- Fallo tras enviar registro sin confirmación al usuario: el reintento debe respetar
  la no duplicación; no se prescribe aquí el mecanismo técnico.
- Recuperación sin prueba válida de control: no cambiar credenciales. Caducidad,
  límites de reintento y tratamiento de solicitudes vencidas se concretan en el plan.
- Control protegido visible sin sesión o retroceso después del cierre: no mostrar
  contenido protegido ni bloquear el acceso público a Tips.
- Texto ampliado, lector de pantalla y teclado: campos y acciones siguen identificables
  y operables según los valores que cierre F08.

## Requirements *(mandatory)*

### Functional Requirements

| ID original | Obligación en F01 | Aceptación asociada |
| --- | --- | --- |
| RF-01 | Permitir crear cuenta con nombre, correo y contraseña, validando campos y formato; no solicitar teléfono. Nombre para personalizar el saludo; correo para identificar cuenta y recuperar acceso, finalidades confirmadas por el usuario. | CA-01.1, 01.2, 01.5, 01.6, 01.8 |
| RF-02 | Permitir iniciar sesión y recuperar acceso mediante un mecanismo seguro. El cierre de sesión pertenece a F02; aquí se valida que se respete su efecto sobre acceso. | CA-01.2–01.4, 01.7, 01.9, 01.11–01.13; CA-ACC-02–04 |
| RF-03 | Mostrar errores comprensibles sin exponer datos de terceros ni permitir inferir existencia de cuentas. | CA-01.1, 01.3, 01.8–01.10 |

**Controles transversales vinculados:** RF-05 para navegación y permisos visibles;
RF-17 para reintentos sin duplicación; RNF-01–08 para lenguaje, lectura, accesibilidad,
contraste, móviles, teclado, internet y privacidad. F01 aplica esos controles sin
apropiarse de todo el alcance de F03/F08.

### Alcance y pantallas

| Vista/flujo | Contenido y comportamiento | Referencia |
| --- | --- | --- |
| P10 Crear cuenta | Nombre, correo, contraseña, Crear cuenta y acceso a Iniciar sesión; política/autorización aplicable y errores por campo. | PDF página 2; controles pendientes de completar visualmente. |
| P11 Iniciar sesión | Correo, contraseña e Iniciar sesión; conservar cabecera y navegación del wireframe, aplicando la restricción por sesión. Ofrecer inicio de recuperación. | Imagen aportada el 2026-10-26. |
| Recuperación | Solicitud de código al correo asociado, comprobación y cambio de credenciales; estados dentro del flujo existente, sin imponer pantalla principal adicional. | Spec §7, CA-01.4/01.9/01.12/01.13 y respuesta Q3. |
| P01 Inicio | Destino tras verificar correo y establecer sesión válida; la cuenta no verificada no accede. No es contenido público. | PDF página 1; contenido y navegación en F03. |
| P02–P06 Tips | Acceso sin cuenta ni sesión; no convierte otras funciones en públicas. | Decisión explícita del usuario; contenido en F04. |

**Fuera del alcance de implementación de F01:** edición/eliminación y cierre de cuenta
(F02), contenido de Inicio (F03), contenido de Tips (F04), chat (F05), cuestionario y
resultado (F06/F07). Sus fronteras de autorización sí se consideran aquí. No se añaden
acceso por teléfono, SMS, inicio con redes sociales ni modos offline.

### Privacidad y seguridad funcional

- Aplicar las finalidades confirmadas: nombre para personalizar el saludo y correo
  para identificar cuenta y recuperar acceso. No pedir teléfono ni credenciales de
  cuentas externas. La necesidad de la cuenta se limita al acceso protegido, no a Tips.
- Permitir consultar la política antes de la autorización aplicable; identificar
  responsable, finalidades y canales de derechos mediante la documentación aprobada.
- No almacenar contraseñas en texto legible ni exponerlas en registros o mensajes.
  Los secretos de servicios no deben quedar embebidos en la aplicación.
- Aplicar la matriz de conservación aprobada a cuenta, prueba de autorización y registros;
  no inventar plazos ni afirmar cumplimiento normativo por este documento.
- No confundir recuperar credenciales de la cuenta Priva con recuperar cuentas de
  plataformas externas, que queda fuera de la capacidad de la app.

### Key Entities

- **Cuenta Priva:** identidad de la persona para usar funciones protegidas; nombre y
  correo conforme a las finalidades confirmadas; no incluye teléfono ni historial
  del cuestionario.
- **Credenciales protegidas:** prueba de acceso a la propia cuenta; no se define proveedor
  ni forma técnica de almacenamiento en este spec.
- **Autorización aplicable:** evidencia de la autorización asociada a finalidades y
  política aprobadas; conservación por definir con fundamento.
- **Solicitud de recuperación:** petición de código al correo asociado y validación
  del control de ese medio; la solicitud por sí sola no acredita identidad.
- **Verificación de correo:** pendiente o completada; es una precondición del acceso protegido,
  sin definir el mecanismo de verificación ni confundirlo con el código de recuperación.
- **Estado de acceso:** sin sesión o sesión válida; determina permiso de consulta,
  sin prescribir duración, mecanismo ni almacenamiento de sesión.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001:** al menos 80 % de participantes completa registro, meta del spec §15.
  Antes de medir se deben aprobar muestra, denominador y condiciones; no es un resultado obtenido.
- **SC-002:** ninguno de los casos de credenciales inválidas, recuperación no verificada
  o ausencia de sesión del conjunto de aceptación concede contenido protegido.
- **SC-003:** cada una de las cuatro categorías de Tips puede consultarse sin cuenta
  en los recorridos de aceptación definidos, y ningún formulario solicita teléfono.
- **SC-004:** los casos de reintento y envío repetido del conjunto de aceptación no
  generan cuentas duplicadas ni mensajes con información de otras cuentas.
- **SC-005:** todos los escenarios CA-01 y CA-ACC aplicables tienen resultado registrado
  y satisfactorio antes de aprobar la entrega; las pruebas de módulos relacionados
  se completan en sus propias funcionalidades sin declarar cobertura ejecutada aquí.

Los presupuestos de tiempos corresponden a PD-08/RNF-09 y se fijarán en el plan;
no se inventan metas de velocidad. La evidencia usa cuentas de prueba y no conserva
respuestas ni resultados reales del cuestionario.

## Assumptions

- Android/iOS, público principal de 40–65 años e internet obligatorio se mantienen.
- Constitución v1.0.0 ratificada: esa aprobación no implica aprobación de este spec.
- La numeración 001 selecciona una funcionalidad existente; no autoriza crear otra.
- Los wireframes son referencia visual y sus ejemplos no son datos reales ni requisitos nuevos.
- F02 comparte el ciclo de cuenta; F03 coordina navegación; F04 mantiene Tips público;
  F08 define parámetros medibles transversales. No se selecciona tecnología por dependencia.

## Clarificaciones resueltas — 2026-10-26

| ID | Respuesta explícita del usuario | Efecto en este spec |
| --- | --- | --- |
| Q1 / PD-04 | Sí, confirmar esas finalidades | Nombre para personalizar el saludo; correo para identificar la cuenta y recuperar acceso. No fija conservación ni habilita otros usos. |
| Q2 / PD-09 | Verificar correo antes de habilitar acceso completo | La creación de cuenta no concede contenido protegido hasta verificar el correo y tener sesión válida; CA-01.2 se revisa y CA-01.11 cubre la restricción. |
| Q3 / PD-09 | Código de recuperación enviado al correo | Recuperación con código al correo asociado, sin teléfono; CA-01.9/01.12/01.13 cubren el flujo. |

Estas respuestas resolvieron las decisiones indicadas; la aprobación posterior
del spec completo se registra a continuación. La verificación de correo y la recuperación son flujos
distintos: elegir código para recuperación no elige el mecanismo de verificación.

**Decisiones para el plan y la documentación de datos:** PD-05 exige conservación,
responsable, política y evidencia de autorización con fundamento antes de recoger datos.
PD-06, los parámetros de PD-09 y PD-08/RNF-09 se resuelven al planificar: proveedores,
arquitectura, mecanismo de verificación del correo, política de contraseña, caducidad
y uso de códigos, reintentos, duración de sesión y presupuestos de calidad.
No se inventan plazos legales. SC-001 requiere aprobar muestra, denominador y
condiciones antes de medir, no un resultado supuesto para poder redactar el spec.

## Registro de aprobación

El 2026-10-26, el usuario respondió «apruebo» a la solicitud de aprobación del
spec 001 con Q1–Q3 incorporadas (contenido del commit `626d4b1`). Quedan aprobados
su alcance funcional, escenarios y prioridad P1. Esta aprobación cierra la puerta
de especificación de F01 y permite solicitar su planificación como siguiente etapa.

No aprueba proveedores, arquitectura, conservación ni parámetros de seguridad
reservados al plan y a la documentación de datos. No constituye evidencia de pruebas
ni aprueba los otros siete specs. Esta operación registra la aprobación; no inicia
planificación, tareas ni implementación.

## Aclaración propuesta tras análisis 001 — 2026-10-27

Corrección autorizada por el usuario: precisar CA-01.11 para cumplir RF-03 sin
revelar estado de cuentas. El aviso de acceso fallido se comparte entre los tres
casos indicados; no se usa un error crudo de Auth como señal pública de existencia.
Un flujo iniciado de registro/confirmación puede explicar el siguiente paso sin
certificar a terceros que un correo pertenece a una cuenta. Los errores de formato
siguen siendo por campo y no deben consultar existencia de cuentas.
Esta aclaración documental no aprueba las tareas ni autoriza implementación.
