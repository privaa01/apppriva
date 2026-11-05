# Implementation Plan: F04 — Tips educativos

## Enmienda aprobada — contenido incluido en la APK (2026-11-05)

El responsable confirmó que los textos son fijos y no necesita actualización
remota. La decisión anterior de distribuir cuatro documentos por Firestore queda
sustituida para F04 por `mobile/assets/content/tips-1.0.0.json`, leído mediante
`BundledTipsRepository`. Cuenta, registro y perfil conservan Firebase sin cambios.

- Las mismas cinco rutas y pantallas consumen el mismo contrato `TipsRepository`.
- No hay lectura, escritura, caché ni reglas Firestore para Tips en ejecución.
- Catálogo y detalles funcionan sin red y sin sesión.
- Cambiar el contenido exige una nueva APK y versión editorial.
- Los artefactos Firebase de Tips se conservan solo como evidencia histórica no
  desplegada y no forman parte de la entrega vigente.
- Las pruebas remotas se sustituyen por igualdad del asset, arranque sin Firebase
  y ejecución Android offline.

Esta enmienda prevalece sobre las secciones posteriores que describen distribución
remota, conservadas como registro del diseño inicialmente aprobado.

**Branch:** `work` | **Date:** 2026-11-04 | **Spec:** [spec.md](spec.md).
**Selección:** `SPECIFY_FEATURE_DIRECTORY=specs/004-tips-educativos`; el script
reporta el identificador lógico004-tips-educativos, no crea ni cambia la rama real.
**Estado:** plan técnico aprobado explícitamente por el responsable el2026-11-05;
contraste editorial completado en esa fecha. Implementación migrada al contenido
fijo y entrega aceptada el2026-11-05 con las limitaciones APK/API documentadas; sin
publicación Firebase.
**Entrada:** categorías, textos y wireframes confirmados; A1–A5 aprobados por
«si los apruebo». [Contenido final](contenido-editorial.md), versión1.0.0.

## Summary

Entregar P02 y los cuatro detalles P03–P06, públicos, siguiendo los wireframes,
con explicaciones internas «Ver ejemplo» y textos aprobados. Reutilizar Flutter,
Navigator, AccountScaffold, tema, Firebase y la imagen existente de Zyro.

La versión vigente distribuye los cuatro Tips como un asset JSON inmutable dentro
de la APK (`assets/content/tips-1.0.0.json`), leído por `BundledTipsRepository`.
Catálogo y detalles funcionan sin red y sin sesión; no hay colección, reglas ni
publicación Firebase para Tips. Actualizar el contenido exige una nueva versión
editorial y una nueva APK. La distribución remota descrita más abajo se conserva
solo como registro histórico del diseño inicialmente aprobado.

## Technical Context

| Campo | Diseño vigente |
| --- | --- |
| Language/Version | Baseline del proyecto Flutter3.47.8 / Dart3.13.7; verificar instalación antes de ejecutar. No actualizar pins/lockfile por conveniencia. |
| Primary Dependencies | Flutter Material, Navigator y ChangeNotifier; `cloud_firestore`/`firebase_core` siguen disponibles para cuenta y perfil, pero Tips no los usa. Ninguna dependencia nueva. |
| Storage | Asset inmutable `assets/content/tips-1.0.0.json` incluido en la APK; estado de consulta y explicación solo en memoria. Sin Firestore, visitas, favoritos, respuestas ni datos de cuenta en contenido. |
| Testing | Unit/widget, repositorio con dobles deterministas, validación del asset, regresión F01–F03, Android nativo offline y evaluación humana. |
| Target Platform | Android API24 y API36;320×720 y412×915dp; texto100%/200%; al menos un Android físico con TalkBack. Web añadido al repo no amplía el alcance aprobado. |
| Project Type | Módulo `features/tips` en app existente; sin cambios de reglas Firestore para Tips. |
| Performance Goals | Primer feedback≤1s; contenido o aviso recuperable≤15s.20 repeticiones por operación/configuración, sin incluir espera humana. Timeout explícito y descarte de respuesta tardía. |
| Constraints | Lectura pública independiente de autorización de cuenta y de conectividad; el asset local es la única fuente de contenido. Catálogo cerrado; ejemplos inertes. |
| Scale/Scope | Cinco pantallas, cuatro categorías, tres recomendaciones por detalle, versión editorial tips-1.0.0. Sin chat, cuestionario, CMS ni generador/analizador de claves o URLs. |

