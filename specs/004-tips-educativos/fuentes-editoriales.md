# F04 — Registro de fuentes editoriales

**Fecha de revisión:** 2026-11-04, zona del usuario. **Versión editorial:**1.0.0.
**Estado actual:** contraste completado mediante NIST, FTC, RFC Editor y Google
el2026-11-05. Las incidencias de red anteriores se conservan como historial;
CISA no se declara consultada ni necesaria tras las fuentes alternativas primarias.
**Responsable editorial:** responsable del proyecto, por sus mensajes de contenido
y aprobación A1–A5. No se incorpora identidad personal a documentos de contenido.

## Textos y diseño aprobados

E0: mensaje del usuario con cuatro categorías/textos y orden de conservar wireframes;
E1: «si los apruebo» sobre A1–A5. Artefacto canónico:
[contenido-editorial.md](contenido-editorial.md). PDF original conservado en
`docs/referencias/app.pdf`; páginas4/6/8/9/10 inspeccionadas visualmente en esta
revisión. Son fuentes del producto, no autoridad técnica de los consejos.

## N1 — NIST SP800-63B-4, Appendix A: Strength of Passwords

**Fuente primaria consultada:** repositorio oficial `usnistgov/800-63-4`, revisión
`4f2487bb81adecdc84ccaac6920bf0b500b379ae`.

- Documento: https://github.com/usnistgov/800-63-4/blob/4f2487bb81adecdc84ccaac6920bf0b500b379ae/sp800-63b/passwords/index.html
- Secciones: introducción, Length y Complexity. Lectura local del HTML del
  repositorio obtenido por HTTPS con autenticación/proxy existente y TLS activo.
- Contraste: longitud y frases favorecen la memorabilidad; las reglas de composición
  tienen límites y producen elecciones predecibles; claves complejas no evitan por
  sí mismas phishing o ingeniería social. Aplicable a P03/A1/A5.
- Límite: no convertir la recomendación educativa de mezclar caracteres en una
  exigencia universal de servicio; no cambiar la política de contraseña Priva.
  NIST no se usa para certificar el ejemplo ni garantizar seguridad de otras cuentas.
- No cubre por sí solo todas las recomendaciones de redes sociales y perfiles.

## Fuentes por verificar antes de cerrar revisión editorial (histórico)

> **Histórico:** esta tabla y la acción siguiente describen el bloqueo anterior al
> 2026-11-05. El cierre del contraste documentado más abajo las resolvió; se conservan
> solo como registro y no representan el estado vigente.

| ID | Fuente primaria / propósito | Estado y alcance pendiente |
| --- | --- | --- |
| C1 | https://www.cisa.gov/secure-our-world/use-strong-passwords | GET intentado:403 por proxy. Verificar unicidad y frases de contraseña, P03. No se declara leída. |
| C2 | https://www.cisa.gov/secure-our-world/recognize-and-report-phishing | Referencia propuesta, todavía no consultada; contraste de urgencia/premios y verificación por canal oficial, P05. |
| F1 | https://consumer.ftc.gov/articles/how-recognize-and-avoid-phishing-scams | Referencia propuesta, todavía no consultada; verificar mensajes de premios y no compartir datos. |
| F2 | https://consumer.ftc.gov/identity-theft-and-online-security/online-privacy-and-security | Índice propuesto para localizar guía específica vigente sobre compartir información/audiencia y exposición, P04. No atribuir soporte a todo el índice sin seleccionar y leer el artículo. |
| F3 | https://consumer.ftc.gov/scams/imposter-scams | Índice propuesto para seleccionar guía vigente de suplantación/verificación de identidad y solicitudes de dinero, P06. Falta lectura y referencia específica. |
| R1 | https://www.rfc-editor.org/rfc/rfc2606.txt | GET intentado:403 por proxy. Verificar reserva `.example` para documentación, A2. |
| H1 | https://support.google.com/chrome/answer/95617?hl=es | Referencia histórica de A3; A3 fue retirada por el responsable el2026-11-05. |

Un HTTP403 no prueba que el documento no exista ni que su contenido respalde el
texto; solo acredita el acceso fallido. La petición inicial a un path NIST `.md`
dio404; se corrigió mediante descubrimiento del repositorio oficial y se leyó el
HTML real. No se atribuye revisión al path inexistente.

## Acción para cerrar el bloqueo (histórico)

La política activa permite gestores de paquetes/GitHub; estas fuentes web no están
habilitadas. Habilitar, en la configuración de red del entorno y conservando las
entradas existentes, `www.cisa.gov`, `consumer.ftc.gov`, `www.rfc-editor.org` y
`support.google.com`. No se modificó la política como parte de esta revisión del spec.
Tras aplicar el cambio: volver a consultar fuentes; registrar títulos/secciones,
URL final, fecha y soporte exacto por categoría; resolver cualquier discrepancia
con el responsable antes de cambiar texto aprobado. Se pueden usar fuentes primarias
alternativas verificables si cubren los mismos consejos, sin adjudicar consulta a
un documento inaccesible ni eludir la política mediante otro proxy.

El criterio CA-04.10 y la revisión editorial del plan quedaron pendientes hasta
completar ese trabajo; el cierre del contraste del2026-11-05 los resolvió. No se
hereda el aplazamiento de pruebas de F03.


## Nueva comprobación y borrador de red — 2026-11-05 (histórico)

> **Histórico:** este intento precede a la aplicación de la política. El cierre del
> contraste siguiente confirma que las consultas se completaron; esta sección no
> describe el estado vigente.

