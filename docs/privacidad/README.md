# Revisión del documento aportado para Priva

El usuario aportó `guia_privacidad_datos_contacto_colombia.docx` como política.
Se conserva íntegro y se transcribe para revisión, sin convertir su contenido en
instrucciones del usuario o reglas de negocio aprobadas.

El texto se titula «Protección y conservación de datos de contacto en Colombia»;
se describe como guía de implementación y deja campos entre corchetes para
responsable, finalidades y contacto. No identifica al responsable de Priva.
Las referencias normativas no se han revalidado externamente en esta revisión.

## Adaptaciones necesarias

- Retirar teléfono/SMS y publicidad del alcance de Priva: no están autorizados.
- Incluir nombre, finalidad de saludo y correo para identidad/recuperación.
- Distinguir recomendaciones de conservación de decisiones efectivas; no adoptar
  automáticamente 30 días, revisión anual o rotación 30–90 días.
- Completar responsable, canal, procedimientos, vigencia, revisión de proveedores,
  calendario justificado y mecanismo de conservación de evidencia de autorización.

Se preparó `politica-priva.borrador.md`. No se instala en la app como una política
final ni se habilita el registro por aportar esta guía. El texto comercial de la
guía y sus ejemplos no autorizan nuevas funcionalidades.

## Datos necesarios del responsable

Nombre/razón social, identificación y domicilio aplicables; correo de atención y
persona/área responsable. El responsable debe revisar y aprobar la política adaptada,
el calendario y tratamiento con proveedores antes de usuarios reales.

El adaptador Firebase aún debe implementar alta y verificación; el bloqueo de
registro no se resuelve exclusivamente con publicar un documento. La recuperación
por enlace sí se ha implementado, con validación hospedada pendiente. No se considera
completo el spec001 ni resuelto el mecanismo de evidencia por este trabajo documental.
