# Tasks: F01 — Cuenta y acceso

**Input**: [spec](spec.md), [plan aprobado](plan.md), [research](research.md),
[modelo](data-model.md), [contratos](contracts/cuenta-acceso.md),
[guía](quickstart.md) y [constitución](../../.specify/memory/constitution.md).
**Fecha**: 2026-10-27. **Rama**: work.
**Estado**: implementación en curso; 32 tareas completadas, 13 pendientes. Validación móvil y de entrega sin completar.

## Format: ID, P y Story

Cada tarea incluye checkbox, ID consecutivo y ruta relativa a la raíz del repositorio.
[P] indica archivos independientes dentro del grupo, después de sus prerrequisitos.
[US1] corresponde únicamente a HU-01 (P1): registro, acceso y recuperación pertenecen
a la misma historia aprobada. No se inventan historias ni módulos adicionales.

**Tests:** incluidos porque el spec exige CA-01, CA-ACC y evidencia SC-005. Escribir
las pruebas del grupo antes de implementar su comportamiento y comprobar el fallo
funcional pertinente; un SDK ausente no cuenta como fallo funcional esperado.
La sonda existente del proveedor no sustituye pruebas de app ni del servicio hospedado.

## Path Conventions

App y pruebas en mobile/; configuración, migraciones y pruebas del servicio en
supabase/; evidencia de F01 en specs/001-cuenta-acceso/validation/.
Las rutas inexistentes son entregables futuros; esta invocación no las crea.

## Phase 1: Setup (Shared Infrastructure)

**Propósito:** base reproducible sin datos reales ni implementación de otros módulos.

- [X] T001 Instalar por vía oficial verificada Flutter 3.47.8/Dart 3.13.7 y registrar versiones y host en specs/001-cuenta-acceso/validation/toolchain.md; no cambiar baseline silenciosamente y distinguir runner Android de macOS/Xcode para iOS.
- [X] T002 Inicializar proyecto Android/iOS en mobile/pubspec.yaml, mobile/lib/main.dart y mobile/README.md según el plan; no elegir identificador definitivo de publicación ni configurar firma/distribución por inferencia.
- [X] T003 Fijar supabase_flutter 2.18.3 y flutter_secure_storage 11.2.0 en mobile/pubspec.yaml y versionar mobile/pubspec.lock; documentar conflictos transitivos y detener cambios que eleven API 24/iOS 15 sin revisión.
- [X] T004 [P] Configurar análisis y formato en mobile/analysis_options.yaml y documentar comandos en mobile/README.md, sin desactivar controles para obtener éxito.
- [X] T005 [P] Configurar API 24 en mobile/android/app/build.gradle.kts e iOS 15 en mobile/ios/Runner.xcodeproj/project.pbxproj; registrar matriz mínima/actual, pantalla pequeña/grande y requisitos de runner en specs/001-cuenta-acceso/validation/device-matrix.md.

**Checkpoint:** T001→T002→T003; después T004/T005 pueden avanzar independientemente.
La validación iOS requiere Apple; no sustituirla por build Android.

## Phase 2: Foundational (Blocking Prerequisites)

**Propósito:** contratos comunes y controles de prueba; usuarios reales bloqueados hasta privacidad.