Se volvió a comprobar CISA, FTC, RFC Editor y soporte Chrome mediante HTTPS y el
proxy existente: los cuatro intentos fallaron en CONNECT (curl56, código HTTP de
destino000); una petición de cabeceras CISA confirmó403 del proxy. Esto no cambia
el estado de lectura de las fuentes ni acredita autorización hacia sus servidores.

El borrador de entorno se leyó y actualizó con éxito: se añadieron `www.cisa.gov`,
`consumer.ftc.gov`, `www.rfc-editor.org` y `support.google.com`, preservando
`storage.googleapis.com` y los presets existentes. El servicio confirmó guardado
con publicación requerida. No se ha aplicado a la instancia ni publicado por este
cambio; el estado activo sigue con la restricción anterior.

El usuario debe revisar y guardar los cambios de red en la configuración del
entorno y publicarlos. Tras aplicarlos se reintenta la revisión, sin volver a pedir
aprobación del plan técnico ya concedida y sin dar por hechos los accesos.


## Cierre del contraste externo — 2026-11-05

La nueva instancia aplica la política publicada. Las consultas siguientes fueron
GET HTTPS reales, siguiendo redirecciones, con TLS y proxy habilitados; se leyó
contenido del documento, no solo su HTTP200. No se cambiaron textos del usuario,
A1–A5 ni los wireframes. Los artículos son soporte educativo, no certificación.

| ID vigente | Documento consultado / sección | Alcance verificado |
| --- | --- | --- |
| N1 | NIST SP800-63B-4 Appendix A, Length/Complexity, repositorio oficial fijado arriba; releído | Longitud/frases, límites de composición y de contraseñas frente a phishing. P03/A1/A5. |
| F4 | [FTC: Protect Your Personal Information From Hackers and Scammers](https://consumer.ftc.gov/articles/protect-your-personal-information-hackers-and-scammers), Passwords y Protect Yourself from Attempts To Steal Your Information | Contraseñas largas, frases no predecibles, mezcla de caracteres como consejo y canales conocidos. No se traslada su longitud orientativa a una política universal ni se añade2FA a la función Tips. |
| G1 | [Google: Proteger mejor tu cuenta](https://support.google.com/accounts/answer/46526?hl=es), pasos3 y5 | Claves únicas reducen reutilización; suplantación mediante mensajes/sitios; no compartir claves/datos ni abrir enlaces sospechosos. P03/P05/P06. |
| F1 | [FTC: How To Recognize and Avoid Phishing Scams](https://consumer.ftc.gov/articles/how-recognize-avoid-phishing-scams), How To Recognize Phishing y What To Do if You Suspect a Phishing Attack | Señales de engaño y contacto por teléfono/sitio conocido, no por el enlace recibido. P05. URL original redirige a esta URL vigente. |
| F2a | [FTC: How Websites and Apps Collect and Use Your Information](https://consumer.ftc.gov/articles/how-websites-and-apps-collect-and-use-your-information), Adjust your privacy settings | Ajustes de privacidad y de cuentas sociales, control de ubicación/fotos/contactos y reducción de exposición. P04. Sustituye el índice F2 y la redirección del artículo antiguo. |
| F3a | [FTC: What To Know About Romance Scams](https://consumer.ftc.gov/articles/what-know-about-romance-scams), What Is a Romance Scam?, How to Avoid Losing Money y How to Report | Perfiles ficticios, fotos que pueden no corresponder, solicitudes de dinero, limitar interacción y denunciar a la plataforma. P06; la app no ejecuta denuncias ni búsquedas sobre personas. |
| R1 | [RFC2606](https://www.rfc-editor.org/rfc/rfc2606.txt), sección2 | `.example` reservado para documentación/ejemplos. A2; dirección solo texto. |
| H1 | [Chrome: Comprobar si la conexión de un sitio es segura](https://support.google.com/chrome/answer/95617?hl=es), Significado de cada símbolo de seguridad | Fuente consultada y conservada como historial; el texto A3 asociado fue retirado el2026-11-05. |
| R2 | [RFC8446](https://www.rfc-editor.org/rfc/rfc8446.txt), introducción | Fuente consultada y conservada como historial; el texto A3 asociado fue retirado el2026-11-05. |

### Límites del contraste y ejemplos ficticios

El texto de vacaciones es una ilustración editorial: decir públicamente que se
está ausente expone esa información. Publicar tras regresar es una precaución
propuesta por el responsable, no una afirmación estadística atribuida a FTC ni una
garantía de evitar daños. Dirección/teléfono/documentos se tratan como información
personal que conviene no exponer; no se afirma que esos datos por sí solos prueben
un ataque o que revisar la audiencia elimine el riesgo.

No se encontró respaldo para clasificar perfiles por número de publicaciones;
justamente A4 impide presentarlo como prueba de falsedad. El caso María López es
completamente sintético y no una evaluación de alguien identificable. Revisión de
actividad/fotos es orientación para verificar por otro medio, sin diagnóstico.
La contraseña expuesta es ilustrativa, no se recomienda reutilizarla y A1 evita
tratar composición como garantía de seguridad. No se añaden funciones externas
por aparecer recomendaciones o herramientas adicionales en las fuentes.

C1/C2 de CISA siguen sin lectura por respuesta403 y dejan de ser dependencias
obligatorias: N1/F4/G1/F1 cubren los mismos consejos. Los índices F2/F3 se sustituyen
por F2a/F3a. Se descartaron rutas FTC antiguas con404, sin atribuirles revisión.
Las fuentes alternativas estaban previstas por este registro; no es un cambio de
alcance, texto aprobado o proveedor del producto.

Resultado: soporte por las cuatro categorías, fechas/versión y límites registrados.
T001 queda completada. Esto no es aprobación de la entrega, prueba de interfaz,
validación con participantes ni publicación de contenido/reglas.
