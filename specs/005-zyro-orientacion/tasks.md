# Tasks: F05 — Orientación confiable mediante Zyro

**Input**: artefactos aprobados de `specs/005-zyro-orientacion/`.
**Estado**: propuesta de tareas; ninguna está ejecutada ni autorizada.
**Historia**: HU-05 (P1), RF-07–09, CA-05.1–12, SC-05.1–6.

Todas las pruebas usan cuentas/mensajes sintéticos. Cada tarea se marca solo con
evidencia; una omisión no equivale a aprobación.

**Ejecución 2026-11-05:** T001 y T002 se intentaron después de aprobar las tareas,
pero todas las fuentes oficiales devolvieron HTTP403 por la política de red. Se
registró evidencia en `guide-catalogue.md` y `provider-review.md`. Ambas siguen
pendientes y bloquean T003–T045; no se inició código ni se marcó una tarea completa.
El intento de guardar dominios en el entorno falló por borrador obsoleto; la
transferencia exacta quedó en `network-access-request.md`.

**Reanudación 2026-11-05:** rama local `work` limpia al iniciar en `05db3fb`.
Se intentó `git fetch origin` dos veces; ambos intentos fallaron al conectar con
`proxy:8080`, por lo que no se puede afirmar sincronización remota. En el entorno
nuevo los dominios solicitados sí aparecen permitidos, pero las cinco URLs de
T001 fallaron con curl7/HTTP000 por indisponibilidad del proxy. Véase el reintento
en `guide-catalogue.md`. T001 permanece pendiente y no se inicia implementación.

**Aprobación documental 2026-11-05:** el usuario aportó y aprobó expresamente el
PDF de guías. Se conservó en `docs/referencias/` y se registraron aprobación,
fuente y enlaces en `guide-catalogue.md`. La aprobación editorial está resuelta;
T001 sigue pendiente de contraste operativo, sin declarar pruebas no ejecutadas.

**Continuación autorizada 2026-11-05:** se retomó T002 y se consultaron fuentes
oficiales mediante navegación. `provider-review.md` contiene hallazgos, propuesta
concreta y preparación de inventario T003. Faltan decisiones/configuración real;
T002/T003 no se marcan completas ni se inicia implementación. El proyecto público
`priva-785cb` se identificó inicialmente en el cliente.

**Confirmación de proyecto 2026-11-05:** el usuario autorizó `priva-785cb` como
proyecto Firebase de pruebas para Zyro y se identificó como responsable de la
facturación. Esta confirmación quedó registrada en `provider-review.md`; no activa
facturación, APIs ni consumo y no completa por sí sola T002 o T004.

**Aprobación de configuración 2026-11-05:** el usuario aprobó modelo rápido y
económico, región estadounidense, Logging sanitizado por 7 días y cuota 10/10min
con TTL≤24h. Se fijó `gemini-3.5-flash-lite` en `us-central1` según documentación
vigente y se completaron T002/T003. T004 sigue pendiente de consola. El intento de
T006 quedó bloqueado por ausencia de Flutter/Android/Firebase CLI y caché npm
incompleta; evidencia en `validation/baseline.md`.

**Cierre T001 2026-11-05:** el responsable confirmó «según la T1 y T2 ya están
finalizadas». Se acepta el PDF aportado como fuente vigente y T001 queda completa
con limitación explícita: Codex no ejecutó rutas Android/web ni contrastó menús con
cuentas sintéticas por fallos del proxy. No se inventa esa evidencia.

**Cambio de orden aprobado 2026-11-05:** el responsable respondió «okey» a mover
T004 inmediatamente antes de T043. T005–T042 pueden ejecutarse localmente con
emuladores, adaptador Vertex falso y datos sintéticos. T004 continúa obligatoria y
bloquea toda llamada real, despliegue hospedado y consumo de Vertex.

## Phase 1: Setup — puertas previas

**Purpose**: cerrar decisiones externas y preparar entorno. T001–T006 bloquean todo
trabajo de implementación.