- [X] T006 Registrar entorno sintético y puertas de datos reales en specs/001-cuenta-acceso/validation/environment.md: responsable, región, SMTP, política, finalidades, conservación, borrado y acuerdos; señalar pendientes sin inventar plazos legales. Esta puerta bloquea usuarios reales, no pruebas sintéticas locales.
- [X] T007 Implementar configuración cliente y separación de entornos en mobile/lib/app/app_config.dart y mobile/config/example.json; documentar provisión segura en mobile/README.md, sin service key, SMTP ni credenciales en app/repo.
- [X] T008 [P] Definir estados visitante, verificación pendiente, normal y recuperación restringida en mobile/lib/features/account/application/account_state.dart; respetar «La solicitud por sí sola no acredita identidad» y no convertir cualquier signed-in en acceso completo.
- [X] T009 [P] Definir contrato del repositorio de registro, confirmación, acceso y recuperación en mobile/lib/features/account/data/account_repository.dart; no añadir SMS, login social ni creación automática al recuperar.
- [X] T010 [P] Definir errores y eventos sanitizados en mobile/lib/app/account_errors.dart; excluir nombre, correo, contraseña, códigos, tokens y cuerpos Auth y evitar enumeración de cuentas, conforme RF-03 y CA-01.3/CA-01.10.
- [X] T011 Implementar adaptador nativo protegido de sesión en mobile/lib/features/account/data/secure_session_storage.dart y conectarlo a la extensión del SDK; «Nunca contraseña; borrar al cerrar», sin preferencias comunes ni datos del cuestionario.
- [X] T012 Configurar Auth local en supabase/config.toml y documentar equivalencia hospedada en supabase/README.md: Confirm email, mínimo 12, OTP 600 s, reenvío 60 s, cuota nativa verify e IP confiable; no garantizar cinco fallos ni pedir teléfono por activar un ajuste de privacidad del proveedor.
- [X] T013 Crear plantillas de código en supabase/templates/confirmation.html y supabase/templates/recovery.html, referenciadas en supabase/config.toml; usar Token del propósito adecuado, sin sustituir recuperación por enlace/signInWithOtp ni enviar correos externos en pruebas locales.

**Checkpoint:** setup completo antes de fundamentos. T008/T009/T010 son independientes
con T007 listo; T011 requiere T007/T009; T013 requiere T012. No crear recursos externos
sin autorización ni pedir secretos en chat. T006 requiere revisión competente para datos reales.

## Phase 3: User Story 1 — Crear cuenta, acceder y recuperar (Priority: P1)

**Goal:** HU-01 completa, sin teléfono, correo verificado, recuperación por código,
Tips público y controles del wireframe sin eludir autorización.

**Independent Test:** cuenta sintética P10→confirmación→P11→sesión normal; errores y
recuperación vuelven al flujo seguro. Destinos de prueba verifican límites de módulos
externos sin implementar F02–F08 ni presentar esos destinos como producto terminado.

### Tests for User Story 1

- [X] T014 [P] [US1] Escribir pruebas de validación/estado en mobile/test/features/account/account_state_test.dart para CA-01.1/CA-01.2/CA-01.11 y normal frente a OTP; comprobar fallo funcional antes del coordinador.
- [X] T015 [P] [US1] Escribir pruebas del adaptador en mobile/test/features/account/account_repository_test.dart para CA-01.3/CA-01.8/CA-01.9/CA-01.10: duplicados, red, resultado desconocido, errores uniformes y recuperación sin crear usuarios; comparar el aviso exacto de CA-01.11 para inexistente/contraseña incorrecta/no verificado, sin transmitir errores crudos del proveedor.
- [X] T016 [P] [US1] Escribir pruebas de formularios en mobile/test/features/account/account_forms_test.dart para CA-01.1/CA-01.5/CA-01.6/CA-01.7: etiquetas, teclado, política antes de autorizar, ausencia de teléfono y texto ampliado.
- [X] T017 [P] [US1] Escribir pruebas de permisos en mobile/test/features/account/account_navigation_test.dart para CA-ACC-01–05: cuatro destinos Tips públicos, normal/OTP, ruta directa y retroceso tras sesión invalidada; simular frontera F02 sin implementar ese módulo.
- [X] T018 [P] [US1] Escribir pruebas SQL en supabase/tests/account_access.test.sql para propiedad, password frente a OTP, visitante y evidencia no editable; añadir rollback del alta si falla evidencia, versión ausente/inactiva, reintentos y modificación de metadata posterior; no usar service role para simular usuario ni permisos por metadatos editables.

### Models, Storage & Authorization