El entorno de esta revisión no tiene Flutter/Dart en PATH ni `/workspace/.tools`.
No se han ejecutado pruebas Flutter ni Android de F04. Los fallos de descarga
históricos son prerrequisitos de ejecución, no defectos confirmados del módulo.

## Constitution Check

**Revisión previa y posterior:** alcance, A1–A5 y plan aprobados; contraste editorial
cerrado2026-11-05 y ejecución local autorizada por «listo sigamos». No se propone
violación constitucional. Las182 pruebas Flutter, las24 de reglas/preflight y el
APK compilado son baseline previo a la migración al asset; no acreditan el cambio
vigente ni cierran la puerta de entrega. Quedan controles nativos/humanos, la
revalidación local y el smoke offline pendientes. La publicación Firebase ya no
forma parte de F04.

| Principio | Diseño y evidencia exigida |
| --- | --- |
| I — fuente de verdad | Contenido1.0.0, IDs preservados, comparación de P02/P03–P06 y registro A1–A5. |
| II — privacidad | Solo contenido público; sin UID en rutas/documentos ni registro de lectura. Tips no usa red, Firestore ni sesión, y no genera tráfico ni metadatos propios. Firebase de cuenta/perfil conserva su revisión y finalidades ya aprobadas; no se amplían por F04. |
| III — temporalidad | Tips no recibe respuestas/resultados. Regresión de salida, cambio UID y descarte del puerto F03; no persistencia ni restauración añadida. |
| IV — Zyro | Imagen decorativa en P02, sin servicio de IA, conversación ni promesas nuevas. |
| V — accesibilidad | Texto200%,48dp, contraste4.5:1 texto normal y3:1 texto grande/controles; TalkBack y protocolo SC-04.5 definidos abajo. |
| VI — calidad | Sin reglas ni colección Tips: asset validado completo, cuatro IDs, sin escrituras ni permisos nuevos. Manejo de errores/timeout, rutas y pruebas sintéticas. |
| VII — trazabilidad | Matriz RF/CA→contratos→validaciones; tareas detalladas en `tasks.md` y resultados en `validation/`. |
| VIII — simplicidad | Un router; un repositorio de lectura; sin listeners permanentes, índices, CMS, analítica, conectividad artificial ni dependencias nuevas. |
| IX — etapas | Aprobación técnica y fuentes registradas; ejecución local autorizada. Tareas/resultados distinguen pruebas locales, nativas, humanas y smoke offline. Commit no equivale a entrega aceptada. |

La consulta de NIST fue satisfactoria desde su repositorio oficial y el contraste
editorial se completó el2026-11-05 con FTC, RFC Editor y soporte de Google; ver
[registro](fuentes-editoriales.md). Las incidencias de red y los pendientes
anteriores se conservan allí como historial. CA-04.10 queda cubierto por ese
contraste, que no sustituye las validaciones nativas/humanas ni la aceptación.

## Project Structure

### Documentation

```text
specs/004-tips-educativos/
├── spec.md
├── contenido-editorial.md
├── fuentes-editoriales.md
├── plan.md
├── research.md
├── data-model.md
├── contracts/tips.md
├── quickstart.md
└── checklists/requirements.md
```

`tasks.md` y los resultados en `validation/` reflejan el estado real: implementación
local migrada, baseline previo y validaciones pendientes; no se presentan pruebas
ficticias como ejecutadas.

### Source Code — implementación vigente

