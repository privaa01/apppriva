# Implementation Plan: F03 — Inicio y navegación

**Branch**: `work` | **Date**: 2026-11-03 | **Spec**: [spec.md](spec.md).
**Input**: revisión `d8c4a55`, aprobada explícitamente por el usuario el 2026-11-03.
**Status**: Approved — aprobado explícitamente por el usuario el 2026-11-03.

## Summary

Entregar P01 y una política común para cabecera, menú y retroceso: Tips público,
resto protegido, selección accesible e historial sin duplicaciones. Reutilizar
Flutter/Firebase y el Navigator existentes. Preservar flujos y contratos F01/F02;
no crear backend, dependencias, colecciones, reglas o contenidos F04–F07.

Un catálogo explícito reconoce las rutas; un coordinador por aplicación valida
acceso, salida y generación antes de cambiar la pila. El estado de sección se
deriva de la vista real. Un puerto estrecho del recorrido temporal permite probar
salida y descarte sin recibir respuestas ni implementar un cuestionario ficticio.

## Technical Context

| Campo | Diseño propuesto |
| --- | --- |
| Language/Version | Baseline documentado Flutter 3.47.8 / Dart 3.13.7; comprobar instalación antes de implementar, sin actualizar versiones por conveniencia. |
| Primary Dependencies | MaterialApp, Navigator, RouteObserver, PopScope y WidgetsBindingObserver del SDK; conservar pins y lockfile de Firebase y url_launcher existentes. Cero dependencias nuevas. |
| Storage | Estado de navegación y contrato temporal solo en memoria. Sin restoration de respuestas/resultados, archivos, analítica ni registros de contenido. Datos de cuenta existentes no cambian. |
| Testing | Unit/widget y regresión completa F01/F02; contratos sintéticos de recorrido, accesibilidad automática, integración Android, TalkBack y protocolo formativo con participantes. |
| Target Platform | Android API24 y API36, tamaños 320×720 y 412×915 dp, texto100%/200%; al menos un dispositivo físico para TalkBack/ciclo de vida. Sin iOS. |
| Project Type | App Android existente; módulo pequeño features/navigation con integración en app y componentes comunes. |
| Performance Goals | Feedback visible ≤1s y vista o aviso recuperable ≤15s; veinte mediciones monotónicas por operación y configuración descritas en quickstart. No medir tiempos de proveedores aún no integrados. |
| Constraints | Autorización concedida por F01, invalidación por UID, respeto a guardado F02, descarte constitucional y PD-10 sin decidir. |
| Scale/Scope | P01, cinco controles comunes y catálogo de rutas ya identificadas; sin nuevos perfiles, SDK, finalidades ni SLA de concurrencia. |

API36 es la matriz propuesta, no una afirmación sobre el último Android existente.
Antes de implementar se verifica soporte con el SDK fijado; cualquier sustitución
que afecte la matriz se documenta y somete a revisión, sin elevar minSdk24.
Hoy Docker/Java existen, Flutter/Dart no se encuentran en PATH ni en `.tools`.
El setup de toolchain es prerrequisito de ejecución, no una validación aprobada.

## Constitution Check

Puertas previa y posterior al diseño: **satisfactorias para presentar este plan**.
No constituyen aceptación de implementación ni certificación de cumplimiento jurídico.

| Principio | Control y evidencia prevista |
| --- | --- |
| I — fuente de verdad | Spec aprobado, IDs conservados; contratos C1–C6 y matriz CA enlazados. |
| II — privacidad | No nuevos datos personales, red ni almacenamiento; métricas sanitizadas y protocolo sin identidades. |
| III — temporalidad | Puerto sin contenido, descarte sincrónico por evento, cero restauración; pruebas sintéticas separadas de integración futura. |
| IV — Zyro | Solo destino protegido y texto aprobado; sin proveedor, fuentes o capacidades de IA nuevas. |
| V — accesibilidad | Cinco controles etiquetados/seleccionados, 48dp, contraste, texto200%, TalkBack y protocolo 21/30. |
| VI — calidad/seguridad | Catálogo cerrado, guarda antes del builder, revocación por UID, invalidación de operaciones tardías y matriz Android. |
| VII — trazabilidad | RF-05.a–g → HU-03 → CA/SC → contratos → pruebas futuras; resultados no ejecutados diferenciados. |
| VIII — simplicidad | Un Navigator, coordinador pequeño, observer adicional sin sustituir el de Perfil; ninguna dependencia nueva. |
| IX — etapas | Aprobación del spec registrada; este plan se sincroniza como propuesta. No se generan tareas ni se implementa antes de aprobarlo. |

No se propone excepción constitucional. Los límites de evidencia de F02 permanecen;
F03 debe generar resultados propios y repetir integración de las áreas modificadas.

## Project Structure

### Documentation (this feature)

```text
specs/003-inicio-navegacion/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── contracts/inicio-navegacion.md
├── quickstart.md
└── checklists/requirements.md
```

`tasks.md` se generará después de aprobar el plan. `validation/` contendrá resultados
al ejecutar, sin crear documentos que simulen evidencia previa.