- [X] T019 [US1] Definir modelos en mobile/lib/features/account/data/account_models.dart: «ID de usuario y nombre para saludo», «no incluye teléfono ni historial del cuestionario» y «no se cambia correo por editar perfil»; no inventar campos o longitudes.
- [X] T020 [US1] Crear esquema mínimo y políticas en supabase/migrations/202610270001_account_access.sql: perfil uno a uno con Auth, esquema de políticas versionadas administradas por servidor y función de alta completada por T021 antes de habilitar registro, «Solo identidad propia puede leer/actualizar», AMR password firmado para recursos privados y cero persistencia del cuestionario; comprobar T018.
- [X] T021 [US1] Crear registro controlado de autorización en supabase/migrations/202610270002_authorization_evidence.sql: «ID, usuario, versión de política, finalidades autorizadas, acción y fecha de servidor», «evidencia inmutable para cliente» y «evitar IP/dispositivo por defecto»; usar trigger AFTER INSERT auth.users en la misma transacción para perfil/evidencia, NEW.id y fecha servidor, política publicada/acción explícita, privilegios mínimos y search_path fijo; rollback completo si falta autorización o falla evidencia. Clave única usuario/versión/acción; sin RPC pública, sin reescritura por metadata ni lectura privada OTP; T018 verifica reintentos y fallos parciales.

### Services & UI

- [X] T022 [US1] Implementar adaptador en mobile/lib/features/account/data/supabase_account_repository.dart con signUp, confirmación, signInWithPassword, resetPasswordForEmail, verifyOTP recovery, updateUser y cierre temporal; comprobar T015, sin tratar OTP como sesión normal.
- [X] T023 [US1] Implementar coordinador en mobile/lib/features/account/application/account_controller.dart integrando estados, contrato, almacenamiento, modelos y adaptador; exigir correo verificado/método password, limpiar secretos transitorios y comprobar T014.
- [X] T024 [US1] Implementar P10 en mobile/lib/features/account/presentation/signup_screen.dart con nombre para saludo, correo para identidad/recuperación, contraseña mínima 12, errores por campo y bloqueo de doble envío; RF-01 y CA-01.1/CA-01.5/CA-01.8.
- [X] T025 [US1] Implementar política y autorización en mobile/lib/features/account/presentation/treatment_policy_view.dart vinculadas a T021/P10; CA-01.6. Usar documento de prueba explícito con datos sintéticos; bloquear usuarios reales sin responsable/textos aprobados, sin presentar política provisional como definitiva.
- [X] T026 [US1] Implementar confirmación en mobile/lib/features/account/presentation/email_confirmation_view.dart: código de alta, reintentos limitados y regreso al acceso por contraseña, sin abrir Inicio por OTP; CA-01.2/CA-01.11.
- [X] T027 [US1] Implementar P11 en mobile/lib/features/account/presentation/signin_screen.dart con correo, contraseña, recuperación, cabecera/menú del wireframe y teclado/acción visibles; mismo aviso de CA-01.11 para inexistente/contraseña incorrecta/no verificado, sin contenido protegido ni confirmación de existencia; CA-01.3/CA-01.7/CA-01.10.
- [X] T028 [US1] Implementar estados de recuperación en mobile/lib/features/account/presentation/password_recovery_view.dart: código al correo, validación, nueva contraseña, incorrecto/vencido/usado y vuelta a P11 tras cerrar sesión temporal; CA-01.4/CA-01.9/CA-01.12/CA-01.13, sin SMS ni contador ficticio de cinco fallos.
- [X] T029 [US1] Integrar guardas en mobile/lib/app/account_router.dart: conservar menú P11, cuatro destinos Tips públicos y resto protegido, incluidas rutas entrantes y retroceso; comprobar T017 sin implementar contenido de otros módulos.
- [X] T030 [US1] Componer configuración, adaptador, almacenamiento y flujo en mobile/lib/app/priva_app.dart y mobile/lib/main.dart; reconciliar respuestas tardías/reintentos sin duplicar cuenta y comprobar T014–T017 en conjunto.