- [x] T001 Contrastar manualmente las cinco URLs oficiales, rutas Android/web y consecuencias de Instagram/Facebook/Google; completada por aprobación del PDF fuente y aceptación expresa del responsable, con contraste independiente no ejecutado documentado en `specs/005-zyro-orientacion/guide-catalogue.md`.
- [x] T002 Completar y aprobar modelo/endpoint/región, transferencia desde Colombia, entrenamiento, retención, eliminación, términos, responsable, facturación y Logging en `specs/005-zyro-orientacion/provider-review.md`; adjuntar evidencia verificable y no asumir retención cero.
- [x] T003 Aprobar finalidad y TTL≤24h de `zyro_rate_limits/{uid}`, incorporar el contador al inventario/política y registrar decisión en `specs/005-zyro-orientacion/provider-review.md`.
- [ ] T004 Verificar proyecto Firebase de pruebas, plan con facturación, APIs, IAM mínimo, región común, Play Integrity/App Check y cuenta de servicio sin imprimir credenciales; registrar solo estado/configuración no secreta en `specs/005-zyro-orientacion/validation/environment.md`.
- [x] T005 Resolver sin actualizar pins por conveniencia `cloud_functions 7.0.1`, `firebase_app_check 0.5.1`, `firebase-functions 7.4.0`, `firebase-admin 14.5.0` y `@google/genai 2.32.0`; versiones resueltas desde pub/npm y registradas en `specs/005-zyro-orientacion/validation/environment.md`.
- [x] T006 Ejecutar baseline de análisis,180 pruebas Flutter vigentes, reglas Firebase y build Android disponible;180/180,0 diagnósticos,17/17 reglas y APK debug satisfactorios en `specs/005-zyro-orientacion/validation/baseline.md`.

**Checkpoint**: T001–T003 aprobadas. T004 se reubica como puerta de T043; hasta
cerrarla solo se permiten emuladores/dobles, nunca Vertex o despliegue real.

---

## Phase 2: Foundational — contratos, seguridad y pruebas base

**Purpose**: crear infraestructura compartida antes de HU-05.

- [x] T007 Inicializar Functions Node22/TypeScript y dependencias fijadas en `firebase/functions/package.json`, `firebase/functions/tsconfig.json` y `firebase.json`, compilación TypeScript satisfactoria y sin secretos.
- [x] T008 [P] Convertir únicamente guías aprobadas a `firebase/functions/src/zyro/guides.v1.json`, con plataforma/acción/superficie/revisión/estado/pasos/consecuencias/fuente y solo estado `vigente` servible; doce guías transcritas del PDF aportado para Instagram, Facebook y Google.
- [x] T009 [P] Definir tipos y validación exacta de request/response, guía y decisión en `firebase/functions/src/zyro/contracts.ts`: mensaje≤1000, contexto≤8/6000, pasos0–6, schemaVersion1 y rechazo de campos extra.
- [x] T010 [P] Crear fixtures sintéticos y adaptador Vertex falso en `firebase/functions/test/zyro/fixtures.ts` y `firebase/functions/test/zyro/fake_vertex.ts`, sin red ni mensajes reales; usados por pruebas de router y salida hostil.
- [x] T011 [P] Crear fixtures/control de Futures y repositorio falso móvil en `mobile/test/features/zyro/zyro_test_fixtures.dart`, incluyendo tres estados de cuenta y respuestas tardías; usados por controlador, P07 y navegación.
- [x] T012 Añadir dependencias móviles fijadas y configuración de test en `mobile/pubspec.yaml` y `mobile/pubspec.lock`, conservando Firebase actual y sin añadir `firebase_ai`; lockfile resuelto.
- [x] T013 Preparar reglas y pruebas que denieguen todo acceso cliente a `zyro_rate_limits` en `firebase/firestore.rules` y `firebase/tests/zyro-rate-limits.test.mjs`; 18/18 pruebas de reglas satisfactorias, preservando cuenta/perfil/demo.

**Checkpoint**: contratos y pruebas base listos; todavía no existe una respuesta real.

---

## Phase 3: HU-05 — P07 Zyro (Priority: P1) 🎯 MVP

**Goal**: conversación protegida, temporal y accesible con guías fijas e IA general
limitada.

**Independent Test**: con cuenta sintética habilitada, recorrer P07 inicial,
conversación, guía, IA general, límite, carga y error; verificar acceso, teclado,
TalkBack, navegación, descarte, doble toque, retry y respuesta hostil.

### Tests for HU-05 — deben fallar antes de implementar

