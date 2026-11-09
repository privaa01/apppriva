# Tasks: F08 — Lectura accesible y recuperación de conexión

**Input**: Design documents from `/specs/008-accesibilidad-conexion/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: F08 exige pruebas automatizadas y aceptación manual de accesibilidad,
compatibilidad, desconexión y privacidad.

**Organization**: El spec contiene una historia P1, HU-08. Las tareas de esa historia
se ordenan para entregar primero la preferencia de lectura y luego la recuperación
de red, pero se validan juntas mediante CA-08.1–CA-08.3.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: preparar dependencias y puntos de extensión sin cambiar comportamiento.

- [x] T001 Declarar `shared_preferences` como dependencia directa y resolver el lockfile en `mobile/pubspec.yaml` y `mobile/pubspec.lock`
- [x] T002 Crear las carpetas de F08 para accesibilidad y conectividad bajo `mobile/lib/features/accessibility/`, `mobile/lib/features/connectivity/`, `mobile/test/features/accessibility/` y `mobile/test/features/connectivity/`
- [x] T003 [P] Registrar la matriz RF/CA/RNF inicial y espacios para evidencia en `specs/008-accesibilidad-conexion/traceability.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: definir modelos cerrados e interfaces sustituibles para pruebas.

**⚠️ CRITICAL**: HU-08 no comienza hasta completar esta fase.

- [x] T004 [P] Crear `TextScalePreset` con exactamente small=0.90, normal=1.00, large=1.25 y extraLarge=1.50, etiquetas Pequeño/Normal/Grande/Muy grande y fallback Normal en `mobile/lib/features/accessibility/application/text_scale_preset.dart`
- [x] T005 [P] Definir el contrato `TextScalePreferences` sin UID, correo, nombre, respuesta, resultado ni marca temporal en `mobile/lib/features/accessibility/data/text_scale_preferences.dart`
- [x] T006 [P] Definir el contrato de señal de red y estado available/initialized/retrying sin cola persistente en `mobile/lib/features/connectivity/application/connectivity_source.dart` y `mobile/lib/features/connectivity/application/connectivity_state.dart`
- [x] T007 Implementar dobles en memoria para preferencia y conectividad en `mobile/test/features/accessibility/text_scale_test_fixtures.dart` y `mobile/test/features/connectivity/connectivity_test_fixtures.dart`

**Checkpoint**: modelos e interfaces listos, sin datos personales ni persistencia del cuestionario.

---

## Phase 3: User Story 1 — Personalizar lectura y recuperar conexión (Priority: P1) 🎯 MVP

**Goal**: seleccionar y recordar uno de cuatro tamaños en todo Priva, mantener operable
el contenido al 150 %, y recuperar manualmente operaciones remotas sin duplicarlas;
Tips y Zyro continúan funcionando sin red.

**Independent Test**: desde Perfil seleccionar 150 %, recorrer las pantallas, cerrar
sesión y reiniciar conservando la escala; activar modo avión durante una operación
remota, observar el aviso, recuperar red y pulsar dos veces “Reintentar”, obteniendo
una sola ejecución; abrir Tips y Zyro durante modo avión.

### Tests for User Story 1

> Escribir y observar fallar estas pruebas antes de la implementación correspondiente.

- [x] T008 [P] [US1] Probar los cuatro factores, etiquetas, fallback Normal y ausencia de escritura duplicada en `mobile/test/features/accessibility/text_scale_controller_test.dart`
- [x] T009 [P] [US1] Probar carga/guardado de la única clave `priva.text_scale`, valor desconocido y fallo seguro en `mobile/test/features/accessibility/shared_preferences_text_scale_test.dart`
- [x] T010 [P] [US1] Probar que Perfil anuncia cuatro opciones, cambia la escala sin guardar el nombre y conserva operabilidad al 150 % en `mobile/test/features/profile/profile_text_scale_test.dart`
- [x] T011 [P] [US1] Probar inicialización global, persistencia después de cierre de sesión y aplicación transversal de `TextScaler` en `mobile/test/app/priva_app_accessibility_test.dart`
- [x] T012 [P] [US1] Probar none/available, recuperación sin ejecución automática, doble toque y una operación a la vez en `mobile/test/features/connectivity/connectivity_controller_test.dart`
- [x] T013 [P] [US1] Probar textos, región viva y estados deshabilitados/intentando del aviso en `mobile/test/features/connectivity/connectivity_notice_test.dart`
- [x] T014 [P] [US1] Probar sin red que Tips y Zyro local funcionan y que F06 conserva pausa en RAM/descarte en segundo plano en `mobile/test/app/offline_scope_test.dart`

### Implementation for User Story 1