### Integration & Story Acceptance

- [ ] T031 [US1] Crear y ejecutar integración real local en mobile/integration_test/account_access_test.dart con buzón sintético: registro, confirmación, acceso y CA-01.1–01.8/CA-01.10/CA-01.11; mocks no prueban entrega del correo; agregar alta con evidencia fallida y reintento tras respuesta perdida, sin cuenta/perfil/evidencia huérfanos.
- [ ] T032 [US1] Crear y ejecutar mobile/integration_test/account_recovery_test.dart para CA-01.4/CA-01.9/CA-01.12/CA-01.13: mínimo 12, código 600 s, reenvío 60 s, uso único, límites nativos, cambio y regreso al acceso; no registrar códigos/tokens.
- [X] T033 [US1] Crear prueba HTTP en supabase/tests/account_access_http.py con tokens reales de visitante, alta OTP, recovery OTP, contraseña y refresh: acceso propio normal y rechazo de otra identidad/OTP, sin inyectar claims ni usar service key como usuario; ampliar la sonda SQL anterior.
- [ ] T034 [US1] Crear y ejecutar mobile/integration_test/account_permissions_test.dart para CA-ACC-01–05, RF-17 y SC-002–SC-004: ausencia de sesión, red, duplicación, menú persistente y sesión invalidada; limpieza real de cuestionario queda a F02/F06/F07.
- [ ] T035 [US1] Consolidar T014–T034 por CA/plataforma/commit en specs/001-cuenta-acceso/validation/account-acceptance.md, exigiendo resultados satisfactorios para declarar HU-01 completa y registrando integraciones externas aún pendientes.

**Checkpoint:** HU-01 no está entregada solo por existir formularios o sesión válida.
Faltan calidad, entorno final y aceptación; no afirmar que toda la app está implementada.

## Phase 4: Polish & Cross-Cutting Concerns

- [ ] T036 [P] Revisar almacenamiento, logs, crash reports y configuración en specs/001-cuenta-acceso/validation/privacy-review.md: sin contraseña/código/token expuesto, teléfono o datos del cuestionario; sesión solo en almacén nativo protegido, distinguiendo app/proveedor.
- [ ] T037 [P] Ejecutar TalkBack/VoiceOver, foco, etiquetas, teclado, contraste 4,5:1 texto normal y 3:1 texto grande según WCAG 2.2 AA/componentes significativos, y texto 200 % sin recortes ni controles inaccesibles en formularios/errores y registrar dispositivos/defectos en specs/001-cuenta-acceso/validation/accessibility.md; corregir presentación antes de aceptación.
- [ ] T038 Ejecutar análisis, pruebas y builds Android API 24+/iOS 15+ con SDK/lockfile fijados y guardar comandos/resultados en specs/001-cuenta-acceso/validation/builds.md; no declarar iOS probado desde Linux ni bajar verificaciones TLS/firma/checksum.
- [ ] T039 Configurar proyecto Supabase de pruebas y SMTP autorizados, repetir flujos y T033 por HTTP y registrar versión, AMR, cuotas, anti-enumeración y sesión 30/90 días en specs/001-cuenta-acceso/validation/hosted-auth.md; comprobar también mensajes/respuestas públicas de inexistente, contraseña incorrecta y no verificado; si el plan comercial no soporta lo aprobado, detener y revisar, no usar temporizadores UI como sustituto.
- [X] T040 [P] Preparar piloto SC-001 en specs/001-cuenta-acceso/validation/usability-protocol.md: diez participantes 40–65 años, denominador/condiciones, meta ≥8 registros completos y datos sintéticos; no inventar personas ni resultados.
- [ ] T041 Ejecutar piloto autorizado de T040 y registrar completitud, comprensión y ayuda en specs/001-cuenta-acceso/validation/usability-results.md; no guardar respuestas de cuestionario ni generalizar estadísticamente diez casos.
- [ ] T042 Cerrar con responsable competente región, acuerdos, conservación y supresión Auth/SMTP/logs/backups en specs/001-cuenta-acceso/validation/environment.md antes de usuarios reales; no aceptar contratos, comprar servicios o inventar retenciones como efecto de la tarea.
- [ ] T043 Después de T045, completar RF/RNF→HU/CA→tareas→pruebas/resultados y SC-001–SC-005 en specs/001-cuenta-acceso/validation/traceability.md, distinguiendo satisfactorio/fallido/omitido/no ejecutado; la sonda 21/21 no es aceptación de app.
- [ ] T044 Después de T043/T045, ejecutar specs/001-cuenta-acceso/quickstart.md, actualizar comandos reales de mobile/README.md y registrar cierre en specs/001-cuenta-acceso/validation/delivery-review.md; corregir bloqueantes, hacer commit/push y solicitar aceptación, sin desplegar ni avanzar a 002 automáticamente; clasificar defectos con C1 del plan y bloquear cualquier CA o umbral incumplido.