```text
mobile/lib/features/tips/
├── data/tip_content.dart
├── data/tips_repository.dart
├── data/bundled_tips_repository.dart
├── application/tips_controller.dart
├── presentation/tips_catalog_screen.dart
├── presentation/tip_detail_screen.dart
└── presentation/tips_page.dart
mobile/assets/content/tips-1.0.0.json
mobile/test/features/tips/
mobile/integration_test/tips_test.dart
mobile/integration_test/tips_performance_test.dart
```

Integraciones mínimas: `main.dart`, `app/priva_app.dart`, `app/account_router.dart`,
`features/navigation/data/destination_catalog.dart` y extensión compatible del
`AccountScaffold` si necesita encabezado propio. `firebase/firestore.rules` conserva
únicamente las reglas de cuenta/perfil/demo; no contiene reglas de Tips. El asset
editorial es contenido público revisable, nunca credenciales. No se crea nueva
infraestructura ni se cambian proyectos Firebase.

## Diseño e integración

### Distribución y acceso — C-TIPS-01/02

Catálogo de IDs/rutas cerrado. `BundledTipsRepository` lee el asset
`assets/content/tips-1.0.0.json` con `rootBundle` y valida las cuatro entradas antes
de mostrar catálogo o detalle. Una sola decodificación en memoria; no hay red,
`GetOptions`, Firestore, listeners ni escrituras. Cualquier asset ausente, incompleto,
inválido o ID desconocido produce `unavailable`; no se sustituye por otra categoría.

El repositorio se compone en `main.dart` con `rootBundle`, antes e independientemente
de Firebase/Auth, de modo que un fallo de cuenta o de conexión no convierta Tips en
privado ni bloquee su lectura. El resultado no depende de UID, correo, perfil,
autorización, cuestionario o conversaciones, y no se registra historial de visitas.
Actualizar el contenido exige una nueva versión editorial y una nueva APK.

### Estado y concurrencia — C-TIPS-03

Un controlador por pantalla mantiene destino, generación, fase y contenido público.
Cada carga incrementa generación; solo la respuesta de la solicitud vigente, con
pantalla viva, puede publicarse. Timeout a15s; no cancelar por suposición el Future
de lectura del asset: invalidar su efecto. Reintentos concurrentes se agrupan, y
volver/cambiar categoría/dispose invalida la operación. No dejar el texto de la
categoría anterior como sustituto mientras carga otra. Las excepciones de lectura
no se imprimen ni muestran. Un asset ausente/inválido se presenta como unavailable
sin inventar el motivo; los fallos transitorios/timeout como error.

### Rutas — C-TIPS-04

Conectar pantallas después de las guardas existentes; preservar `destinationBuilder`
inyectado por las pruebas. Marcar como disponibles únicamente las cinco rutas Tips
al integrar la funcionalidad; no modificar disponibilidad F05–F07. Reutilizar padre
lógico `/tips`, selección de sección y deduplicación de F03. Retorno directo y Android
back deben dar catálogo; reseleccionar Tips vuelve a catálogo sin duplicarlo.
Perfil sigue bloqueando salida voluntaria mientras guarda. Cambio/cierre de sesión
conserva acceso público, aunque F03 limpie la pila privada; volver a abrir Tips no
requiere acceso. No forzar que cierre de sesión conserve la misma pantalla.

Las rutas cubiertas permanecen montadas: usar RouteAware con observer de PageRoute
compatible con el existente, didPushNext para invalidar carga y limpiar contenido,
y didPopNext para recargar el destino retenido. Desuscribir al desmontar; diálogos
no PageRoute no limpian Tips. Esto evita que el popUntil de F03 muestre una pantalla
vacía sin recarga. No reemplazar el observer de Perfil.

### Presentación — C-TIPS-05/06

P02: cabecera existente, título «¡Tengo estos tips para ti!», introducción corregida
«Aquí tienes unos consejos prácticos para cuidar tu privacidad digital todos los días.»,
Zyro a la derecha si el ancho permite, y un panel blanco redondeado con las cuatro
entradas en el orden aprobado. Resúmenes: reutilizar las descripciones del contenido
aprobado, sin inventar afirmaciones nuevas. «Ver más» asociado a cada categoría.

