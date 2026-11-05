# Implementation Plan: F04 — Tips educativos

**Branch:** `work` | **Date:** 2026-11-04 | **Spec:** [spec.md](spec.md).
**Selección:** `SPECIFY_FEATURE_DIRECTORY=specs/004-tips-educativos`; el script
reporta el identificador lógico004-tips-educativos, no crea ni cambia la rama real.
**Estado:** plan técnico aprobado explícitamente por el responsable el2026-11-05;
contraste editorial completado en esa fecha. Implementación local verificada;
pruebas nativas/humanas y publicación pendientes, sin aceptación de entrega.
**Entrada:** categorías, textos y wireframes confirmados; A1–A5 aprobados por
«si los apruebo». [Contenido final](contenido-editorial.md), versión1.0.0.

## Summary

Entregar P02 y los cuatro detalles P03–P06, públicos, siguiendo los wireframes,
con explicaciones internas «Ver ejemplo» y textos aprobados. Reutilizar Flutter,
Navigator, AccountScaffold, tema, Firebase y la imagen existente de Zyro.

Se propone distribuir cuatro documentos públicos de contenido mediante Firestore,
con lecturas explícitas al servidor y sin persistencia local. Esto mantiene el
requisito de conexión del spec sin crear un CMS, sondeo de conectividad o proveedor
nuevo. No publicar reglas ni documentos en esta etapa. Su publicación posterior
requiere acceso administrativo autorizado y comprobaciones previas.

## Technical Context

| Campo | Diseño propuesto |
| --- | --- |
| Language/Version | Baseline del proyecto Flutter3.47.8 / Dart3.13.7; verificar instalación antes de ejecutar. No actualizar pins/lockfile por conveniencia. |
| Primary Dependencies | Flutter Material, Navigator y ChangeNotifier; cloud_firestore7.1.0 y firebase_core5.1.0 ya declarados. Ninguna dependencia nueva. |
| Storage | Cuatro documentos públicos `/educational_tips/{id}`; estado de consulta y explicación solo en memoria. `persistenceEnabled:false` ya configurado en main. Sin visitas, favoritos, respuestas ni datos de cuenta en contenido. |
| Testing | Unit/widget, repositorio con dobles deterministas, reglas Firestore en emulador, regresión F01–F03, Android nativo y evaluación humana. |
| Target Platform | Android API24 y API36;320×720 y412×915dp; texto100%/200%; al menos un Android físico con TalkBack. Web añadido al repo no amplía el alcance aprobado. |
| Project Type | Módulo `features/tips` en app existente y ampliación mínima de reglas Firestore. |
| Performance Goals | Primer feedback≤1s; contenido o aviso recuperable≤15s.20 repeticiones por operación/configuración, sin incluir espera humana. Timeout explícito y descarte de respuesta tardía. |
| Constraints | Lectura pública independiente de autorización de cuenta; servidor obligatorio para cada carga/reintento; sin fallback offline. Catálogo cerrado; ejemplos inertes. |
| Scale/Scope | Cinco pantallas, cuatro categorías, tres recomendaciones por detalle, versión editorial tips-1.0.0. Sin chat, cuestionario, CMS ni generador/analizador de claves o URLs. |

El entorno de esta revisión no tiene Flutter/Dart en PATH ni `/workspace/.tools`.
No se han ejecutado pruebas Flutter ni Android de F04. Los fallos de descarga
históricos son prerrequisitos de ejecución, no defectos confirmados del módulo.

## Constitution Check

**Revisión previa y posterior:** alcance, A1–A5 y plan aprobados; contraste editorial
cerrado2026-11-05 y ejecución local autorizada por «listo sigamos». No se propone
violación constitucional.182 pruebas Flutter,24 reglas/preflight y APK compilado
acreditan el tramo local; no cierran la puerta de entrega, con controles nativos,
humanos, privacidad remota y publicación aún pendientes.

| Principio | Diseño y evidencia exigida |
| --- | --- |
| I — fuente de verdad | Contenido1.0.0, IDs preservados, comparación de P02/P03–P06 y registro A1–A5. |
| II — privacidad | Solo contenido público; sin UID en rutas/documentos ni registro de lectura. Firebase puede transportar autenticación existente si hay sesión, sin exigirla ni personalizar. Sin nuevo SDK. Firestore puede procesar metadatos operativos de red y ruta; no prometer ausencia de registros del proveedor. Revisar tráfico, configuración de logs y política existente antes de publicar el nuevo uso. |
| III — temporalidad | Tips no recibe respuestas/resultados. Regresión de salida, cambio UID y descarte del puerto F03; no persistencia ni restauración añadida. |
| IV — Zyro | Imagen decorativa en P02, sin servicio de IA, conversación ni promesas nuevas. |
| V — accesibilidad | Texto200%,48dp, contraste4.5:1 texto normal y3:1 texto grande/controles; TalkBack y protocolo SC-04.5 definidos abajo. |
| VI — calidad | Reglas get público solo4 IDs, list/escrituras denegados; no ampliar permisos de cuenta. Manejo de errores/timeout, rutas y pruebas sintéticas. |
| VII — trazabilidad | Matriz RF/CA→contratos→validaciones; tareas detalladas se generan tras aprobación del plan. |
| VIII — simplicidad | Un router; un repositorio de lectura; sin listeners permanentes, índices, CMS, analítica, conectividad artificial ni dependencias nuevas. |
| IX — etapas | Aprobación técnica y fuentes registradas; ejecución local autorizada. Tareas/resultados distinguen pruebas locales, nativas, humanas y remotas. Commit no equivale a entrega aceptada. |

La consulta de NIST fue satisfactoria desde su repositorio oficial. Otras fuentes
están pendientes por acceso de red, ver [registro](fuentes-editoriales.md).
Esto bloquea declarar cerrado el plan editorial y entregar CA-04.10; no se oculta
como decisión resuelta ni se transforma en una excepción de F03.

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