- [ ] T045 Medir feedback ≤1 s y respuesta o aviso de red ≤15 s por operación con reloj monotónico en mobile/integration_test/account_performance_test.dart y guardar duraciones sanitizadas en specs/001-cuenta-acceso/validation/performance.md; ejecutar 20 repeticiones por operación/perfil de red en dispositivos de la matriz, incluir respuesta artificialmente lenta y respuesta tardía, sin contar entrega del correo ni promediar para ocultar excesos. Depende de T035/T037/T038/T039; precede a T043/T044 (RNF-09).

## Dependencies & Execution Order

Setup T001–T005 → fundamentos T006–T013 → pruebas HU-01 T014–T018 → modelo y
autorización T019–T021 → adaptador/flujo T022–T030 → integración T031–T035 → cierre T036–T045, con T045 antes de T043/T044.
Solo hay una historia en este spec; el orden no autoriza HU-02–HU-08.

| Grupo | Prerrequisitos concretos |
| --- | --- |
| T004/T005 | T001–T003 completos; archivos distintos. |
| T008/T009/T010 | Setup y T007 listos; independientes entre sí. |
| T011 | T007/T009; T013 requiere T012. |
| T014–T018 | Fundamentos completos; archivos de prueba independientes. |
| T019/T020/T021 | Pruebas escritas; T020 depende de modelos; T021 de esquema/versión de política. |
| T022/T023 | T022 requiere contrato; T023 estados, modelo, adaptador y almacenamiento. |
| T024–T030 | Coordinador estable; T025 integra autorización, luego estados UI, router y composición. |
| T031–T035 | UI/migraciones/proveedor listos; T035 consolida resultados anteriores. |
| T036/T037/T040 | HU-01 integrada; evidencias independientes. |
| T038 | Correcciones aplicadas y runner Apple para iOS. |
| T039 | Recurso/SMTP autorizado y T033; no requiere usuarios reales. |
| T041 | Protocolo T040 autorizado y participantes disponibles. |
| T042 | Responsable/requisitos reales disponibles; bloquea datos reales, no pruebas sintéticas. |
| T045 | T035/T037/T038/T039; medir sobre versión identificada y condiciones de red registradas, sin cambios concurrentes del binario. |
| T043/T044 | Esperar T045 y consolidar evidencia; no declarar entrega terminada con bloqueantes o pruebas exigidas no ejecutadas. |

## Parallel Example: User Story 1

Después de fundamentos, T014/estado, T015/adaptador, T016/formularios,
T017/navegación y T018/SQL pueden prepararse en paralelo con archivos distintos y
contratos estables. No ejecutar una prueba dependiente de una migración incompleta.
Después de integración, T036/privacidad, T037/accesibilidad y T040/protocolo pueden
avanzar independientemente; integrar sus hallazgos antes de cerrar.
Estas oportunidades no instruyen a lanzar subagentes.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Aprobar las tareas y autorizar implementación; preparar entorno/fundamentos.
2. Escribir pruebas y completar registro, confirmación, acceso y recuperación.
3. Validar localmente con datos/correo sintéticos sin implementar otros módulos.
4. Completar HTTP real, móviles y calidad; informar recursos externos pendientes.
5. Obtener aceptación explícita; no publicar ni pasar a otro spec automáticamente.