- [x] T014 [P] [US1] Probar `ZyroMessage`, request/response, límites textuales y rechazo de campos/URL en `mobile/test/features/zyro/zyro_message_test.dart` y `functions_zyro_repository_test.dart`; 6 pruebas satisfactorias.
- [x] T015 [P] [US1] Probar conversación por UID/proceso, salida/retorno, logout/cambio UID, una solicitud, retry mismo requestId, timeout15s configurable y Future tardío en `mobile/test/features/zyro/zyro_controller_test.dart`; 5 pruebas satisfactorias.
- [x] T016 [P] [US1] Probar callable sin Auth/AppCheck/verificación/evidencia, esquema, cuota10/10min, guía vigente/vencida, daño/sensible/fuera de alcance y salida hostil en pruebas Functions; 17 pruebas Node satisfactorias sin red.
- [x] T017 [P] [US1] Probar P07 en estados inicial/carga/error/guía/límite,320×720/412×915, texto100/200%, teclado/foco,48dp, semántica/contraste y URL inerte en pruebas Zyro; 19 pruebas móviles específicas satisfactorias.
- [x] T018 [P] [US1] Probar acceso/navegación/regresión: visitante y no verificado→acceso, sesión→P07, Chat IA seleccionado, salir/volver conserva y logout descarta; regresión F01–F04 cubierta por suite completa.

### Domain and application

- [x] T019 [P] [US1] Implementar modelos inmutables y validación del contrato en `mobile/lib/features/zyro/domain/zyro_message.dart`, incluyendo texto plano, roles, kinds,0–6 pasos y metadatos de guía.
- [x] T020 [P] [US1] Definir resultados/errores sanitizados y puerto en `mobile/lib/features/zyro/data/zyro_repository.dart`, sin exponer proveedor, stack o UID a UI.
- [x] T021 [US1] Implementar propietario/controlador de conversación en `mobile/lib/features/zyro/application/zyro_controller.dart`: RAM por UID, máximo8/6000 enviados, una activa, UUID/retry, timeout15s, generación y descarte aprobado; límites de cruce aplicados por el adaptador.
- [x] T022 [US1] Implementar adaptador callable en `mobile/lib/features/zyro/data/functions_zyro_repository.dart`, validar campos exactos/schema/requestId/metadatos/URL, no registrar cuerpos y traducir códigos a estados seguros.

### Server

- [x] T023 [P] [US1] Implementar catálogo cerrado/versionado en `firebase/functions/src/zyro/catalog.ts`; doce guías de Instagram/Facebook/Google, coincidencia por acción exacta, solo `vigente`, ninguna reconstrucción generativa y cuatro pruebas Node satisfactorias.
- [x] T024 [P] [US1] Implementar pre/postfiltros y textos de límite en `firebase/functions/src/zyro/policy.ts`: sensibles, daño, fuera de alcance, certeza/promesas, URLs y credenciales; el contrato impide más de6 pasos.
- [x] T025 [P] [US1] Implementar adaptador Vertex con identidad de servicio, modelo/región aprobados, salida JSON estructurada y timeout14s en `firebase/functions/src/zyro/vertex_adapter.ts`, sin API key ni logs de contenido.
- [x] T026 [US1] Implementar router híbrido en `firebase/functions/src/zyro/router.ts`: filtros→guía fija→IA general→posfiltro; el modelo nunca crea pasos de cuenta.
- [x] T027 [US1] Implementar cuota transaccional10/10min y TTL≤24h en `firebase/functions/src/zyro/rate_limit.ts`, guardando solo UID/ventana/contador/expiración; pruebas de ventana y undécima solicitud satisfactorias.
- [x] T028 [US1] Implementar callable `zyroRespond` en `firebase/functions/src/zyro/callable.ts` con Auth password, correo verificado, evidencia priva-1.0.0, AppCheck obligatorio, contrato y errores sanitizados.
- [x] T029 [US1] Exportar callable y configurar región `us-central1`, memoria256MiB, concurrencia10 y timeout15s en `firebase/functions/src/index.ts`, sin registrar UID o cuerpos.

### P07 and integration

- [x] T030 [US1] Implementar P07 según PDF5 en `mobile/lib/features/zyro/presentation/zyro_screen.dart`: Zyro existente, aviso sensible, conversación, campo≤1000, Enviar, estados, scroll/teclado y menú sin marco de teléfono.
- [x] T031 [US1] Implementar burbujas/guías/límites accesibles y texto plano no accionable en `mobile/lib/features/zyro/presentation/zyro_message_view.dart`, con autor, encabezados, revisión y hasta6 pasos.
- [x] T032 [US1] Integrar repositorio/controlador por encima de P07 en `mobile/lib/app/priva_app.dart` y `mobile/lib/app/account_router.dart`, habilitar `/chat` en `mobile/lib/features/navigation/data/destination_catalog.dart` y preservar builder/guardas F01–F04.
- [ ] T033 [US1] Activar App Check Play Integrity en producción y proveedor debug solo en test mediante `mobile/lib/main.dart` y configuración Android; fallo de AppCheck deja P07 recuperable, no desactiva controles.
- [x] T034 [US1] Conectar ciclo de sesión/navegación en `mobile/lib/features/zyro/application/zyro_controller.dart`: salir invalida pendiente, volver conserva mensajes, background conserva proceso y logout/cambio UID/fin descarta; cubierto por pruebas.
- [x] T035 [US1] Completar errores/reintento/red/doble toque y foco anunciado en `mobile/lib/features/zyro/presentation/zyro_screen.dart`, sin segunda burbuja ni borrado silencioso del borrador; cubierto por P07 y controlador.
- [ ] T036 [US1] Añadir integración con emuladores y recorrido sintético P07 en `mobile/integration_test/zyro_test.dart`, sin llamar Vertex real ni usar cuentas personales.

