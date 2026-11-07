# Implementation Plan: F06 — Cuestionario temporal

**Branch:** `work` | **Date:** 2026-11-05 | **Spec:** [spec.md](spec.md)
**Selección:** `SPECIFY_FEATURE_DIRECTORY=specs/006-cuestionario-temporal`
**Estado:** plan aprobado; banco y modelo editorial actualizados por decisión del responsable el 2026-11-07.

## Summary

Entregar P08 protegida con un banco local aprobado de 67 preguntas completas, selección de diez
sin repetición y cobertura de cinco módulos, tres opciones reordenables con IDs estables,
revisión dentro del intento y descarte obligatorio. Todo el intento vive en RAM. Un
asset JSON inmutable contiene contenido y porcentajes; no hay Firestore, archivos de estado,
analítica, IA ni red para preguntas o respuestas. La conectividad solo habilita o
pausa el avance mediante un puerto aislado y nunca recibe contenido del intento.

## Technical Context

| Campo | Decisión |
| --- | --- |
| Language/Version | Flutter3.47.8 y Dart3.13.7 vigentes; conservar pins existentes. |
| Primary Dependencies | Flutter Material, Navigator, ChangeNotifier, `connectivity_plus 7.3.2`; sin backend ni IA para F06. |
| Storage | Asset `assets/content/questionnaire-2.0.0.json` de solo lectura. Intento, orden, selecciones y snapshot completo solo en objetos Dart en RAM. |
| Testing | Unitarias de esquema/selección/estado; widgets P08; navegación/ciclo de vida; integración Android sintética; inspección de almacenamiento/tráfico/logs. |
| Target Platform | Android API 24 y API36;320×720 y 412×915dp; texto 100%/200%; TalkBack físico pendiente de ejecución. |
| Project Type | Módulo `features/questionnaire` dentro de la app Flutter existente. |
| Performance Goals | Feedback de selección/continuar≤1s; inicio, pausa o error≤15s; 20 ciclos por operación, excluyendo tiempo humano. |
| Constraints | Exactamente10 preguntas, una opción por pregunta, sin persistencia ni envío; segundo plano/logout/salida confirmada descartan; pérdida de red reportada pausa en primer plano. |
| Scale/Scope | P08 y transición autorizada a `/results`; 67 preguntas completas, 5 módulos y 3 opciones con porcentaje; F07 define el cálculo y presenta resultados después. |

`connectivity_plus` informa disponibilidad de interfaces, no garantiza acceso extremo
a extremo. F06 tratará `none` como pérdida y conservará un puerto para que F08 pueda
refinar la comprobación sin tocar respuestas. No se añade un sondeo remoto porque
crearía tráfico y finalidad no aprobados. Las pruebas simulan el puerto y la matriz
Android registra esta limitación.

## Constitution Check

**Puerta previa:** aprobada para planificar. El spec y banco fueron aprobados; F05
permanece abierto por instrucción posterior del responsable y no se declara cerrado.
La excepción secuencial está registrada en `specs/README.md`. El plan no autoriza
implementación ni cierre.

| Principio | Control del plan |
| --- | --- |
| I — fuente de verdad | RF-10/11/15, HU-06 y CA-06.1–5 trazados al banco2.0.0, contratos y pruebas. El PDF aporta porcentajes por opción. |
| II — privacidad | F06 no trata identidad nueva ni transmite respuestas. Conectividad recibe únicamente estado de interfaz. |
| III — sin persistencia | Modelos sin serialización; ninguna dependencia de preferencias, archivos, Firestore, Crashlytics o analítica; auditoría negativa obligatoria. |
| IV — Zyro | Sin llamadas a Zyro/Vertex y sin uso de conversación. |
| V — accesibilidad | Texto sencillo, scroll, opciones≥48dp, encabezados/progreso/selección anunciados, texto200%, contraste y TalkBack. |
| VI — calidad/seguridad | Guarda de sesión existente, acceso directo protegido, asset estricto, selección determinista en pruebas, errores seguros y descarte por ciclo de vida. |
| VII — trazabilidad | IDs Q001–Q067 y option IDs estables; matriz RF/CA→contratos→tareas→pruebas/resultados. |
| VIII — simplicidad | Asset y estado local; una dependencia solo para decisión de pausa; sin backend, sincronización ni historial. |
| IX — etapas | Plan requiere aprobación antes de tareas. Commits de artefactos no equivalen a aprobación. |

**Revisión posterior al diseño:** pasa. `data-model.md` prohíbe serialización; los
contratos separan contenido, intento, navegación y conectividad. No quedan
decisiones técnicas sin resolver. La ejecución Android/humana sigue siendo evidencia
futura, no resultado de este plan.

## Project Structure