Detalles: cabecera y menú existentes, título alineado según PDF, descripción,
recomendaciones, panel Ejemplo y panel Consejo. Texto aprobado prevalece sobre las
frases anteriores del PDF. «Ver ejemplo» revela explicación dentro del panel;
no abre un diálogo, otra ruta ni una app externa. P03 conserva máscara y control
independiente para revelar/ocultar la contraseña ilustrativa. P04 representa la
publicación ficticia aportada; P05 mensaje y dominio `.example` inerte; P06 perfil
sintético con avatar genérico y sus señales, sin fotos/personas reales.

Usar `assets/images/zyro/zyro.png`, imagen existente inspeccionada: corresponde al
personaje y pose, pero tiene fondo blanco/gris. Su integración debe revisarse
visualmente; no se declara una reproducción exacta ni se genera una variante nueva
por inferencia. Sin Zyro en detalles, donde no aparece. Iconos Material decorativos.

Conservar verde y fondo del tema; paneles de ejemplo blancos y consejo verde claro.
El texto blanco de consejos del PDF debe oscurecerse cuando falle el contraste,
sin cambiar la composición. Diseño adaptable y scroll; a200% reordenar cabecera
editorial y ampliar paneles, no recortar ni escalar texto a la baja. No dibujar el
marco negro del teléfono del PDF ni usar capturas como interfaz.

## Matriz Android, calidad y aceptación

Cruzar API24/API36 ×320×720/412×915dp ×texto100%/200% en widgets y Android cuando
la configuración del dispositivo lo permita; registrar tamaño real por separado.
Al menos un físico para TalkBack, atrás del sistema y ciclo de vida. Sin resultados
reales no declarar compatibilidad ni accesibilidad nativa completadas.

- Objetivos táctiles≥48×48dp, contraste conforme a tabla, foco visible y orden lógico.
- «Ver más: [categoría]» y «Ver ejemplo: [categoría]» distinguibles semánticamente;
  estado expandido y contenido añadido legibles sin reiniciar el recorrido.
- Feedback≤1s y resultado/error≤15s:20 muestras por configuración para carga catálogo,
  carga detalle, reintento y revelado del ejemplo. Registrar máximo e incumplimientos.
- Bloqueantes: acceso privado indebido, escritura pública de contenido, captura de
  datos, contenido falso/no aprobado, rutas erróneas, acciones esenciales inaccesibles,
  regresión de sesión/perfil/descarte, fallo reproducible de criterios de aceptación.
  Todo defecto que incumpla CA se corrige/reprueba antes de aceptación, no se diluye
  mediante una clasificación de severidad.

SC-04.5:5 participantes de40–65años, ambos tramos40–52/53–65 incluidos; evaluación
formativa sin afirmar representatividad. Cada persona identifica una acción preventiva
por categoría y explica que HTTPS/pocas publicaciones no prueban legitimidad/fraude.
Éxito por participante=las seis comprobaciones correctas sin ayuda; meta≥4/5(80%).
Abandono o ayuda cuenta como fallo; error externo de dispositivo se repite, sin
exclusión selectiva. Solo conteos agregados, build y defectos sin identidad; no
registrar nombres, correos, edad exacta, respuestas individuales ni grabaciones.
Protocolo completo en [quickstart](quickstart.md).

## Trazabilidad y secuencia

