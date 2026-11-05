# Tasks: F06 — Cuestionario temporal

**Input:** artefactos aprobados de `specs/006-cuestionario-temporal/`.  
**Estado:** propuesta de tareas; ninguna está ejecutada ni autorizada.  
**Historia:** HU-06 (P1), RF-10/11/15, CA-06.1–5.

Todas las pruebas usan cuenta, respuestas, semillas y conectividad sintéticas. Una
casilla se marca únicamente con evidencia; un commit no equivale a aprobación.

## Phase 1: Setup — contenido y entorno

**Purpose:** fijar el baseline, contenido aprobado y única dependencia nueva.

- [ ] T001 Registrar aprobación de spec/banco/plan y estado F05 pendiente en `specs/006-cuestionario-temporal/spec.md`, `plan.md` y `specs/README.md`.
- [ ] T002 Ejecutar baseline sin modificar pins: análisis,199 pruebas Flutter,17 Functions,18 reglas y APK; registrar resultados reales en `specs/006-cuestionario-temporal/validation/baseline.md`.
- [ ] T003 Resolver y fijar `connectivity_plus 7.3.2` con Flutter3.47.8/Dart3.13.7 en `mobile/pubspec.yaml` y `mobile/pubspec.lock`, sin actualizar otras dependencias por conveniencia.
- [ ] T004 Convertir literalmente las30 preguntas aprobadas a `mobile/assets/content/questionnaire-1.0.0.json` con esquema1, IDs Q001–Q030,7 temas,3 opciones, claves, explicaciones, recomendaciones, fuentes, revisión y estado approved.
- [ ] T005 [P] Crear fixture inválido/válido, semillas deterministas y conectividad controlada en `mobile/test/features/questionnaire/questionnaire_test_fixtures.dart`, sin archivos ni red.

**Checkpoint:** contenido y entorno preparados; aún no existe intento ejecutable.

---

## Phase 2: Foundational — contratos y pruebas primero

**Purpose:** escribir pruebas fallidas de reglas compartidas antes de implementar HU-06.

- [ ] T006 [P] Probar esquema exacto,30 IDs únicos,7 temas,3 opciones A/B/C, clave perteneciente, estado/revisión y rechazo atómico en `mobile/test/features/questionnaire/question_bank_test.dart`.
- [ ] T007 [P] Probar selección de10 IDs únicos,7 temas, máximo2 por tema, múltiples semillas y clave intacta tras mezclar en `mobile/test/features/questionnaire/question_selector_test.dart`.
- [ ] T008 [P] Probar fases, selección única, bloqueo sin respuesta, revisión, finalización y generaciones tardías en `mobile/test/features/questionnaire/questionnaire_controller_test.dart`.
- [ ] T009 [P] Probar pausa/reanudación con mismo orden y descarte por background/logout/cambio UID/dispose sin restauración en `mobile/test/features/questionnaire/questionnaire_lifecycle_test.dart`.
- [ ] T010 [P] Probar acceso y navegación: visitante/no verificado bloqueados antes de leer asset, sesión válida P08, salida cancelada/confirmada y `/results` solo tras completar en `mobile/test/features/questionnaire/questionnaire_navigation_test.dart`.
- [ ] T011 [P] Probar P08 inicial/carga/activa/pausa/error,320×720/412×915, texto100/200%,48dp, semántica, foco y contraste en `mobile/test/features/questionnaire/questionnaire_screen_test.dart`.

**Checkpoint:** contratos de contenido, intento, lifecycle, acceso y P08 fallan por ausencia de implementación.

---

## Phase 3: HU-06 — Responder cuestionario (Priority: P1) 🎯 MVP

**Goal:** completar diez situaciones en RAM, revisarlas y entregar un snapshot temporal a F07.

**Independent Test:** sesión sintética → aviso → diez preguntas distintas → selección
única y revisión → pausa/reanudación → finalización; luego comprobar descartes sin
storage, Firestore, IA o logs.

### Domain and content

- [ ] T012 [P] [US1] Implementar `Question`, `QuestionOption`, `QuestionTopic` y validaciones literales —Q001–Q030, version1, temas cerrados, exactamente3 opciones A/B/C y clave perteneciente— en `mobile/lib/features/questionnaire/domain/question.dart`.
- [ ] T013 [P] [US1] Implementar `QuestionBank`, `AttemptQuestion`, `ActiveAttempt` y `CompletedAttempt` inmutables/no serializables en `mobile/lib/features/questionnaire/domain/question_bank.dart`.
- [ ] T014 [P] [US1] Definir errores seguros y puerto de lectura sin escritura en `mobile/lib/features/questionnaire/data/question_bank_repository.dart`.
- [ ] T015 [US1] Implementar validación atómica y caché solo RAM del asset en `mobile/lib/features/questionnaire/data/bundled_question_bank_repository.dart`; asset inválido/incompleto nunca produce intento parcial.
- [ ] T016 [US1] Implementar selector Fisher–Yates con fuente aleatoria inyectable, una pregunta por tema y segunda pregunta de tres temas distintos en `mobile/lib/features/questionnaire/domain/question_selector.dart`.

### State, connectivity and lifecycle

