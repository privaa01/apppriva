# F04 — Registro de fuentes editoriales

**Fecha de revisión:** 2026-11-04, zona del usuario. **Versión editorial:**1.0.0.
**Estado:** parcial; fuentes bloqueadas no se declaran consultadas.
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

## Fuentes por verificar antes de cerrar revisión editorial

| ID | Fuente primaria / propósito | Estado y alcance pendiente |
| --- | --- | --- |
| C1 | https://www.cisa.gov/secure-our-world/use-strong-passwords | GET intentado:403 por proxy. Verificar unicidad y frases de contraseña, P03. No se declara leída. |
| C2 | https://www.cisa.gov/secure-our-world/recognize-and-report-phishing | Referencia propuesta, todavía no consultada; contraste de urgencia/premios y verificación por canal oficial, P05. |
| F1 | https://consumer.ftc.gov/articles/how-recognize-and-avoid-phishing-scams | Referencia propuesta, todavía no consultada; verificar mensajes de premios y no compartir datos. |
| F2 | https://consumer.ftc.gov/identity-theft-and-online-security/online-privacy-and-security | Índice propuesto para localizar guía específica vigente sobre compartir información/audiencia y exposición, P04. No atribuir soporte a todo el índice sin seleccionar y leer el artículo. |
| F3 | https://consumer.ftc.gov/scams/imposter-scams | Índice propuesto para seleccionar guía vigente de suplantación/verificación de identidad y solicitudes de dinero, P06. Falta lectura y referencia específica. |
| R1 | https://www.rfc-editor.org/rfc/rfc2606.txt | GET intentado:403 por proxy. Verificar reserva `.example` para documentación, A2. |
| H1 | https://support.google.com/chrome/answer/95617?hl=es | Referencia propuesta, todavía no consultada; comprobar alcance de conexión cifrada y límites sobre legitimidad, A3. |

Un HTTP403 no prueba que el documento no exista ni que su contenido respalde el
texto; solo acredita el acceso fallido. La petición inicial a un path NIST `.md`
dio404; se corrigió mediante descubrimiento del repositorio oficial y se leyó el
HTML real. No se atribuye revisión al path inexistente.

## Acción para cerrar el bloqueo

La política activa permite gestores de paquetes/GitHub; estas fuentes web no están
habilitadas. Habilitar, en la configuración de red del entorno y conservando las
entradas existentes, `www.cisa.gov`, `consumer.ftc.gov`, `www.rfc-editor.org` y
`support.google.com`. No se modificó la política como parte de esta revisión del spec.
Tras aplicar el cambio: volver a consultar fuentes; registrar títulos/secciones,
URL final, fecha y soporte exacto por categoría; resolver cualquier discrepancia
con el responsable antes de cambiar texto aprobado. Se pueden usar fuentes primarias
alternativas verificables si cubren los mismos consejos, sin adjudicar consulta a
un documento inaccesible ni eludir la política mediante otro proxy.

El criterio CA-04.10 y la revisión editorial del plan permanecen pendientes hasta
completar ese trabajo. No se hereda el aplazamiento de pruebas de F03.


## Nueva comprobación y borrador de red — 2026-11-05

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
