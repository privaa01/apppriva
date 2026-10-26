# Feature Specification: F05 — Orientación verificada mediante Zyro

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

### HU-05 — Consultar a Zyro (RF-07 a RF-09)

Como usuario, quiero resolver dudas sobre privacidad y seguridad con explicaciones sencillas.

- **CA-05.1:** El chat muestra la identidad Zyro, su función, campo de mensaje y control de envío.
- **CA-05.2:** Una consulta admitida obtiene orientación comprensible; las instrucciones se organizan en pasos cuando corresponde.
- **CA-05.3:** Una plataforma sin guía verificada produce una explicación del límite, sin pasos inventados.
- **CA-05.4:** Una consulta fuera de alcance o dañina recibe una respuesta de límite y una alternativa apropiada.
- **CA-05.5:** Un fallo del servicio muestra opción de reintento sin duplicar mensajes por envíos repetidos.
- **CA-05.6:** El campo y el botón de envío permanecen visibles cuando se abre el teclado.

**Prioridad:** pendiente de aprobación; la numeración es identificación, no orden de entrega.
**Independent Test:** ejecutar los criterios CA anteriores en las pantallas asignadas,
con sus precondiciones de sesión y contenido, comprobando el resultado funcional
sin exigir implementar otras historias conforme a esta especificación; las pruebas aún no se han ejecutado.
**Recorrido:** Consulta → orientación breve o pasos verificados; consulta no sustentada/fuera de alcance → límite explícito; fallo → reintento sin duplicación.

### Edge Cases

Plataforma sin guía; petición de credenciales; consulta dañina; incertidumbre; proveedor caído; teclado ocultando envío; envíos repetidos.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-07**: Permitir consultar a Zyro sobre privacidad y seguridad digital.
- **RF-08**: Ofrecer instrucciones verificadas para eliminar o desactivar cuentas admitidas.
- **RF-09**: Gestionar consultas fuera de alcance, incertidumbre y errores del chat.

### Asociación a pantallas

P07 (PDF 5).

**Brechas observadas:** La conversación sobre Instagram es ilustrativa, no guía verificada ni catálogo aprobado; confirmar control de envío: el icono visible es ambiguo. Faltan aviso de datos sensibles y estados de incertidumbre/error.

### Reglas de la fuente aplicables

Los siguientes extractos conservan su estado original: una propuesta o un pendiente
NO se convierte en decisión por copiarse aquí. Las secciones compartidas son contexto,
no duplicación de responsabilidad; véase [el índice SDD](../README.md) para el reparto F06/F07.

### 8. Zyro: alcance y confiabilidad

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

### Key Entities

Mensaje, respuesta y guía con fuente oficial y fecha; conservación de mensajes por definir, distinta de la prohibición del cuestionario.

## Success Criteria *(mandatory)*

### Measurable Outcomes

CA-05.1 a CA-05.6 satisfechos; las consultas no verificadas no reciben rutas inventadas ni promesas de protección. Tiempos pendientes en PD-08.

La evidencia de implementación y las mediciones aún no existen. Las metas del §15
no son resultados obtenidos. Toda prueba usará datos sintéticos cuando corresponda;
no se guardarán respuestas ni resultados reales para demostrar cumplimiento.

## Assumptions

- Se conserva Android/iOS, público de 40–65 años e internet obligatorio (§§1–3).
- Las imágenes son referencia visual: sus ejemplos y textos no aprueban reglas nuevas.
- Acceso F01, navegación F03 y F08. Catálogo y proveedor pendientes; no se aprueba una plataforma por aparecer en un ejemplo.
- Aplican §§11–17 del spec: minimización, conservación justificada, seguridad,
  accesibilidad, estados de error y trazabilidad. No se presumen proveedores ni plazos.

## Decisiones y aprobación pendientes

Pendientes originales asociados: PD-03, PD-05, PD-06, PD-08.
Consultar sus condiciones de cierre en §18 del spec fuente. Las brechas de pantalla
se resuelven en el registro del índice, sin modificar silenciosamente el original.
Antes de `$speckit-plan`, resolver los pendientes aplicables y obtener aprobación explícita de la constitución y de este spec. Separar el documento no constituye esa aprobación.
