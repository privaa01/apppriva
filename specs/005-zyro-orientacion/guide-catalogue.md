# Catálogo de guías propuesto — F05

**Versión propuesta**: `zyro-guides-es-CO-1.0.0`
**Estado**: vigente por aprobación del responsable; contraste independiente no ejecutado
**Responsable al aprobar**: equipo Priva
**Fecha de investigación**: 2026-11-05

## Catálogo estructurado aportado — 2026-11-05

El responsable aportó `guia_privacidad_instagram_facebook_google.pdf`, una guía
de cinco páginas actualizada el 5 de noviembre de 2026. El documento define
cuatro acciones para cada plataforma: Instagram, Facebook y Google. Sus doce
guías se transcribieron a
`firebase/functions/src/zyro/guides.v1.json` con revisión, estado, superficie,
pasos, consecuencias y referencia exacta de sección.

- SHA-256 del nuevo PDF aportado:
  `5b22afe240333f44de5535e9bf16a956ab4be50744f2c2c2da4bc603df230e4c`.

El catálogo conserva como `vigente` únicamente el contenido del documento. Los
nombres de menús pueden variar por versión, idioma, dispositivo o tipo de cuenta,
tal como advierte la propia fuente. Zyro debe reconocer esa incertidumbre y
remitir al centro de ayuda oficial cuando una opción no aparezca. Este catálogo
no incorpora credenciales, no ejecuta cambios y no habilita las antiguas acciones
candidatas de desactivación o eliminación descritas más abajo.

El documento fuente aportado tiene aprobación editorial explícita del usuario.
Los intentos de comprobación independiente del entorno se conservan como evidencia
histórica; la aprobación no acredita ejecución de rutas Android/web por Codex.

## Documento aportado y aprobación — 2026-11-05

El usuario responsable del proyecto aportó y aprobó expresamente la
[GUÍA PRÁCTICA DE SEGURIDAD Y PRIVACIDAD DIGITAL](../../docs/referencias/GUIA_PRACTICA_SEGURIDAD_PRIVACIDAD_DIGITAL.pdf)
con el mensaje: «es necesario vincular, ya te di los link en el pdf, yo apruebo el documento».
Se acepta el documento y sus enlaces como fuente editorial; no se solicita al
usuario volver a proporcionar enlaces ya incluidos.

- Fecha de comprobación declarada en el PDF: 5 de noviembre de 2026.
- Aprobador: usuario responsable del proyecto; no se infiere otra identidad.
- Secciones del alcance F05: 3.1 G/H (Gmail/Cuenta Google), 3.2 G
  (Facebook) y 3.3 F (Instagram), más recomendaciones previas de la sección 2.
- Enlaces aportados: `https://support.google.com/accounts/answer/32046`,
  `https://www.facebook.com/help/`, `https://www.facebook.com/settings`,
  `https://help.instagram.com/` y `https://accountscenter.instagram.com/`.
- Las demás plataformas y temas del PDF no amplían automáticamente F05.
- SHA-256 del PDF conservado: `9a24504bef7d0f5ca7917f5fbbd2ed699d0a9237ea01b5492de032bb6807499f`.

La fuente declara aplicación en Android y navegador web sin desglosar las rutas.
No identifica al ejecutor de las comprobaciones ni aporta evidencia de recorrido
con cuenta sintética. El responsable confirmó posteriormente que T001 y T002 estaban
finalizadas. Esa decisión cierra T001 y declara vigente el documento para F05 con
una limitación aceptada: Codex no ejecutó rutas Android/web ni comprobó los menús
contra cuentas sintéticas. Las URLs específicas del catálogo anterior se conservan
como referencias, no como enlaces extraídos del PDF.

## Intento de ejecución T001 — 2026-11-05

Tras la aprobación de tareas se intentaron de nuevo las cinco URLs con acceso de red
autorizado, TLS verificado, redirecciones y agente de navegador. El proxy del entorno
devolvió HTTP403 en todas. T001 permanece **pendiente**: no se inspeccionó contenido,
no se reprodujeron rutas y ninguna guía cambió a `vigente`.