| Requisito / criterios | Contratos | Validación |
| --- | --- | --- |
| RF-06.a/b; CA-04.1/2 |01,05 | Cuatro entradas, títulos/textos, ejemplo/consejo, comparativa visual P02–P06. |
| RF-06.c; CA-04.4/5; CA-ACC-01–05 |02,04 | Visitante/no verificado/válido, cinco rutas, regreso, sesión y guardas F01–F03. |
| RF-06.d; CA-04.3/6 |01,03 | Fallos, timeout, ausencia/incompleto, reintento, concurrencia/respuesta tardía. |
| RF-06.e; CA-04.7–10 |01,05 | Igualdad con contenido1.0.0, A1–A5, fuentes por categoría y asset exacto. |
| RF-06.f; CA-04.11 |06 |200%, contraste,48dp, semántica, TalkBack y matriz Android. |
| RF-06.g; CA-04.9/12 |02,05 | Sin inputs, acciones externas, permisos nuevos ni historial; revisión de datos. |
| SC-04.1–04.4 |01–06 | Suite completa, integración Android y mediciones. |
| SC-04.5 |06 |≥4/5 participantes según protocolo, sin respuestas individuales guardadas. |

Con el plan aprobado y el bloqueo editorial resuelto: generar tareas trazables,
preparar modelos/contenido y pruebas de contrato; repositorio/estado; UI e integración;
revalidar análisis/suite/APK tras la migración al asset; ejecutar Android offline,
accesibilidad/TalkBack, rendimiento y comprensión; consolidar evidencias y pedir
aceptación de entrega. No hay publicación de contenido ni de reglas de Tips. Un
commit no constituye aceptación ni autoriza otras operaciones del proyecto.

## Riesgos y prerrequisitos abiertos

1. **Fuentes:** contraste externo completado el2026-11-05 con NIST, FTC, RFC Editor
y Google; CISA quedó sin lectura por403 y se cubrió con alternativas primarias.
CA-04.10 no bloquea el plan; conservar el registro de fuentes.
2. **Entorno:** la revalidación Flutter/Android requiere un entorno con SDK y un
dispositivo/emulador; esta instancia Windows no dispone de Flutter en PATH.
No alterar pins ni desactivar comprobaciones.
3. **Contenido local:** el asset debe viajar íntegro y validarse en la APK; un asset
ausente o inválido debe mostrar indisponibilidad recuperable. Actualizar textos
exige nueva versión editorial y nueva APK; no hay publicación remota de Tips.
4. **Evidencia humana/nativa:** TalkBack, dispositivo y participantes se ejecutan
posteriormente; las excepciones F03 no se heredan.

No se propone excepción constitucional ni complejidad adicional sin necesidad.


## Aprobación del responsable — 2026-11-05

El usuario indicó: «Estoy de acuerdo con el plan técnico propuesto para F04. Se
deben conservar los wireframes aprobados, la estructura de las cuatro categorías
y la funcionalidad de “Ver ejemplo” y lo demás».

Se registra su aprobación del diseño técnico presentado, incluidos alcance Android,
lectura pública limitada de contenido, navegación, estados y estrategia de pruebas.
No se vuelve a pedir aprobación de este mismo plan. Se mantienen los textos y
A1–A5 aprobados, los wireframes y las cuatro categorías; no se amplían funciones.

La aprobación no declara resuelta la comprobación externa de fuentes. La nueva
consulta sigue denegada por proxy403. Se prepara [tasks.md](tasks.md) como desglose
preliminar del plan aprobado, sin declarar cerrada la puerta editorial ni iniciar
implementación. No se han ejecutado pruebas F04 ni desplegado reglas/documentos.
El borrador de red incorpora los cuatro dominios documentados en el registro de
fuentes; guardarlo no aplica ni publica esa configuración.


## Prerrequisito editorial resuelto — 2026-11-05

La nueva instancia aplica los dominios publicados. Se consultaron FTC, RFC Editor,
Google y NIST; el registro de fuentes documenta redirecciones, secciones, cobertura
de las cuatro categorías y límites. CISA no es consultable, pero sus alternativas
primarias previstas cubren los consejos. El texto1.0.0/A1–A5 no cambia. Se cierra
el bloqueo editorial T001, sin pedir aprobación otra vez del plan. El responsable
pidió «listo sigamos»: se continúa con herramientas/baseline y ejecución del plan,
sin inferir permiso para publicar en Firebase ni aceptar pruebas humanas pendientes.
