# Tasks: F07 — Resultados orientativos y repetición

**Input:** artefactos aprobados de `specs/007-resultados-repeticion/`.
**Estado:** plan aprobado el 2026-11-07; tareas propuestas, pendientes de aprobación.
**Historia:** HU-07 (P1), RF-12–15, CA-07.1–5.

Todas las pruebas usan intentos, sesiones y porcentajes sintéticos. Una casilla se
marca únicamente con evidencia; commit, prueba o plan no equivalen a aprobación.

## Phase 1: Setup — baseline y contenido

**Purpose:** fijar el estado previo y transformar el catálogo aprobado sin cambiar dependencias.

- [ ] T001 Registrar aprobación de spec, catálogo y plan, además del estado F06 cerrado/F05 pendiente, en `specs/007-resultados-repeticion/spec.md`, `plan.md`, `tasks.md` y `specs/README.md`.
- [ ] T002 Ejecutar baseline de análisis, suite Flutter, Functions, reglas y APK Android sin modificar pins; registrar comandos y recuentos en `specs/007-resultados-repeticion/validation/baseline.md`.
- [ ] T003 Convertir literalmente los cinco módulos y tres acciones aprobadas a `mobile/assets/content/result-recommendations-1.0.0.json`, con esquema1, versión, estado y revisión, y declararlo en `mobile/pubspec.yaml`.
- [ ] T004 [P] Crear fixtures de intentos completos/parciales, sumas frontera, empates, catálogo válido/inválido y sesiones sintéticas en `mobile/test/features/questionnaire/result_test_fixtures.dart`.

**Checkpoint:** baseline y contenido preparados; todavía no se calcula ni muestra un resultado.

---

## Phase 2: Foundational — contratos y pruebas primero

**Purpose:** fijar mediante pruebas fallidas la fórmula, privacidad y acceso antes de implementar HU-07.

- [ ] T005 [P] Probar entrada exacta de diez selecciones, option IDs pertenecientes y rechazo de parcial/módulos inválidos en `mobile/test/features/questionnaire/result_assessment_test.dart`.
- [ ] T006 [P] Probar suma/promedio y fronteras 0,19,19.5,20,59,59.5,60,100 sin redondeo previo en `mobile/test/features/questionnaire/result_calculator_test.dart`.
- [ ] T007 [P] Probar dos respuestas por módulo, top3 descendente y desempate passwords/access/networks/phishing/devices en `mobile/test/features/questionnaire/result_priority_test.dart`.
- [ ] T008 [P] Probar esquema exacto, cinco módulos, tres acciones literales, caché RAM y rechazo atómico en `mobile/test/features/questionnaire/result_recommendation_repository_test.dart`.
- [ ] T009 [P] Probar guarda de visitante/no verificado/sin snapshot, acceso válido, descarte por salida/background/logout/cambio UID/dispose y eventos tardíos en `mobile/test/features/questionnaire/result_navigation_test.dart`.
- [ ] T010 [P] Probar P09 loading/ready/error/restarting, porcentaje/nivel/aviso/top3, 320×720/412×915, texto100/200%, semántica, foco,48dp y contraste en `mobile/test/features/questionnaire/result_screen_test.dart`.

**Checkpoint:** las reglas aprobadas tienen oráculos independientes y fallan hasta existir la implementación.

---

## Phase 3: HU-07 — Comprender el resultado y repetir (Priority: P1) 🎯 MVP

**Goal:** transformar diez selecciones temporales en orientación comprensible, mostrar P09 y repetir sin conservar historial.

**Independent Test:** intento sintético completo → promedio/nivel/top3 exactos → P09
orientativa → doble toque Repetir produce un solo intento nuevo; abandonar impide
restaurar resultado y no deja almacenamiento, red o logs.

### Dominio y contenido

- [ ] T011 [P] [US1] Implementar `ResultLevel`, `ResultAssessment` y `ModuleAssessment` inmutables/no serializables con total0–1000, tres prioridades y generación en `mobile/lib/features/questionnaire/domain/result_assessment.dart`.
- [ ] T012 [P] [US1] Definir `ResultRecommendationCatalog`, errores seguros y puerto de solo lectura sin escritura en `mobile/lib/features/questionnaire/data/result_recommendation_repository.dart`.
- [ ] T013 [US1] Implementar cálculo puro por suma entera, formato entero/décima, niveles `<200`/`<600`/resto y top3 estable en `mobile/lib/features/questionnaire/domain/result_calculator.dart`.
- [ ] T014 [US1] Implementar validación atómica y caché únicamente RAM del asset editorial en `mobile/lib/features/questionnaire/data/bundled_result_recommendation_repository.dart`.