```text
specs/006-cuestionario-temporal/
├── spec.md
├── banco-preguntas.md
├── plan.md
├── research.md
├── data-model.md
├── contracts/questionnaire.md
├── quickstart.md
└── checklists/requirements.md

mobile/assets/content/questionnaire-2.0.0.json
mobile/lib/features/questionnaire/
├── domain/question.dart
├── domain/question_bank.dart
├── data/bundled_question_bank_repository.dart
├── data/question_bank_repository.dart
├── application/questionnaire_controller.dart
├── application/questionnaire_connectivity.dart
├── data/platform_questionnaire_connectivity.dart
└── presentation/questionnaire_screen.dart
mobile/test/features/questionnaire/
mobile/integration_test/questionnaire_test.dart
```

Integraciones mínimas: declarar asset/dependencia en `pubspec.yaml`; componer
repositorio, conectividad y controlador en `main.dart`/`priva_app.dart`; resolver
`/questionnaire` en `account_router.dart`; sustituir `EmptyTemporaryJourney` por el
controlador real sin cambiar guardas F01–F05. F07 podrá leer un snapshot completo
solo en memoria mediante un puerto tipado; F06 no calcula el resultado.

## Diseño

### Contenido y selección

El repositorio decodifica una vez el asset, exige esquema/versiones/campos exactos,
67 IDs únicos activos, cinco módulos conocidos, tres opciones únicas por pregunta y
un porcentaje entero 0–100 por opción. Cualquier fallo invalida el banco completo.

Al comenzar, seleccionar una pregunta aleatoria por tema; luego elegir tres temas
distintos para una segunda pregunta, de modo que ningún tema exceda dos. Aplicar
Fisher–Yates a preguntas y opciones. Inyectar la fuente aleatoria en pruebas. Los
IDs y porcentajes nunca cambian; el orden queda congelado durante el intento.

### Estado y ciclo de vida

`QuestionnaireController` implementa `TemporaryJourney`. Al iniciar crea un intento
en RAM; seleccionar reemplaza la opción de la pregunta actual. Continuar exige
selección; atrás revisa la pregunta anterior. La décima respuesta completa cambia
la fase a `result` y expone un `CompletedAttempt` inmutable únicamente a F07.

Salida voluntaria usa la confirmación F03. Confirmar, background/hidden/detached,
logout/cambio UID, dispose o fin de proceso elimina preguntas seleccionadas,
respuestas y snapshot. Cancelar conserva. No usar restoration IDs, preferencias,
archivos, base de datos, parámetros de ruta o logs.

### Conexión

El puerto emite `available/unavailable`. `unavailable` en primer plano mantiene el
intento en RAM, bloquea Continuar e informa «Se pausó el cuestionario. Revisa tu
conexión para continuar». Recuperar `available` reanuda sin reordenar. El evento de
segundo plano conserva precedencia y descarta. Cambios de red no incluyen preguntas,
IDs de respuestas, UID ni métricas.

### P08 y accesibilidad

Estado inicial: aviso literal de temporalidad y botón «Comenzar». Intento: «Pregunta
X de 10», enunciado, grupo de tres opciones únicas y Continuar; en la décima,
«Ver resultado». Atrás revisa; seleccionar otra reemplaza. Carga/error de asset,
banco insuficiente y pausa tienen mensajes simples y recuperación cuando procede.
No revelar porcentajes antes del resultado.

Usar `AccountScaffold`, menú y colores vigentes, scroll y diseño adaptable sin marco
del teléfono. Semántica: encabezado, progreso, grupo, opción seleccionada, pausa/error
y botones. Objetivos≥48dp; contraste4.5:1 normal,3:1 grande/controles; texto200%.

## Riesgos y validación

| Riesgo | Control |
| --- | --- |
| Persistencia accidental | Búsqueda estática y auditoría de storage/Firestore/logs/APK; pruebas de reinicio y lifecycle. |
| Clave alterada al mezclar | IDs estables y pruebas de múltiples semillas/permutaciones. |
| Banco incompleto | Validación atómica; no iniciar con un total distinto de 67 preguntas completas o sin cobertura. |
| Respuesta tardía tras descarte | Generación del intento y rechazo de eventos de otra generación. |
| Falso positivo de conectividad | Puerto documentado y prueba Android; F08 puede sustituir adaptador. |
| Regresión F03 | Suite completa de navegación, salida, background, logout y resultado protegido. |

La matriz cruza API24/API36 ×320×720/412×915 ×texto 100/200%. TalkBack físico cubre
aviso, progreso, opciones, selección, Continuar, pausa, error y salida. Cinco
participantes40–65 realizan tareas; solo se guardan conteos agregados.

## Complexity Tracking

No hay violaciones que justificar. El puerto de conectividad evita acoplar el
controlador a un plugin y permite sustituir la detección en F08.

## Aprobación

El responsable aprobó el plan el 2026-11-05 con «apruebo». Esta aprobación autoriza
generar tareas; no autoriza todavía su ejecución ni la implementación.