**Checkpoint**: HU-05 funciona de extremo a extremo en proyecto de pruebas; ninguna
guía o proveedor pendiente puede sustituirse silenciosamente.

---

## Phase 4: Polish, validación y entrega

- [x] T037 Ejecutar análisis, suite Flutter completa, Functions, Firestore Emulator y reglas; 0 diagnósticos,199/199 Flutter,17/17 Functions,18/18 reglas y APK debug satisfactorio, con resultados y límites en `validation/technical-results.md`.
- [ ] T038 Auditar almacenamiento, tráfico, Firestore, APK y Cloud Logging con mensajes sintéticos; acreditar ausencia de cuerpos/contexto/respuestas/secretos y TTL del contador en `specs/005-zyro-orientacion/validation/privacy-security.md`.
- [ ] T039 Ejecutar20 ciclos de admitida/guía/límite/error/retry/doble toque, feedback≤1s y resultado≤15s; guardar solo agregados en `specs/005-zyro-orientacion/validation/performance.md`.
- [ ] T040 Validar Android API24/API36 y320×720/412×915 con texto100/200%, teclado, atrás, background, red y logout; registrar ejecutado/omitido en `specs/005-zyro-orientacion/validation/android-matrix.md`.
- [ ] T041 Ejecutar TalkBack físico para autor/orden/campo/Enviar/Reintentar/guía/límite/foco y registrar evidencia sin conversación real en `specs/005-zyro-orientacion/validation/accessibility.md`.
- [ ] T042 Ejecutar SC-05.5 con5 participantes40–65 y cinco tareas; conservar solo conteos agregados y defectos en `specs/005-zyro-orientacion/validation/comprehension.md`.
- [ ] T043 Desplegar Functions/reglas/TTL/AppCheck únicamente en proyecto de pruebas y realizar smoke con mensajes sintéticos; registrar región/modelo/versiones sin secretos en `specs/005-zyro-orientacion/validation/hosted-smoke.md`.
- [ ] T044 Consolidar RF/CA/SC→T001–T043→pruebas/resultados, limitaciones y bloqueantes en `specs/005-zyro-orientacion/validation/traceability.md` y `delivery-review.md`.
- [ ] T045 Actualizar `specs/README.md`, solicitar aceptación explícita, hacer commit y sincronizar `work`; no cerrar F05 ni avanzar F06 con pendientes.

## Dependencies & Execution Order

```text
T001–T003,T005–T006 puertas locales
        ↓
T007–T013 fundamento
        ↓
T014–T018 pruebas fallidas
        ↓
T019–T029 dominio/servidor
        ↓
T030–T036 P07/integración
        ↓
T037–T045 validación/aceptación

T004 debe completarse después de T042 y antes de T043
```

T008–T011 pueden avanzar en paralelo tras T001/T002. T014–T018 son paralelas tras
fundamento. T023–T025 son paralelas tras contratos; T026 depende de ellas. T030 puede
avanzar con repositorio falso tras T019–T021; T032 depende de P07 y repositorio.

## Implementation Strategy

El MVP es HU-05 completa, porque existe una sola historia. Se ejecuta en incrementos:

1. Puertas y catálogo aprobados.
2. Contratos/pruebas sin red.
3. Guías fijas y límites con adaptador IA falso.
4. Vertex únicamente después de pasar políticas.
5. P07/integración y proyecto Firebase de pruebas.
6. Validaciones y aceptación.

No se despliega producción ni se avanza F06 por pasar pruebas locales.

## Format Validation

Total:45 tareas. HU-05:23 tareas etiquetadas US1 (T014–T036). Setup/fundamento:13.
Validación/cierre:9. Todas usan checkbox, ID secuencial, etiqueta cuando aplica y
ruta concreta. Oportunidades paralelas marcadas `[P]`.
