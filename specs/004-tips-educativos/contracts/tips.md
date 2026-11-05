# F04 — Contratos de contenido, acceso e interfaz

> **Contrato vigente desde 2026-11-05:** `BundledTipsRepository` lee el asset
> inmutable `assets/content/tips-1.0.0.json`. No usa red, sesión, Firestore, listas,
> listeners ni escrituras. Un asset ausente o inválido produce `unavailable`; una
> ruta desconocida se rechaza. El contrato de UI y navegación no cambia.

**Estado:** contrato implementado localmente el2026-11-05 sobre el asset aprobado,
pendiente de revalidación tras la migración. No son endpoints desplegados y no
existe publicación de Tips; las validaciones nativas/humanas siguen pendientes.

## C-TIPS-01 — Repositorio de lectura

Operaciones conceptuales: cargar catálogo y cargar detalle por ID cerrado.
Devuelven contenido validado o error tipado recuperable/indisponibilidad, sin
exponer rutas ni excepciones a la UI. Implementación vigente:
`BundledTipsRepository(rootBundle)` lee `assets/content/tips-1.0.0.json`, valida el
mapa completo y cachea solo en memoria; dobles de prueba inyectados por constructor,
sin endpoints ni flags de test en producto.

Catálogo: mapa cerrado de cuatro IDs en orden fijo, validado antes de responder.
Detalle: una entrada de ese mismo mapa. Timeout15s. Asset ausente/incompleto,
versión mixta o ID desconocido producen `unavailable`; no equivalen a catálogo
válido. Esquema en [data-model.md](../data-model.md), texto en
[contenido-editorial.md](../contenido-editorial.md).

## C-TIPS-02 — Separación de cuenta y contenido

No existen reglas ni colección Firestore para Tips. El asset local es de solo
lectura y se valida completo antes de mostrar contenido; no hay `list`, `get`,
escrituras ni permisos nuevos.

- El contenido no depende de autenticación, UID, correo, perfil ni autorización.
- Un fallo de cuenta o de Firebase no bloquea Tips ni lo convierte en privado.
- Las reglas de cuenta/perfil/demo y `privacy_suppressions` permanecen intactas.
- No se incluye ruta de escritura administrativa ni publicación de Tips en Flutter.

Pruebas obligatorias: visitante y sesión válida leen las cuatro categorías; asset
ausente/incompleto/inválido e ID desconocido producen `unavailable`; no hay
escrituras ni historial; regresión completa de cuenta/perfil/demo. Cualquier
prueba con emulador se limita a esas funciones ajenas a Tips.

## C-TIPS-03 — Carga, recuperación y mensajes

- loading: «Cargando consejos…», anunciado; acciones de reintento repetidas no lanzan
  operaciones superpuestas.
- error: «No pudimos cargar los consejos. Inténtalo de nuevo.» + «Reintentar».
- unavailable: «Este contenido no está disponible en este momento.» + «Reintentar»
  y retorno permitido. No afirmar que todo asset ausente se recuperará sin una
  nueva APK.
- Un asset ilegible, incompleto o con versión no soportada se transforma en
  unavailable sin atribuir una causa concreta. Un timeout de carga se transforma
  en error. No se exponen rutas ni excepciones internas.
- conservar destino durante reintento. Volver siempre disponible en detalle, incluso
  durante loading/error. No registrar path recibido, email, token ni excepción bruta.
- datos tardíos de otra generación/pantalla se descartan; excepción no queda sin manejar.

Estos mensajes de estado completan los estados del spec no dibujados en el PDF;
se mantienen con el contrato aprobado, no sustituyen los textos educativos aprobados.

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
