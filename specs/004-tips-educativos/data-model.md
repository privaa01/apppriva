# F04 — Modelo de contenido y estado

**Estado:** diseño incluido en el plan aprobado el2026-11-05; sin implementación
ni documentos alojados creados. Fuentes editoriales pendientes.

## Categoría cerrada

| ID Firestore | Ruta | Título del catálogo | Detalle |
| --- | --- | --- | --- |
| passwords | /tips/passwords | Contraseñas seguras | P03 |
| sharing | /tips/sharing | Cuida lo que subes | P04 |
| links | /tips/links | Enlaces sospechosos | P05 |
| profiles | /tips/profiles | Perfiles falsos | P06 |

No aceptar IDs o rutas de un documento como autorización: el mapa se define en
cliente y reglas. `/tips` representa el catálogo; siempre cuatro entradas ordenadas.

## Documento `/educational_tips/{id}`

| Campo | Tipo / validación |
| --- | --- |
| schemaVersion | Entero1; cualquier otro valor, unavailable. |
| contentVersion | String `tips-1.0.0`, revisión editorial soportada. |
| categoryId | String igual al ID del documento y del mapa cerrado. |
| status | Literal `approved`; borradores no se publican en esta colección. |
| catalogTitle | String del mapa anterior, no intercambiable con título de detalle. |
| description | Descripción literal aprobada, usada también como resumen del catálogo. |
| title | Título principal aprobado de cada detalle. |
| panelTitle | Pregunta aprobada que encabeza recomendaciones. |
| recommendations | Lista de exactamente3 strings no vacíos y ordenados. |
| example | Objeto según variantes de abajo; solo contenido ficticio aprobado. |
| explanation | String literal para «Ver ejemplo», incluye A1 en passwords. |
| advice | Consejo literal aprobado; A5 aplicado en passwords. |
| clarification | String: A3 en links, A4 en profiles; vacío en las otras dos categorías. |
| editorialReview | Objeto con version1.0.0, approvedOn2026-11-04 y sourceIds de fuentes verificadas. No contiene identidad del revisor ni datos de lectores. |

Validación estricta: no campos extra, tipos incorrectos, texto vacío obligatorio,
IDs desconocidos, contenido superior a32KiB UTF-8 por documento ni versiones mixtas.
Comprobar igualdad editorial del payload publicado con el artefacto aprobado en
validación de publicación y regresión; no permitir que la consola añada campos de
cuenta o contenido sin revisión. Una actualización editorial exige nueva versión,
revisión de fuentes y pruebas antes de distribuirla.

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

Las etiquetas nuevas breves («Ejemplo ficticio», «Publicación ficticia», «Mensaje
ficticio», «Perfil ficticio») se proponen con este diseño como identificación de
los ejemplos; no agregan consejos ni datos recolectados.

## Estado de pantalla — solo memoria

`TipsState`: destino cerrado, fase, generación, contenido válido opcional,
`exampleExpanded` y `passwordVisible` (solo P03). No UID, correo, historial,
respuestas, score ni argumentos serializados para restaurar una visita.

| Evento | Transición |
| --- | --- |
| Entrar/cargar | loading, contenido anterior eliminado, nueva generación. |
| Respuesta completa válida actual | ready; ejemplo colapsado y clave oculta inicialmente. |
| Fallo proveedor/red o timeout15s actual | error; aviso simple y Reintentar/Volver. |
| Documento ausente/incompleto/versión no soportada o permission-denied | unavailable; no sustitución de categoría ni diagnóstico de causa por suposición. |
| Reintentar | loading del mismo destino, nueva generación, sin duplicar operación. |
| Ver ejemplo en ready | exampleExpanded=true; nueva pulsación no duplica ni colapsa. |
| Mostrar/Ocultar clave | Alterna passwordVisible; no cambia la explicación. |
| PageRoute cubre pantalla (didPushNext)/dispose | Invalida generación y elimina referencias de pantalla. |
| Regreso a pantalla retenida (didPopNext) | Nueva carga del mismo destino; explicación colapsada y clave oculta. |
| Respuesta antigua o pantalla desmontada | Se ignora; no actualiza otra vista. |

Sin persistencia de las visitas ni restauración de explicaciones. El contenido
público servido permanece en Firestore hasta que el responsable publique una
revisión o lo retire; no incluye datos de participantes ni lectores. Documentos
inexistentes o no aprobados no se presentan como contenido final.

## Flujo de datos

```text
Ruta cerrada → repositorio → Firestore get servidor → validación → estado en memoria → UI
Responsable autorizado → payload editorial revisado → publicación de4 documentos
```

El cliente no escribe. La autenticación existente puede viajar con el SDK si la
persona tiene sesión, pero no determina el contenido. No hay llamada a IA,
analítica nueva, historial de lecturas ni datos del cuestionario.