### Source Code — propuesto, no creado

```text
mobile/lib/features/navigation/
├── application/navigation_controller.dart
├── application/navigation_state.dart
├── data/destination_catalog.dart
├── data/temporary_journey.dart
└── presentation/home_screen.dart
mobile/test/features/navigation/
mobile/integration_test/navigation_test.dart
mobile/integration_test/navigation_performance_test.dart
```

Integración en `app/priva_app.dart`, `app/account_router.dart`,
`features/account/presentation/account_scaffold.dart`,
`features/account/application/account_state.dart` y `account_controller.dart`.
Adaptación mínima del guard de salida de `features/profile/presentation/profile_screen.dart`.
No modificar reglas de Firestore, proveedores o persistencia de cuenta.

**Structure Decision:** un solo módulo nuevo, sin segundo sistema de autenticación.
Conservar el observer de Perfil y los parámetros existentes de PrivaApp usados por
las pruebas. Los destinos de prueba nunca eluden el catálogo y la autorización.

## Diseño y decisiones de integración

### Catálogo y acceso — C1

Registrar las rutas de [contratos](contracts/inicio-navegacion.md). Resolver primero
ruta conocida, luego acceso y finalmente precondiciones de resultados. Un path
arbitrario no hereda permisos solo por existir una sesión. No poner UID, respuestas,
resultado ni correos en rutas o argumentos. Mensajes desconocido/no disponible
con acción permitida, sin registrar el path bruto recibido.

La guarda actual sigue impidiendo construir contenido privado mientras se retira
el historial. En AccountController, un stream de sesión nula, inválida o de UID
distinto revoca la concesión vigente e incrementa generación; nunca concede B por
recibir un evento. Concesiones nuevas siguen el flujo validado F01.

### Historial y solicitudes de navegación — C2

Coordinador ligado a la vida de PrivaApp y navigatorKey; observer adicional mantiene
solo referencias transitorias a rutas reconocidas. Seleccionar ruta activa es no-op;
si el destino ya existe, volver hasta su entrada; si es nuevo, push. El observer
sincroniza sección tras push/pop/remove/replace y operaciones existentes de F01/F02.
No mantener un índice de pestaña independiente de la ruta visible.

Antes de modificar la pila: validar acceso y guard de salida; capturar UID,
generación de navegación y del recorrido. Una confirmación pendiente bloquea
solicitudes duplicadas. Tras esperar, revalidar todo; si cambió, descartar la intención.
Ningún diálogo tardío puede restaurar contenido. Pérdida/cambio de sesión limpia
historial privado y deja acceso, conservando Tips como destino público disponible.
La guarda oculta datos sin esperar al callback de navegación; cambios de pila se
programan de forma segura fuera de build y se agrupan para no duplicar reemplazos.

Entrada con visitante continúa en `/signin`; acceso exitoso usa `/home` con pila
limpia, sin redirección a ruta privada solicitada. Registro/recuperación mantienen
sus flujos. Detalle Tips abierto directamente establece catálogo como padre lógico
para cumplir retorno detalle→Tips; esto no crea duplicados si ya existe. Una raíz
sin padre permite el comportamiento de salida normal de Android. Pulsar sección
Cuestionario desde Resultados abandona resultado y abre una entrada sin resultado;
no se ofrece recuperar un intento completado al retroceder.

### Fronteras de Perfil y recorrido temporal — C3/C4

Perfil expone un guard de salida que bloquea navegación voluntaria durante saving,
con aviso comprensible; unknown puede salir conforme a F02. No cancelar escritura
remota ni desmontar el control de reconciliación como sustituto de confirmación.
Cierre de sesión o invalidación prevalecen, con limpieza e ignorado de respuesta tardía.
Conservar las notificaciones RouteAware: salir limpia borrador, regresar consulta
servidor, y un diálogo auxiliar no se trata como otra PageRoute.

Puerto temporal sin respuestas: fase, posibilidad de pregunta anterior, generation,
`previousQuestion` y `discard`. Retroceso en pregunta posterior delega al puerto;
primera pregunta o selección de otro destino solicita confirmar descarte. Cancelar
conserva el intento. Confirmar descarta antes de cambiar ruta. Salir de resultado
descarta sin diálogo. Un descarte invalida generación, deja fase idle y borra las
referencias temporales; las rutas no guardan copias para reconstruirlo.

Producción usa puerto vacío mientras no existan F06/F07. `/results` sin resultado
se resuelve de forma segura con opción Volver al cuestionario; no se simula score.
Las pruebas usan doble sintético sin persistencia ni preguntas reales. No se declara
F06/F07 aceptado ni integrado por pasar estos contratos.

### Ciclo de vida — C5

Un observador raíz descarta en hidden/paused/detached y dispose, de forma idempotente.
Inactive cubre contenido sensible; no prueba por sí solo un cambio a segundo plano.
Al volver a resumed se muestra recorrido vacío/entrada válida si fue descartado;
un aviso pendiente ya no puede revivirlo. No llamar signOut por segundo plano.
Android puede matar sin callback: no restaurar estado del cuestionario, no usar
restoration IDs para contenido ni persistirlo. Validar Home, recientes, retorno,
notificaciones y reinicio, sin confundir recuperación de cuenta con restauración
de respuestas. PD-10 de pérdida de red en primer plano sigue sin resolverse.