## Reintento T001 en entorno nuevo — 2026-11-05

Responsable del intento: Codex. La política observada está `enforced` e incluye
`help.instagram.com`, `www.facebook.com` y `support.google.com`. Se consultaron
las cinco URLs anteriores con `curl --location --max-time 15`, TLS verificado y
proxy heredado. Todas terminaron con código curl **7**, HTTP **000**:
`Failed to connect to proxy port 8080: Could not connect to server`.
Este fallo ocurre antes de recibir una respuesta HTTP; no es el HTTP403 del
intento anterior. El estado del entorno informa `running/connected`, pero no hay
diagnósticos de red retenidos que expliquen la falta de conexión al proxy.

No se pudo leer contenido ni reproducir rutas Android/web con cuenta sintética.
Esta limitación permanece registrada aunque el responsable cerró T001 aceptando
el PDF como fuente vigente. Una revisión posterior podrá repetir el protocolo sin
reabrir silenciosamente la entrega.

## Instagram

**Acciones candidatas**: desactivar temporalmente; eliminar permanentemente.

**Ruta por contrastar**:

1. Abrir Centro de cuentas.
2. Entrar a Datos personales.
3. Abrir Propiedad y control de la cuenta.
4. Elegir Desactivación o eliminación.
5. Elegir cuenta y acción.
6. Revisar consecuencias, confirmar identidad y continuar.

Verificar ocultamiento/reactivación, cancelación, tiempos, copias y contenido de
terceros. Fuente: https://help.instagram.com/139886812848894

## Facebook

**Acciones candidatas**: desactivar; eliminar cuenta o perfil.

**Ruta por contrastar**:

1. Abrir Configuración y privacidad y luego Configuración.
2. Entrar al Centro de cuentas.
3. Abrir Datos personales.
4. Seleccionar Propiedad y control de la cuenta.
5. Abrir Desactivación o eliminación.
6. Elegir cuenta/perfil, acción y continuar.

Verificar reversibilidad, perfil, Messenger, páginas, mensajes, apps, compras,
cancelación y copias. Fuentes:

- https://www.facebook.com/help/224562897555674
- https://www.facebook.com/help/250563911970368

## Google

**Acciones candidatas**: eliminar Cuenta de Google; eliminar un servicio concreto.
No presentar «desactivar Cuenta de Google» sin fuente que use y defina esa acción.

**Eliminar cuenta — ruta por contrastar**:

1. Abrir Cuenta de Google.
2. Entrar a Datos y privacidad.
3. Abrir Más opciones.
4. Seleccionar Eliminar tu cuenta de Google.
5. Revisar datos/servicios, confirmar identidad y continuar.

**Eliminar servicio — ruta por contrastar**:

1. Abrir Datos y privacidad.
2. Buscar datos de aplicaciones y servicios.
3. Seleccionar Eliminar un servicio de Google.
4. Confirmar identidad y elegir servicio.

Verificar correo, archivos, calendario, fotos, compras, suscripciones, direcciones
alternativas y recuperación. Fuentes:

- https://support.google.com/accounts/answer/32046?hl=es
- https://support.google.com/accounts/answer/61177?hl=es

## Respuesta mientras no exista guía vigente

> No tengo una guía vigente y verificada para esa acción. No quiero darte una ruta
> que pueda estar desactualizada. Revisa la ayuda oficial desde la aplicación o el
> sitio que ya conoces de la plataforma.

## Protocolo de aprobación

1. Abrir cada URL oficial y registrar título/sección/fecha.
2. Reproducir con cuenta sintética sin confirmar eliminación.
3. Separar Android, web y Centro de cuentas; no mezclar rutas.
4. Aprobar pasos, consecuencias y requisitos exactos sin datos personales.
5. Versionar y revisar en cada entrega o cambio documental.
6. Marcar `vigente`, `vencida` o `retirada`; solo `vigente` se sirve.
