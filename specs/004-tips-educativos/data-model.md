# F04 — Modelo de contenido y estado

> **Fuente vigente (cambio aprobado 2026-11-05):** cada ID identifica una entrada
> del mapa cerrado en `mobile/assets/content/tips-1.0.0.json`, no un documento
> Firestore. El esquema y la validación permanecen iguales. El asset se valida
> completo antes de mostrar catálogo o detalle y solo cambia con otra APK.

**Estado:** diseño implementado el2026-11-05 sobre el asset local; el esquema se
valida al cargar la APK. Fuentes editoriales verificadas; no hay documentos
alojados ni reglas de Tips.

## Categoría cerrada

| ID de categoría | Ruta | Título del catálogo | Detalle |
| --- | --- | --- | --- |
| passwords | /tips/passwords | Contraseñas seguras | P03 |
| sharing | /tips/sharing | Cuida lo que subes | P04 |
| links | /tips/links | Enlaces sospechosos | P05 |
| profiles | /tips/profiles | Perfiles falsos | P06 |

No aceptar IDs o rutas desconocidas: el mapa cerrado se define en el asset y en el
modelo. `/tips` representa el catálogo; siempre cuatro entradas ordenadas.

## Entrada del asset `tips-1.0.0.json`

| Campo | Tipo / validación |
| --- | --- |
| schemaVersion | Entero1; cualquier otro valor, unavailable. |
| contentVersion | String `tips-1.0.0`, revisión editorial soportada. |
| categoryId | String igual al ID de la entrada y del mapa cerrado. |
| status | Literal `approved`; borradores no se incluyen en el asset. |
| catalogTitle | String del mapa anterior, no intercambiable con título de detalle. |
| description | Descripción literal aprobada, usada también como resumen del catálogo. |
| title | Título principal aprobado de cada detalle. |
| panelTitle | Pregunta aprobada que encabeza recomendaciones. |
| recommendations | Lista de exactamente3 strings no vacíos y ordenados. |
| example | Objeto según variantes de abajo; solo contenido ficticio aprobado. |
| explanation | String literal para «Ver ejemplo», incluye A1 en passwords. |
| advice | Consejo literal aprobado; A5 aplicado en passwords. |
| clarification | String: A4 en profiles; vacío en passwords, sharing y links. A3 fue retirada por el responsable el2026-11-05. |
| editorialReview | Objeto con version1.0.0, approvedOn2026-11-04 y sourceIds de fuentes verificadas. No contiene identidad del revisor ni datos de lectores. |

Validación estricta: no campos extra, tipos incorrectos, texto vacío obligatorio,
IDs desconocidos, contenido superior a32KiB UTF-8 por entrada ni versiones mixtas.
Comprobar igualdad literal del asset empaquetado con `contenido-editorial.md` en
pruebas y regresión. Una actualización editorial exige nueva versión, revisión de
fuentes, pruebas y una nueva APK antes de distribuirla.

### Variantes de `example`

Todas tienen `kind`, `label` literal «Ejemplo» y `fictionalLabel` de contenido
ficticio. Las claves permitidas se definen según la categoría; sin URLs accionables.

- passwords: kind=password; value=`Sol!Camina27_Luna`; caption aprobado.
- sharing: kind=post; body=publicación de vacaciones aportada; caption que indica
  situación ficticia que puede revelar ausencia del hogar.
- links: kind=message; body=mensaje de premio aportado; address=`www.premio-regalo.example`;
  caption=«Posible intento de engaño». No se parsea como Uri para abrirla.
- profiles: kind=profile; name=`María López`; handle=`@maria.lopez_oficial`;
  signals=las3 señales del caso; avatar=icono genérico de app, no URL remota.

Las etiquetas breves («Ejemplo ficticio», «Publicación ficticia», «Mensaje
ficticio», «Perfil ficticio») identifican los ejemplos implementados; no agregan
consejos ni datos recolectados.

## Estado de pantalla — solo memoria

`TipsState`: destino cerrado, fase, generación, contenido válido opcional,
`exampleExpanded` y `passwordVisible` (solo P03). No UID, correo, historial,
respuestas, score ni argumentos serializados para restaurar una visita.

| Evento | Transición |
| --- | --- |
| Entrar/cargar | loading, contenido anterior eliminado, nueva generación. |
| Respuesta completa válida actual | ready; ejemplo colapsado y clave oculta inicialmente. |
| Fallo de lectura del asset o timeout15s actual | error; aviso simple y Reintentar/Volver. |
| Asset ausente/incompleto/inválido, ID desconocido o versión no soportada | unavailable; no sustitución de categoría ni diagnóstico de causa por suposición. |
| Reintentar | loading del mismo destino, nueva generación, sin duplicar operación. |
| Ver ejemplo en ready | exampleExpanded=true; nueva pulsación no duplica ni colapsa. |
| Mostrar/Ocultar clave | Alterna passwordVisible; no cambia la explicación. |
| PageRoute cubre pantalla (didPushNext)/dispose | Invalida generación y elimina referencias de pantalla. |
| Regreso a pantalla retenida (didPopNext) | Nueva carga del mismo destino; explicación colapsada y clave oculta. |
| Respuesta antigua o pantalla desmontada | Se ignora; no actualiza otra vista. |

Sin persistencia de las visitas ni restauración de explicaciones. El contenido
público vive en el asset inmutable de la APK hasta que el responsable apruebe una
nueva revisión y se distribuya otra APK; no incluye datos de participantes ni
lectores. Un asset inválido o una categoría inexistente no se presenta como
contenido final.

## Flujo de datos

```text
Ruta cerrada → BundledTipsRepository → asset de la APK → validación → estado en memoria → UI
Responsable → texto editorial revisado → nueva versión → nueva APK
```

El cliente no escribe ni abre conexiones para Tips. La autenticación existente
puede seguir usándose en cuenta/perfil, pero no determina el contenido. No hay
llamada a IA, analítica nueva, historial de lecturas ni datos del cuestionario.