`tasks.md` y resultados en `validation/` se crean en sus etapas, no como pruebas
ficticias de una implementación que todavía no existe.

### Source Code — propuesto, no creado

```text
mobile/lib/features/tips/
├── data/tip_content.dart
├── data/tips_repository.dart
├── data/firestore_tips_repository.dart
├── application/tips_controller.dart
├── presentation/tips_catalog_screen.dart
└── presentation/tip_detail_screen.dart
mobile/test/features/tips/
mobile/integration_test/tips_test.dart
mobile/integration_test/tips_performance_test.dart
firebase/tests/tips.test.mjs
firebase/content/tips-1.0.0.json
```

Integraciones mínimas: `main.dart`, `app/priva_app.dart`, `app/account_router.dart`,
`features/navigation/data/destination_catalog.dart` y extensión compatible del
`AccountScaffold` si necesita encabezado propio. Modificar `firebase/firestore.rules`
solo para C-TIPS-02 y conservar demo_contact, privacy_suppressions, perfiles y evidencia.
El JSON editorial propuesto es contenido público revisable, nunca credenciales.
No crear nueva infraestructura ni cambiar proyectos Firebase.

## Diseño e integración

### Distribución y acceso — C-TIPS-01/02

Catálogo de IDs/rutas cerrado; cuatro `get` paralelos por catálogo, uno por detalle,
siempre `GetOptions(source:Source.server)`. Catálogo listo solo cuando las cuatro
entradas son válidas y de la versión soportada. No listar colección ni aceptar una
ruta arbitraria. Lecturas sin sesión permitidas en reglas; sin listener Auth de Tips.
Con sesión, el SDK existente puede adjuntar su identidad, pero el resultado no depende
de UID, correo, perfil, autorización, cuestionario o conversaciones.

Conservar `persistenceEnabled:false` antes de cualquier instancia usada. No usar
`enablePersistence`, snapshots de caché, archivos de contenido leídos como fallback
ni restauración de visitas. Una pantalla ya cargada puede seguir visible: no se
promete monitorización continua de conexión. Cada nueva carga/reintento requiere
respuesta del servidor; desconexión produce error recuperable, no contenido offline.

Componer el repositorio desde Firebase inicializado aunque falle la validación de
cuenta; separar su creación del flujo Auth dentro del bloque de arranque para que
un fallo de Auth no convierta Tips en privado. Si falla Core/configuración, inyectar
repositorio no disponible, con reintento de inicialización seguro, sin mentir sobre
recuperación. Sin credenciales administrativas dentro de Flutter.

### Estado y concurrencia — C-TIPS-03

Un controlador por pantalla mantiene destino, generación, fase y contenido público.
Cada carga incrementa generación; solo la respuesta de la solicitud vigente, con
pantalla viva, puede publicarse. Timeout a15s; no cancelar por suposición el Future
del SDK: invalidar su efecto. Reintentos concurrentes se agrupan, y volver/cambiar
categoría/dispose invalida la operación. No dejar el texto de la categoría anterior
como sustituto mientras carga otra. Excepciones del proveedor no se imprimen ni muestran. `permission-denied` para
un ID Tips conocido se presenta como unavailable sin inventar el motivo; otros
fallos transitorios/timeout como error.

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

## Trazabilidad y secuencia propuesta

| Requisito / criterios | Contratos | Validación futura |
| --- | --- | --- |
| RF-06.a/b; CA-04.1/2 |01,05 | Cuatro entradas, títulos/textos, ejemplo/consejo, comparativa visual P02–P06. |
| RF-06.c; CA-04.4/5; CA-ACC-01–05 |02,04 | Visitante/no verificado/válido, cinco rutas, regreso, sesión y guardas F01–F03. |
| RF-06.d; CA-04.3/6 |01,03 | Fallos, timeout, ausencia/incompleto, reintento, concurrencia/respuesta tardía. |
| RF-06.e; CA-04.7–10 |01,05 | Igualdad con contenido1.0.0, A1–A5, fuentes por categoría y reglas. |
| RF-06.f; CA-04.11 |06 |200%, contraste,48dp, semántica, TalkBack y matriz Android. |
| RF-06.g; CA-04.9/12 |02,05 | Sin inputs, acciones externas, permisos nuevos ni historial; revisión de datos. |
| SC-04.1–04.4 |01–06 | Suite completa, integración Android y mediciones. |
| SC-04.5 |06 |≥4/5 participantes según protocolo, sin respuestas individuales guardadas. |

Después de aprobar el plan y resolver su bloqueo editorial: generar tareas trazables,
preparar modelos/contenido y pruebas de contrato; repositorio/estado; UI e integración;
reglas con regresión; Android/accesibilidad/comprensión; publicar contenido/reglas
solo con acceso autorizado y alcance explícito; verificar app contra servicio real
con datos sintéticos; consolidar evidencias y pedir aceptación de entrega. Publicar
contenido/reglas no constituye aceptación ni autoriza otras operaciones del proyecto.

## Riesgos y prerrequisitos abiertos

1. **Fuentes:** falta consulta externa completa para CA-04.10; CISA y RFC Editor
devuelven403. Completar revisión verificable antes de cerrar planificación editorial.
2. **Entorno:** Flutter/Android y emulador Firestore requieren preparación; no hay
pruebas de producto en esta etapa. No alterar pins ni desactivar comprobaciones.
3. **Publicación:** nueva colección pública y reglas incluidas en el plan aprobado;
acceso administrativo se comprueba en la etapa pertinente por canales seguros,
nunca se piden claves en chat. Sin despliegue, cliente debe mostrar indisponibilidad.
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
