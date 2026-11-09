# Tasks: F07 — Resultados orientativos y repetición

**Input:** artefactos aprobados de `specs/007-resultados-repeticion/`.
**Estado:** tareas aprobadas e implementación autorizada mediante «termina» el 2026-11-07.
**Historia:** HU-07 (P1), RF-12–15, CA-07.1–5.

Todas las pruebas usan intentos, sesiones y porcentajes sintéticos. Una casilla se
marca únicamente con evidencia; commit, prueba o plan no equivalen a aprobación.

## Phase 1: Setup — baseline y contenido

**Purpose:** fijar el estado previo y transformar el catálogo aprobado sin cambiar dependencias.

- [x] T001 Registrar aprobación de spec, catálogo y plan, además del estado F06 cerrado/F05 pendiente, en `specs/007-resultados-repeticion/spec.md`, `plan.md`, `tasks.md` y `specs/README.md`.
- [x] T002 Documentar el baseline aprobado de F06 y el aplazamiento solicitado del APK, sin modificar pins, en `specs/007-resultados-repeticion/validation/baseline.md`.
- [x] T003 Convertir literalmente los cinco módulos y tres acciones aprobadas a `mobile/assets/content/result-recommendations-1.0.0.json`, con esquema1, versión, estado y revisión, y declararlo en `mobile/pubspec.yaml`.
- [x] T004 [P] Crear fixtures de intentos completos/parciales, sumas frontera, empates, catálogo válido/inválido y sesiones sintéticas en `mobile/test/features/questionnaire/result_test_fixtures.dart`.

**Checkpoint:** baseline y contenido preparados; todavía no se calcula ni muestra un resultado.

---

## Phase 2: Foundational — contratos y pruebas primero

**Purpose:** fijar mediante pruebas fallidas la fórmula, privacidad y acceso antes de implementar HU-07.

- [x] T005 [P] Probar entrada exacta de diez selecciones, option IDs pertenecientes y rechazo de parcial/módulos inválidos en `mobile/test/features/questionnaire/result_assessment_test.dart`.
- [x] T006 [P] Probar suma/promedio y fronteras 0,19,19.5,20,59,59.5,60,100 sin redondeo previo en `mobile/test/features/questionnaire/result_calculator_test.dart`.
- [x] T007 [P] Probar dos respuestas por módulo, top3 descendente y desempate passwords/access/networks/phishing/devices en `mobile/test/features/questionnaire/result_priority_test.dart`.
- [x] T008 [P] Probar esquema exacto, cinco módulos, tres acciones literales, caché RAM y rechazo atómico en `mobile/test/features/questionnaire/result_recommendation_repository_test.dart`.
- [x] T009 [P] Probar guarda de visitante/no verificado/sin snapshot, acceso válido, descarte por salida/background/logout/cambio UID/dispose y eventos tardíos en `mobile/test/features/questionnaire/result_navigation_test.dart`.
- [x] T010 [P] Probar P09 loading/ready/error/restarting, porcentaje/nivel/aviso/top3, 320×720/412×915, texto100/200%, semántica, foco,48dp y contraste en `mobile/test/features/questionnaire/result_screen_test.dart`.

**Checkpoint:** las reglas aprobadas tienen oráculos independientes y fallan hasta existir la implementación.

---

## Phase 3: HU-07 — Comprender el resultado y repetir (Priority: P1) 🎯 MVP

**Goal:** transformar diez selecciones temporales en orientación comprensible, mostrar P09 y repetir sin conservar historial.

**Independent Test:** intento sintético completo → promedio/nivel/top3 exactos → P09
orientativa → doble toque Repetir produce un solo intento nuevo; abandonar impide
restaurar resultado y no deja almacenamiento, red o logs.

### Dominio y contenido

- [x] T011 [P] [US1] Implementar `ResultLevel`, `ResultAssessment` y `ModuleAssessment` inmutables/no serializables con total0–1000, tres prioridades y generación en `mobile/lib/features/questionnaire/domain/result_assessment.dart`.
- [x] T012 [P] [US1] Definir `ResultRecommendationCatalog`, errores seguros y puerto de solo lectura sin escritura en `mobile/lib/features/questionnaire/data/result_recommendation_repository.dart`.
- [x] T013 [US1] Implementar cálculo puro por suma entera, formato entero/décima, niveles `<200`/`<600`/resto y top3 estable en `mobile/lib/features/questionnaire/domain/result_calculator.dart`.
- [x] T014 [US1] Implementar validación atómica y caché únicamente RAM del asset editorial en `mobile/lib/features/questionnaire/data/bundled_result_recommendation_repository.dart`.

### Estado, repetición y ciclo de vida

- [x] T015 [US1] Consumir el snapshot que `QuestionnaireController` expone solo durante `JourneyPhase.result` y coordinar una única repetición por generación desde `ResultController`.
- [x] T016 [US1] Implementar `ResultController` con estados loading/ready/error/restarting, cálculo una vez por generación, reintento editorial y rechazo de eventos tardíos en `mobile/lib/features/questionnaire/application/result_controller.dart`.
- [x] T017 [US1] Integrar descarte total en exit/background/session/dispose y asegurar que repetir elimina primero el resultado sin cerrar sesión en `mobile/lib/features/questionnaire/application/result_controller.dart` y `questionnaire_controller.dart`.