### Estado, repetición y ciclo de vida

- [ ] T015 [US1] Extender `QuestionnaireController` para exponer el snapshot completo solo durante `JourneyPhase.result` y coordinar una única repetición por generación en `mobile/lib/features/questionnaire/application/questionnaire_controller.dart`.
- [ ] T016 [US1] Implementar `ResultController` con estados loading/ready/error/restarting, cálculo una vez por generación, reintento editorial y rechazo de eventos tardíos en `mobile/lib/features/questionnaire/application/result_controller.dart`.
- [ ] T017 [US1] Integrar descarte total en exit/background/session/dispose y asegurar que repetir elimina primero el resultado sin cerrar sesión en `mobile/lib/features/questionnaire/application/result_controller.dart` y `questionnaire_controller.dart`.

### P09 e integración de aplicación

- [ ] T018 [US1] Implementar P09 en `mobile/lib/features/questionnaire/presentation/result_screen.dart` con Resultado orientativo, porcentaje, nivel textual, explicación, aviso literal, tres módulos×tres acciones, error/reintento y Repetir; sin selecciones ni garantías.
- [ ] T019 [US1] Añadir semántica, encabezados, orden de foco, scroll, objetivos≥48dp y presentación independiente del color en `mobile/lib/features/questionnaire/presentation/result_screen.dart`.
- [ ] T020 [US1] Componer asset/repositorio/controlador de resultado junto al controlador F06 sin almacenamiento en `mobile/lib/app/priva_app.dart`.
- [ ] T021 [US1] Resolver `/results` con guarda y snapshot real, preservando builders F01–F06, en `mobile/lib/app/account_router.dart`.
- [ ] T022 [US1] Implementar Repetir como descarte→inicio único→P08, manejar doble toque/fallo y evitar restauración mediante `mobile/lib/features/navigation/application/navigation_controller.dart` y `result_screen.dart`.
- [ ] T023 [US1] Actualizar disponibilidad de `/questionnaire` y `/results` sin alterar permisos en `mobile/lib/features/navigation/data/destination_catalog.dart` y sus pruebas.
- [ ] T024 [US1] Añadir recorrido Android sintético de cálculo, visualización, repetición y descarte en `mobile/integration_test/result_test.dart`, sin Firebase/IA/cuentas personales.

**Checkpoint:** HU-07 funciona extremo a extremo; no existe historial ni dependencia remota.

---

## Phase 4: Polish, privacidad y entrega

- [ ] T025 Ejecutar análisis, suite Flutter completa, Functions, reglas y build APK; registrar comandos/recuentos/fallos en `specs/007-resultados-repeticion/validation/technical-results.md`.
- [ ] T026 Verificar igualdad literal catálogo↔asset, versión, fuente y SHA-256 en `mobile/test/features/questionnaire/result_editorial_test.dart` y `specs/007-resultados-repeticion/validation/editorial-review.md`.
- [ ] T027 Auditar código, storage, Firestore, tráfico, APK y logs con datos sintéticos; acreditar cero respuestas/resultados/derivados persistidos o enviados en `specs/007-resultados-repeticion/validation/privacy-security.md`.
- [ ] T028 Ejecutar20 ciclos de cálculo/catálogo/doble repetición/error/reintento con feedback≤1s y resolución≤15s en `mobile/integration_test/result_performance_test.dart`; conservar solo agregados en `validation/performance.md`.
- [ ] T029 Validar API24/API36,320×720/412×915,texto100/200%, teclado, atrás, red, background y logout en `specs/007-resultados-repeticion/validation/android-matrix.md`.
- [ ] T030 Ejecutar TalkBack físico para encabezado, porcentaje/nivel, aviso, módulos/acciones, error y Repetir en `specs/007-resultados-repeticion/validation/accessibility.md`.
- [ ] T031 Ejecutar protocolo con5 participantes40–65 para interpretar porcentaje/nivel/aviso y localizar una acción; guardar solo conteos agregados en `specs/007-resultados-repeticion/validation/comprehension.md`.
- [ ] T032 Consolidar RF/CA/SC→T001–T031→pruebas/resultados, limitaciones y frontera F08 en `specs/007-resultados-repeticion/validation/traceability.md` y `delivery-review.md`.
- [ ] T033 Actualizar `specs/README.md`, solicitar aceptación explícita, hacer commit y sincronizar `work`; no cerrar F07 ni avanzar F08 con pendientes no aceptados.

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