### Presentación y accesibilidad — C6

P01 sigue composición del wireframe y los textos aprobados en spec; tres tarjetas
que usan la misma intención que el menú. No insertar otra imagen Zyro por inferencia.
Estado activo visible mediante forma/borde/peso además de color y anunciado por
`Semantics(selected: true)` sin duplicar lectura de icono y texto. P11 sin falsa
selección privada. Mantener P10 sin navegación nueva. Diseñar reflujo para320dp y
texto200% sin recorte de los cinco controles; no resolverlo reduciendo texto del usuario.

## Validación y severidad

- Matriz automática: todos los destinos por visitante, no verificado/no autorizado,
  autenticado, pérdida de sesión y cambio UID; nunca construir builder privado sin permiso.
- Historial:20 reselecciones, A→B→A, detalles directos, raíz, resultado sin intento,
  desconocidos y rutas existentes F01/F02. Registrar que la pila puede salir.
- Contratos temporales: revisión, cancelación, confirmación, resultado, evento de
  ciclo de vida y confirmación tardía; comparar generación y verificar cero restauración.
- Regresión completa F01/F02; restaurar expectativas solo si el cambio responde
  al spec aprobado, no borrar pruebas que descubran fallos reales.
- Accesibilidad: 48dp, contraste4.5:1 normal/3:1 grande/componentes, etiquetas y
  selección;320×720 y412×915,100%/200%, TalkBack en API24/API36 y un Android físico.
- Rendimiento: feedback≤1s y resolución/aviso≤15s,20 repeticiones por acción/matriz;
  separar espera humana del diálogo y tiempo de carga remota F02. Detalles en quickstart.
- Usabilidad:5 participantes,6 tareas cada uno,≥21/30 sin ayuda. Prueba formativa,
  no estadística. No sustituirla por tests widget o conformidad de un único usuario.
- Crítico: exposición privada, UID cruzado, respuestas/resultados persistidos o
  restaurados tras descarte. Alto: falsear estado activo, bucle sin salida, salida
  sin advertencia/cancelación o acceso habilitado por confirmación tardía. Cualquier
  CA incumplido bloquea entrega; corregir y repetir. No eximir defectos visuales que
  impidan navegación, lectura o activación.

## Complexity Tracking

Ninguna violación constitucional ni excepción propuesta. Un coordinador con catálogo
cerrado y un puerto temporal son proporcionales al historial, los cinco controles y
las guardas requeridas. No introducir un router externo, navegador por pestaña,
servicio de analítica ni almacenamiento nuevo.

## Estado y aprobación

Diseño completo con [investigación](research.md), [modelo](data-model.md),
[contratos](contracts/inicio-navegacion.md) y [guía](quickstart.md). No hay hooks
antes/después: `.specify/extensions.yml` no existe. Script setup-plan selecciona
lógicamente003; la rama Git real sigue siendo `work`. No se ha implementado,
generado tasks.md, desplegado ni ejecutado una prueba de producto F03.
La aprobación de este plan autorizará generar tareas; su ejecución requiere la
aprobación de esa etapa según la constitución. F04 permanece sin avanzar.

## Registro de aprobación del plan — 2026-11-03

El usuario respondió «apruebo» a la solicitud de aprobar el plan del commit
`125f313`. Quedan aprobados diseño, investigación, modelo, contratos, matriz Android,
presupuestos y protocolo de usabilidad de esa revisión. Se autoriza generar tareas,
no ejecutarlas ni implementar. Las referencias anteriores a propuesta son históricas
y no constituyen evidencia de que las pruebas o el estudio se hayan realizado.

## Tareas generadas tras aprobación

Se preparó [tasks.md](tasks.md) con35 tareas pendientes vinculadas a HU-03,
contratos C1–C6 y criterios de aceptación/éxito. No se ha ejecutado ninguna;
se requiere autorización de la etapa de tareas antes de implementar.

## Implementación autorizada — 2026-11-03

El usuario aprobó las tareas del commit2cd833f e iniciar implementación mediante
«apruebo». Se implementó el módulo y la integración F01/F02;27/35 tareas completadas
como desarrollo/regresión local/preparación de runners. Las124 pruebas locales
y análisis0 diagnósticos no certifican Android físico, mediciones ni participantes.
Consultar validation/current-results.json y delivery-review.md; sin aceptación
final ni avance a F04. Los estados anteriores describen la historia de planificación.

## Cierre de entrega — 2026-11-04

El usuario confirmó sesión conservada y aprobó terminar F03. Se registra aceptación
con las limitaciones de evidencia y controles parciales/aplazados del
[acta de cierre](validation/closure-2026-11-04.md), sin afirmar que se ejecutaron
pruebas ausentes ni trasladar esas excepciones a otros specs.