### P09 e integración de aplicación

- [x] T018 [US1] Implementar P09 en `mobile/lib/features/questionnaire/presentation/result_screen.dart` con Resultado orientativo, porcentaje, nivel textual, explicación, aviso literal, tres módulos×tres acciones, error/reintento y Repetir; sin selecciones ni garantías.
- [x] T019 [US1] Añadir semántica, encabezados, orden de foco, scroll, objetivos≥48dp y presentación independiente del color en `mobile/lib/features/questionnaire/presentation/result_screen.dart`.
- [x] T020 [US1] Componer asset/repositorio/controlador de resultado junto al controlador F06 sin almacenamiento en `mobile/lib/app/priva_app.dart`.
- [x] T021 [US1] Resolver `/results` con guarda y snapshot real, preservando builders F01–F06, en `mobile/lib/app/account_router.dart`.
- [x] T022 [US1] Implementar Repetir como descarte→inicio único→P08, manejar doble toque/fallo y evitar restauración mediante `mobile/lib/features/navigation/application/navigation_controller.dart` y `result_screen.dart`.
- [x] T023 [US1] Actualizar disponibilidad de `/questionnaire` y `/results` sin alterar permisos en `mobile/lib/features/navigation/data/destination_catalog.dart` y sus pruebas.
- [x] T024 [US1] Añadir recorrido Android sintético de cálculo, visualización, repetición y descarte en `mobile/integration_test/result_test.dart`, sin Firebase/IA/cuentas personales.

**Checkpoint:** HU-07 funciona extremo a extremo; no existe historial ni dependencia remota.

---

## Phase 4: Polish, privacidad y entrega

- [x] T025 Ejecutar análisis, suite Flutter completa y reglas; confirmar que F07 no usa Functions y registrar el aplazamiento solicitado del APK en `specs/007-resultados-repeticion/validation/technical-results.md`.
- [x] T026 Verificar igualdad literal catálogo↔asset, versión, fuente y SHA-256 en `mobile/test/features/questionnaire/result_editorial_test.dart` y `specs/007-resultados-repeticion/validation/editorial-review.md`.
- [x] T027 Auditar código, almacenamiento, Firestore, tráfico y logs con datos sintéticos; acreditar cero respuestas/resultados/derivados persistidos o enviados en `specs/007-resultados-repeticion/validation/privacy-security.md`.
- [x] T028 Ejecutar20 ciclos de cálculo/catálogo/doble repetición/error/reintento con feedback≤1s y resolución≤15s; responsable confirmó 20/20 satisfactorios el 2026-11-09, sin conservar tiempos individuales.
- [x] T029 Completar matriz automatizada 320×720/412×915,texto100/200% y validación física en Motorola G22/Android12; API24/API36 físicos no ejecutados y aceptados como limitación de cierre el 2026-11-09.
- [x] T030 Ejecutar TalkBack físico para encabezado, porcentaje/nivel, aviso, módulos/acciones, error y Repetir; resultado satisfactorio confirmado por el responsable el 2026-11-09.
- [x] T031 Ejecutar protocolo con5 participantes40–65 para interpretar porcentaje/nivel/aviso y localizar una acción; 5/5 satisfactorios confirmados por el responsable, solo conteo agregado, 2026-11-09.
- [x] T032 Consolidar RF/CA/SC→T001–T031→pruebas/resultados, limitaciones y frontera F08 en `specs/007-resultados-repeticion/validation/traceability.md` y `delivery-review.md`.
- [x] T033 Actualizar `specs/README.md`, registrar aceptación explícita del responsable mediante «sí, todo está bien, confirmo» y confirmación de pruebas, hacer commit y sincronizar `work` (2026-11-09).

## Dependencies & Execution Order

```text
T001–T004 setup
      ↓
T005–T010 pruebas/contratos
      ↓
T011–T017 dominio, catálogo y estado
      ↓
T018–T024 P09, navegación e integración
      ↓
T025–T033 validación y aceptación
```

T004 puede avanzar junto con T003. T005–T010 son paralelas después del asset/fixture.
T011 y T012 son paralelas; T013 depende de T011 y T014 de T012. P09 depende de
T013–T017. Las tareas de entrega comienzan al completar el checkpoint HU-07.

## Parallel Example: HU-07

```text
T011 ResultAssessment/ModuleAssessment  || T012 puerto/catálogo
T005 contrato entrada                  || T006 fórmula/fronteras
T007 prioridad/empates                 || T008 repositorio editorial
T009 navegación/lifecycle              || T010 P09/accesibilidad
```

## Implementation Strategy

1. Congelar baseline y asset editorial sin dependencias nuevas.
2. Escribir y observar fallar los contratos T005–T010.
3. Entregar cálculo puro y catálogo antes del estado/UI.
4. Integrar P09 y Repetir conservando el único `TemporaryJourney` F06.
5. Ejecutar privacidad, regresión, Android, accesibilidad y comprensión.
6. Cerrar únicamente con aprobación explícita y repositorio sincronizado.