- [x] T015 [US1] Implementar carga/guardado con fallback Normal y clave única `priva.text_scale` en `mobile/lib/features/accessibility/data/shared_preferences_text_scale.dart`
- [x] T016 [US1] Implementar cambio visual inmediato, guardado serializado y error comprensible en `mobile/lib/features/accessibility/application/text_scale_controller.dart`
- [x] T017 [US1] Inicializar la preferencia antes del contenido útil, aplicar `TextScaler.linear` global y conservar el builder existente en `mobile/lib/main.dart` y `mobile/lib/app/priva_app.dart`
- [x] T018 [US1] Inyectar el controlador de escala hasta Perfil en `mobile/lib/app/account_router.dart` y `mobile/lib/features/profile/presentation/profile_screen.dart`
- [x] T019 [US1] Añadir en Perfil el selector accesible “Tamaño del texto” con ayuda y cuatro opciones exclusivas en `mobile/lib/features/profile/presentation/profile_screen.dart`
- [x] T020 [US1] Implementar una fuente compartida basada en `connectivity_plus` que trate `none` como no disponible y no afirme acceso real en `mobile/lib/features/connectivity/data/platform_connectivity_source.dart`
- [x] T021 [US1] Implementar inicialización, recuperación sin autoenvío y exclusión de doble reintento en `mobile/lib/features/connectivity/application/connectivity_controller.dart`
- [x] T022 [US1] Implementar el aviso accesible “No hay conexión. Revisa Internet y vuelve a intentarlo.” y la acción manual en `mobile/lib/features/connectivity/presentation/connectivity_notice.dart`
- [x] T023 [US1] Integrar el controlador compartido en la raíz y adaptar F06 sin cambiar su pausa/descarte ni copiar respuestas en `mobile/lib/app/priva_app.dart` y `mobile/lib/features/questionnaire/data/platform_questionnaire_connectivity.dart`
- [x] T024 [US1] Integrar el aviso y callback único en operaciones remotas de Cuenta y Perfil, manteniendo Tips/Zyro fuera del bloqueo, en `mobile/lib/features/account/` y `mobile/lib/features/profile/`
- [x] T025 [US1] Corregir cualquier desbordamiento al 90/100/125/150 % mediante scroll/flexibilidad sin ocultar acciones en los archivos afectados de `mobile/lib/features/`
- [x] T026 [US1] Verificar y ajustar colores/etiquetas para 4.5:1 en texto normal y 3:1 en texto grande/controles sin depender solo del color en `mobile/lib/app/priva_app.dart` y widgets F08 afectados

**Checkpoint**: CA-08.1, CA-08.2 y CA-08.3 son demostrables de forma independiente con datos sintéticos.

---

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: validación completa, rendimiento y evidencia de cierre.

- [x] T027 [P] Ejecutar `dart format --output=none --set-exit-if-changed .`, `flutter analyze` y `flutter test` desde `mobile/`, registrando resultados en `specs/008-accesibilidad-conexion/traceability.md`
- [x] T028 [P] Auditar almacenamiento y ciclo de vida para confirmar que solo persiste `priva.text_scale` y nunca respuestas/resultados en `specs/008-accesibilidad-conexion/traceability.md`
- [x] T029 Ejecutar `quickstart.md` en API24/API36 y 320×720/412×915 con 90/100/125/150 %, TalkBack, teclado y modo avión, registrando versión, resultado, defectos y repruebas en `specs/008-accesibilidad-conexion/traceability.md`
- [x] T030 Medir cambio de escala ≤300 ms, aviso de red ≤2 s y objetivo de 60 fps en recorridos F08, documentando método y resultados en `specs/008-accesibilidad-conexion/traceability.md`
- [x] T031 Completar la matriz requisito → historia → criterio → tarea → prueba → resultado y marcar únicamente evidencia ejecutada en `specs/008-accesibilidad-conexion/traceability.md` y `specs/008-accesibilidad-conexion/tasks.md`
- [x] T032 Obtener aceptación explícita del responsable, actualizar `specs/008-accesibilidad-conexion/checklists/requirements.md`, registrar commit/sincronización y cerrar F08 en `specs/README.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: inicia inmediatamente.
- **Foundational (Phase 2)**: depende de T001–T002; bloquea HU-08.
- **HU-08 (Phase 3)**: T008–T014 se escriben primero; T015–T026 implementan hasta que pasen.
- **Polish (Phase 4)**: depende de HU-08 completa; T032 es el último paso.

### User Story Dependencies

- **US1 (P1)**: única historia; depende solo de la base F08 y conserva las reglas ya
  cerradas de F01–F07.

### Within US1

1. Pruebas T008–T014 antes de sus implementaciones.
2. Preferencia/controlador T015–T016 antes de raíz/Perfil T017–T019.
3. Fuente/controlador T020–T021 antes de aviso/integraciones T022–T024.
4. Ajustes transversales T025–T026 después de integrar.

### Parallel Opportunities

- T003, T004, T005 y T006 afectan artefactos distintos.
- T008–T014 son archivos de prueba independientes.
- T027 y T028 pueden comenzar en paralelo una vez completa US1.

---

## Parallel Example: User Story 1

```text
T008: pruebas del controlador de escala
T010: pruebas del selector en Perfil
T012: pruebas del controlador de conectividad
T013: pruebas del aviso accesible
T014: pruebas del alcance local sin red
```

---

## Implementation Strategy

### MVP First

1. Completar Setup y Foundational.
2. Implementar T008–T019: tamaño global persistente y Perfil.
3. Validar CA-08.1 y CA-08.2 antes de integrar red.
4. Implementar T012–T026: aviso y reintento manual.
5. Validar CA-08.3 y regresiones F01–F07.

### Incremental Delivery

1. Preferencia local cerrada y probada.
2. Aplicación global y selector de Perfil.
3. Señal de red compartida y aviso reutilizable.
4. Integración remota sin bloquear Tips/Zyro.
5. Matriz manual, rendimiento, trazabilidad y aceptación.

## Notes

- `[P]` indica archivos distintos y ausencia de dependencia incompleta.
- Todas las pruebas usan datos sintéticos.
- No marcar una tarea como completada sin evidencia proporcional.
- No hacer commit ni sincronizar hasta que el usuario lo solicite o T032 quede autorizado.
