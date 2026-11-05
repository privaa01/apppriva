# F04 — Contratos de contenido, acceso e interfaz

**Estado:** propuestos para aprobar con el plan. No son endpoints desplegados.

## C-TIPS-01 — Repositorio de lectura

Operaciones conceptuales: cargar catálogo y cargar detalle por ID cerrado.
Devuelven contenido validado o error tipado recuperable/indisponibilidad, sin
exponer snapshots/errores del proveedor a la UI. Implementación producción:
Firestore `get` de servidor, sin cache persistente ni fallback; dobles de prueba
inyectados por constructor, sin endpoints ni flags de test en producto.

Catálogo:4 get conocidos en paralelo, validación conjunta y orden fijo. Detalle:
1 get, sin consulta de colección. Timeout15s del grupo/detalle. Respuesta parcial,
versión mixta o documento ausente no equivalen a catálogo válido. Esquema en
[data-model.md](../data-model.md), texto en [contenido-editorial.md](../contenido-editorial.md).

## C-TIPS-02 — Reglas y separación de cuenta

Propuesta para `/educational_tips/{id}`:

- get permitido sin autenticación solo para passwords/sharing/links/profiles;
  si existe recurso, debe estar approved y con esquema/versión soportados.
- get de ID conocido inexistente devuelve ausencia autorizada, no una denegación
  engañosa; cliente lo convierte en unavailable. No divulgar IDs arbitrarios.
- list y create/update/delete siempre denegados a clientes, incluso autenticados.
- accesos a perfiles/evidencias siguen sus condiciones actuales; demo_contact y
  privacy_suppressions se conservan. Denegación por defecto restante intacta.
- publicación por responsable autorizado fuera de la app, tras pruebas y comparación
  de payload; no incluir una ruta de escritura administrativa en Flutter.

Pruebas obligatorias: visitante y sesión válida leen4 documentos aprobados;
ID desconocido/draft/versión no soportada no se lee; colección no enumerable;
cliente no puede escribir ni con su propia sesión; ausencia conocida recuperable;
regresión completa de reglas de cuenta y demo. Tests siembran documentos con
`withSecurityRulesDisabled` solo en emulador sintético, nunca para habilitar producción.

## C-TIPS-03 — Carga, recuperación y mensajes

- loading: «Cargando consejos…», anunciado; acciones de reintento repetidas no lanzan
  operaciones superpuestas.
- error: «No pudimos cargar los consejos. Inténtalo de nuevo.» + «Reintentar».
- unavailable: «Este contenido no está disponible en este momento.» + «Reintentar»
  y retorno permitido. No afirmar que todo documento ausente se recuperará sin publicar.
- `permission-denied` en la lectura de un ID Tips conocido se transforma en unavailable
  sin atribuir una causa concreta: puede deberse a reglas/versionado/despliegue.
  Otros fallos de transporte o timeout se transforman en error.
- conservar destino durante reintento. Volver siempre disponible en detalle, incluso
  durante loading/error. No registrar path recibido, email, token ni excepción bruta.
- datos tardíos de otra generación/pantalla se descartan; excepción no queda sin manejar.

Estos mensajes de estado completan los estados del spec no dibujados en el PDF;
se proponen con el plan, no sustituyen los textos educativos aprobados.

## C-TIPS-04 — Navegación

Cinco rutas existentes públicas y sección Tips seleccionada. Navegar solo mediante
coordinador F03; preservar acceso desconocido y guardas privadas. Detalle directo
crea/reutiliza padre Tips; volver no lleva a un detalle ajeno ni duplica catálogo.
Activar20 veces destino actual no apila pantallas. Cambiar UID/cerrar sesión no
vuelve privadas las rutas públicas; guardado Perfil y descarte temporal se preservan.
Cuando una PageRoute cubre Tips, RouteAware.didPushNext invalida carga y borra
contenido/explicación; didPopNext recarga el mismo destino. Suscribir/desuscribir
un observer sin sustituir el de Perfil ni duplicar callbacks. No aplicar esta
limpieza por diálogos que no sean PageRoute. Así popUntil no reutiliza estado vacío
sin recargar. El catálogo padre puede terminar de cargar de nuevo al regresar.
Builder inyectado no elude catálogo/guardas; su precedencia se mantiene para pruebas.

## C-TIPS-05 — Wireframes e interacción

| Pantalla | Referencia | Contrato visual |
| --- | --- | --- |
| P02 | PDF4 | Cabecera, título/introducción y Zyro, panel blanco con4 categorías y Ver más, menú inferior. |
| P03 | PDF6 | Título/descripción, recomendaciones, ejemplo con máscara, consejo; explicación inline añadida por solicitud. |
| P04 | PDF8 | Mismos bloques; publicación ficticia aportada sustituye foto del mockup. |
| P05 | PDF9 | Mismos bloques; mensaje de premio y dirección inerte, aclaración HTTPS. |
| P06 | PDF10 | Mismos bloques; perfil ficticio aportado sustituye gráfico genérico anterior, aclaración publicaciones. |

Texto del usuario+A1–A5 prevalece. Ver ejemplo no abre otra ruta ni enlace; muestra
su explicación una vez y mantiene consejo visible mediante scroll. P03 control
Mostrar/Ocultar ejemplo de contraseña independiente de explicación, con etiqueta y
estado semánticos. No campos editables, portapapeles, navegador externo, subida de
archivos, permisos nuevos ni evaluación de datos reales.

## C-TIPS-06 — Accesibilidad y validación humana

Semántica de encabezados, controles con categoría, orden lógico y estado expandido;
iconos/Zyro decorativos excluidos de lectura duplicada. Selección Tips perceptible
sin depender solo del color. Texto100%/200% sin clipping; acciones≥48dp. Contraste
normal4.5:1, grande3:1 y controles3:1 medidos sobre colores renderizados.

Pruebas semánticas automáticas no equivalen a TalkBack físico. Capturas sintéticas
por geometría/texto para comparar composición, sin cuentas ni datos personales.
Protocolo y umbrales en [quickstart](../quickstart.md). No guardar visitas de usuarios
ni respuestas individuales de participantes para acreditar comprensión.