- [ ] T017 [P] [US1] Definir puerto `available/unavailable` sin contenido, UID ni telemetría en `mobile/lib/features/questionnaire/application/questionnaire_connectivity.dart`.
- [ ] T018 [US1] Implementar adaptador `connectivity_plus` que trate `none` como unavailable y no haga sondeos remotos en `mobile/lib/features/questionnaire/data/platform_questionnaire_connectivity.dart`.
- [ ] T019 [US1] Implementar `QuestionnaireController` como `TemporaryJourney`: fases idle/loading/active/paused/error/completed, una selección por pregunta, revisión, generación y snapshot RAM en `mobile/lib/features/questionnaire/application/questionnaire_controller.dart`.
- [ ] T020 [US1] Integrar pausa de primer plano y descarte para exit/background/session/dispose, limpiando intento y snapshot sin cerrar sesión, en `mobile/lib/features/questionnaire/application/questionnaire_controller.dart`.

### P08 and application integration

- [ ] T021 [US1] Implementar P08 según PDF7 y decisiones aprobadas en `mobile/lib/features/questionnaire/presentation/questionnaire_screen.dart`: aviso/Comenzar, progreso,3 opciones, Continuar/Ver resultado, revisión, pausa y errores; sin mostrar claves.
- [ ] T022 [US1] Integrar asset, repositorio, conectividad y controlador persistente de proceso en `mobile/lib/main.dart` y `mobile/lib/app/priva_app.dart`, sin restoration ni serialización.
- [ ] T023 [US1] Resolver `/questionnaire` tras guardas y conservar builders F01–F05 en `mobile/lib/app/account_router.dart`; usar el controlador real como `TemporaryJourney` de F03.
- [ ] T024 [US1] Conectar finalización a `/results` únicamente con `JourneyPhase.result`, mantener snapshot RAM para F07 y mostrar placeholder protegido vigente sin calcular resultado en `mobile/lib/features/navigation/application/navigation_controller.dart` y `mobile/lib/app/account_router.dart`.
- [ ] T025 [US1] Completar reintento de asset, doble toque, eventos tardíos, mensajes seguros y semántica/foco de pausa/error en P08 y controlador, sin imprimir preguntas, selecciones o excepciones.
- [ ] T026 [US1] Añadir recorrido Android sintético en `mobile/integration_test/questionnaire_test.dart`, reutilizando dobles sin Firebase/IA/cuentas personales.

**Checkpoint:** HU-06 funciona localmente de extremo a extremo; F07 sigue sin implementar cálculo/presentación.

---

## Phase 4: Polish, privacidad y entrega

- [ ] T027 Ejecutar análisis, suite Flutter completa, Functions, reglas y build APK; registrar comandos/recuentos/fallos en `specs/006-cuestionario-temporal/validation/technical-results.md`.
- [ ] T028 Verificar igualdad literal banco↔asset, fuentes, claves y SHA-256 en `mobile/test/features/questionnaire/question_bank_editorial_test.dart` y `specs/006-cuestionario-temporal/validation/editorial-review.md`.
- [ ] T029 Auditar código, almacenamiento, Firestore, tráfico, APK y logs con respuestas sintéticas; acreditar cero selecciones/snapshot en persistencia o IA en `specs/006-cuestionario-temporal/validation/privacy-security.md`.
- [ ] T030 Ejecutar20 ciclos de inicio/selección/doble toque/pausa/error/reintento con feedback≤1s y resolución≤15s en `mobile/integration_test/questionnaire_performance_test.dart`; conservar solo agregados en `validation/performance.md`.
- [ ] T031 Validar API24/API36,320×720/412×915,texto100/200%, teclado, atrás, red, background y logout en `specs/006-cuestionario-temporal/validation/android-matrix.md`.
- [ ] T032 Ejecutar TalkBack físico para aviso/progreso/grupo/selección/Continuar/pausa/error/salida en `specs/006-cuestionario-temporal/validation/accessibility.md`.
- [ ] T033 Ejecutar protocolo con5 participantes40–65 para inicio, selección, revisión, temporalidad y pausa; guardar solo conteos agregados en `specs/006-cuestionario-temporal/validation/comprehension.md`.
- [ ] T034 Consolidar RF/CA/SC→T001–T033→pruebas/resultados, limitaciones y frontera F07 en `specs/006-cuestionario-temporal/validation/traceability.md` y `delivery-review.md`.
- [ ] T035 Actualizar `specs/README.md`, solicitar aceptación explícita, hacer commit y sincronizar `work`; no cerrar F06 ni avanzar F07 con pendientes no aceptados.

## Dependencies & Execution Order

```text
T001–T005 setup
      ↓
T006–T011 pruebas/contratos
      ↓
T012–T020 dominio, contenido, estado y lifecycle
      ↓
T021–T026 P08 e integración
      ↓
T027–T035 validación y aceptación
```

T005 puede avanzar junto con T003/T004. T006–T011 son paralelas después del asset y
fixtures. T012–T014/T017 son paralelas; T015 depende de T012–T014, T016 de T012–T013,
T018 de T017, y T019–T020 de T013–T18. P08 depende del controlador. F07 no bloquea
la prueba independiente: `/results` conserva placeholder protegido y snapshot RAM.

## Parallel Example: HU-06

```text
T012 modelos Question/Option/Topic
T013 modelos Bank/Attempt/Snapshot
T014 puerto y errores de repositorio
T017 puerto de conectividad
```

## Implementation Strategy

El MVP es HU-06 completa porque existe una sola historia. Secuencia: contenido y
contratos → pruebas fallidas → dominio/selector → estado/lifecycle → P08/integración →
auditoría y matriz. No implementar fórmula, nivel, recomendaciones de resultado ni
repetición de F07. No marcar pruebas Android/humanas como aprobadas si se omiten.

## Format Validation

Total:35 tareas. HU-06:15 tareas `[US1]` (T012–T026). Setup/fundamento:11.
Validación/cierre:9. Todas tienen checkbox, ID, etiqueta cuando aplica y ruta concreta.