Un MVP de solo formulario sin verificación, recuperación, permisos y evidencia no
satisface HU-01. El contenido de Tips, Perfil, Zyro o cuestionario no se añade para
aparentar una entrega de autenticación completa.

## Trazabilidad de aceptación

| Criterio | Tareas principales |
| --- | --- |
| RF-01 / CA-01.1/CA-01.5 | T014/T016/T019/T024/T031 |
| CA-01.2/CA-01.11 | T014/T020/T022/T023/T026/T031/T033 |
| CA-01.6 | T006/T016/T021/T025/T042 |
| RF-02 / CA-01.3/CA-01.7 | T015/T016/T022/T027/T031 |
| CA-01.4/CA-01.9/CA-01.12/CA-01.13 | T012/T013/T015/T022/T028/T032/T039 |
| RF-03 / CA-01.8/CA-01.10 | T010/T015/T023/T024/T027/T031/T034/T039 |
| CA-ACC-01–05 / RF-05 | T017/T020/T029/T030/T033/T034; descarte real en F02/F06/F07 |
| RF-17 / SC-004 | T015/T023/T031/T034 |
| RNF-01–06 / PD-07/08 | T005/T016/T037/T038/T040/T041 |
| RNF-09 / presupuestos 1/15 s | T045 antes de T043/T044 |
| RNF-07/08 / PD-05/06/09 | T006/T007/T011/T012/T020/T021/T036/T039/T042 |
| SC-001 | T040/T041; meta ≥80 %, no resultado supuesto |
| SC-002/SC-003 | T017/T031/T033/T034 |
| SC-005 | T035/T043/T044 |

## Notes & Approval Gate

**45 tareas:** setup 5, fundamentos 8, HU-01 veintidós y calidad/cierre 10.
T045 se añade sin renumerar IDs existentes; el orden explícito exige ejecutarla antes
de T043/T044. Ningún ID anterior se reasigna a otra tarea.
Todas permanecen sin marcar. No se ejecuta implementación en esta invocación.
macOS/dispositivos, recurso Supabase/SMTP, revisión de datos y participantes son
dependencias reales; no fabricar evidencia para cerrar casillas.
El máximo exacto de cinco fallos se retiró explícitamente el 2026-10-27.
El análisis de coherencia se repitió tras las correcciones y el usuario aprobó
explícitamente esta lista el 2026-10-27. El commit/push conserva esa decisión; no
ejecuta tareas ni invoca automáticamente implementación u otro spec.

## Registro de aprobación — 2026-10-27

El usuario respondió «lo apruebo» a la solicitud de aprobar las correcciones del
spec/plan y las 45 tareas del commit a7b99a4. Se cierra la puerta documental de tareas
y correcciones de F01. La implementación puede iniciarse cuando se solicite; este
registro no la inicia ni marca tareas realizadas. F02–F08 no quedan aprobados.

## Ejecución iniciada — 2026-10-27

Se verificó el checklist completo y el checkout oficial de Flutter. T001 no pudo
completarse: la descarga de Dart recibió 403 desde storage.googleapis.com. Véase
[toolchain.md](validation/toolchain.md). No hay tareas marcadas completas ni se
ejecutaron T002–T045. Se guardó la adición de red en el borrador del entorno y se
requiere aplicarla antes de reintentar. No cambia la aprobación del alcance.

## Avance de implementación

T001–T030 implementadas con pruebas locales disponibles; T033 probó autorización
por HTTP local con tokens reales y PostgREST. Evidencia en validation/implementation.md.
T031/T032/T034 requieren integración móvil; T035 y T036–T045 no están completadas.
No se declara terminada HU-01 ni se avanza a otro spec.
