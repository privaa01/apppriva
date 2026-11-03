# Tasks: F03 — Inicio y navegación

**Fecha**: 2026-11-03. **Rama**: `work`.
**Input**: [spec aprobado](spec.md), [plan aprobado](plan.md),
[investigación](research.md), [modelo](data-model.md),
[contratos C1–C6](contracts/inicio-navegacion.md), [guía](quickstart.md),
[constitución v1.1.0](../../.specify/memory/constitution.md).
**Estado**: ejecución autorizada explícitamente por el usuario el 2026-11-03
mediante «apruebo» sobre `2cd833f`. Implementación y pruebas locales:27/35 tareas
completadas;8 controles de entrega/nativos/mediciones pendientes. Ver validation/. El usuario aprobó el plan del commit `125f313` mediante «apruebo».

## Format: `[ID] [P?] [Story?] descripción con ruta`

IDs locales a F03, sin renumerar F01/F02. `[US1]` corresponde únicamente a
**HU-03 (P1)**: encontrar herramientas, navegar, retroceder y respetar sesión/salida.
Los recorridos no crean historias nuevas. `[P]` identifica archivos independientes
una vez satisfechos sus prerrequisitos; no autoriza agentes ni trabajo paralelo.
Rutas relativas a la raíz del repositorio. No crear otro proyecto móvil.

**Pruebas requeridas:** spec y plan exigen autorización positiva/negativa, historial,
contratos temporales, accesibilidad, regresión, Android y mediciones. Preparar las
pruebas antes del comportamiento correspondiente; demostrar fallos funcionales
pertinentes tras disponer de contratos compilables, no dar como RED válido un SDK,
archivo o import ausente. No eliminar tests para ocultar un defecto. Un doble
sintético no acredita integración real F06/F07 ni una prueba con participantes.

## Phase 1: Setup — entorno y baseline existentes

- [X] T001 Preparar/verificar toolchain Flutter3.47.8/Dart3.13.7, Android SDK y rutas de configuración/caches escribibles; ejecutar baseline de mobile/test/, análisis y revisión de mobile/pubspec.lock, registrar versiones/comandos/recuentos reales en specs/003-inicio-navegacion/validation/baseline.md; no copiar los103 resultados históricos como ejecución ni cambiar pins, TLS o minSdk para evitar un bloqueo.
- [X] T002 Registrar matriz API24/API36,320×720 y412×915dp, texto100%/200%, un Android físico, disponibilidad de cuentas sintéticas y cinco participantes elegibles según quickstart en specs/003-inicio-navegacion/validation/environment.md; comprobar compatibilidad SDK antes del trabajo afectado y documentar bloqueos sin afirmar ejecuciones. Depende de T001.

**Checkpoint:** baseline reproducible y matriz verificada antes de implementar.
Si un entorno/prerrequisito no está disponible, registrar bloqueo y completar solo
trabajo independiente autorizado; no cambiar requisitos sin revisión.

## Phase 2: Foundational — contratos transitorios

- [X] T003 [P] Definir catálogo/tipos de Destination y sección en mobile/lib/features/navigation/data/destination_catalog.dart con todos los paths de C1, acceso public/entry/private, available y requiresResult; respetar «Catálogo cerrado, sin UID ni parámetros personales; detalles Tips→Tips, Resultados→Cuestionario». El catálogo no concede permisos ni simula módulos entregados. Depende de T002.
- [X] T004 [P] Definir puerto TemporaryJourney en mobile/lib/features/navigation/data/temporary_journey.dart: «fase idle/attempt/result, canPrevious, generation», previousQuestion y discard(reason) sincrónico/idempotente; «Puerto sin respuestas ni score; producción vacío hasta integración F06/F07». No implementar preguntas, puntaje, PD-10 ni persistencia. Depende de T002; independiente de T003.
- [X] T005 Definir NavigationState, contexto e intención pendiente en mobile/lib/features/navigation/application/navigation_state.dart: «Memoria por app, sincronizada con Navigator; sin copiar payload de vistas», «Una intención pendiente; invalidar al cambiar sesión, recorrido o ciclo de vida» y «Solo comparación de contexto, nunca concede permisos ni persiste UID en historial». Depende de T003/T004.
- [X] T006 Definir seam de coordinador/observer y contrato ExitDecision/ProfileExitGuard en mobile/lib/features/navigation/application/navigation_controller.dart para allow/blockSaving/confirmDiscard/previousQuestion; «Consulta local a F02; unknown permite salir, no cancela escritura remota». Mantener interfaz inyectable y no duplicar AccountController/ProfileController. Preparar solo contratos compilables antes de la implementación de política. Depende de T005.

**Checkpoint:** T003–T006 preparan tipos/fronteras, no validan navegación. Un solo
Navigator, sin dependencias nuevas ni cambios Firebase. Preservar la propiedad del
observer PageRoute de Perfil y los builders de prueba existentes.

## Phase 3: US1 — HU-03 Navegar (P1), MVP de F03

**Objetivo:** P01 y cinco controles coherentes, autorización vigente, selección,
retroceso sin duplicados y contratos de salida/ciclo de vida.

**Prueba independiente:** visitante/no habilitado/sesión sintética sobre todos los
destinos, tarjeta/menú equivalentes,20 reselecciones y detalle→catálogo; UID A→B y
sesión perdida; salida/cancelación y descarte con un puerto sintético sin respuestas.
Los módulos F04–F07 pendientes se identifican como tales, sin afirmarlos entregados.

### Pruebas antes del comportamiento

- [X] T007 [P] [US1] Preparar mobile/test/features/navigation/destination_catalog_test.dart para rutas de C1, desconocidos, sección heredada, public/entry/private y resultados condicionados; probar visitante/no habilitado/autenticado y que el builder privado no se invoca sin autorización (RF-05.b/e, CA-03.5/03.9, CA-ACC-01–05). Depende de T006.
- [X] T008 [P] [US1] Preparar mobile/test/features/navigation/navigation_controller_test.dart para reselección no-op,20 repeticiones, A→B→A, detalle directo con padre Tips, pop/replace/remove, raíz sale, intención única, espera de diálogo y UID/generación tardíos (C2, CA-03.2/03.3/03.6, SC-03.1/03.2). Depende de T006.
- [X] T009 [P] [US1] Preparar mobile/test/features/navigation/temporary_journey_navigation_test.dart con doble sintético para pregunta anterior/primera, Cancelar/Salir, resultado, descarte idempotente, sesión perdida y respuesta tardía; verificar que no se copian respuestas al estado/ruta y etiquetar cobertura de contrato, no F06/F07 real (C4/C5, CA-03.7/03.8). Depende de T006.
- [X] T010 [P] [US1] Preparar mobile/test/features/navigation/navigation_screen_test.dart para P01/tres tarjetas, equivalencia con menú, P11 visible sin selección privada, P10 sin menú nuevo, destinos pendientes/desconocidos y raíz con retroceso; no introducir contenido editorial de F04–F07 (C1/C2/C6, CA-03.1/03.4/03.5/03.9). Depende de T006.
- [X] T011 [P] [US1] Preparar mobile/test/features/navigation/navigation_profile_test.dart para guard saving en cabecera/menú/back, unknown permite salir, PageRoute observer y recarga al volver, cierre/retroceso y respuesta remota tardía sin restaurar perfil (C3, CA-03.3/03.6 y contrato F02). Depende de T006.
- [X] T012 [P] [US1] Añadir regresión de revocación por stream nulo/inválido/UID B con concesión A a mobile/test/features/account/account_state_test.dart; comprobar que un evento no concede otra sesión y no rompe alta/acceso/recuperación F01 (RF-05.b, CA-03.6). Depende de T006.
- [X] T013 [P] [US1] Preparar mobile/test/features/navigation/navigation_lifecycle_test.dart para inactive/cubierta, hidden/paused/detached/dispose, resumed, repetición e invalidación de diálogo; cuenta no cierra por segundo plano y contenido temporal no se restaura (C5, CA-03.8). Depende de T006.

T007–T013 usan archivos distintos. Antes de completar las tareas de implementación,
comprobar la prueba relevante contra el comportamiento previo/stub y después contra
la solución; no afirmar fallos observados cuando no se hayan ejecutado.

### Implementación e integración

- [X] T014 [US1] Implementar resolución y autorización de catálogo en mobile/lib/features/navigation/data/destination_catalog.dart y adaptar mobile/lib/features/account/application/account_state.dart sin segunda fuente de permisos: ruta conocida→permiso F01→precondición de resultado; denegar desconocidos como módulo y nunca inferir resultado de argumentos (C1; satisfacer T007). Depende de T007.
- [X] T015 [US1] Corregir listener de mobile/lib/features/account/application/account_controller.dart para revocar también al cambiar UID de la concesión vigente, invalidando generación; stream puede revocar pero no conceder B, conservar flujos de autenticación F01 (satisfacer T012). Depende de T012/T014.
- [X] T016 [US1] Implementar coordinador/observer en mobile/lib/features/navigation/application/navigation_controller.dart: ruta real determina selección; no-op actual, popUntil para destino existente y push para nuevo, padre lógico Tips directo, back en raíz sale; observar push/pop/remove/replace sin duplicar transiciones F01/F02 (C2; satisfacer T008 de historial). Depende de T008/T014/T015.
- [X] T017 [US1] Añadir al coordinador en mobile/lib/features/navigation/application/navigation_controller.dart intención única y guardas UID/generaciones antes/después de esperar; ocultamiento privado inmediato por guarda y limpieza agrupada de historial privado fuera de build, sin bucle de reemplazos ni navegación tardía (C1/C2; satisfacer T008 de invalidación). Depende de T016.
- [X] T018 [US1] Integrar política C4 con puerto temporal en mobile/lib/features/navigation/application/navigation_controller.dart: previousQuestion sin salir, confirmar desde primera/cambio de sección, Cancelar conserva estado, Salir descarta antes de navegar, abandonar resultado descarta y ningún historial revive intento completado; cerrar/invalidar diálogo tardío por sesión/ciclo (satisfacer T009). Depende de T009/T017.
- [X] T019 [US1] Conectar navigatorKey, observer de navegación, puerto vacío por defecto y observador raíz WidgetsBindingObserver en mobile/lib/app/priva_app.dart; conservar observer PageRoute de Perfil y APIs de tests; inactive cubre sensible y hidden/paused/detached/dispose descartan idempotentemente, resumed no restaura ni signOut por segundo plano (C5; satisfacer T013). Depende de T013/T018.
- [X] T020 [US1] Integrar catálogo y guardas previas a construir contenido/builder en mobile/lib/app/account_router.dart: P01 real, Perfil F02 existente, detalle Tips con padre, estado seguro desconocido/resultados sin precondición y marcadores honestos para módulos pendientes; sin rutas externas nuevas ni datos personales en argumentos (C1/C2; satisfacer T007/T010). Depende de T010/T019.
- [X] T021 [US1] Adaptar mobile/lib/features/account/presentation/account_scaffold.dart para que cabecera/menú consulten el coordinador, compartan intención con tarjetas y deriven selección de la ruta real; conservar P11 visible y P10 sin extensión del menú, mensajes sencillos y fallback de contexto compatible con tests existentes (C2/C6). Depende de T020.
- [X] T022 [P] [US1] Crear mobile/lib/features/navigation/presentation/home_screen.dart con tres tarjetas y textos educativos aprobados en spec, composición P01 y uso del coordinador; sin riesgos personalizados, garantías, historial, ilustraciones nuevas ni contenido F04–F07 (C1/C6, CA-03.4; satisfacer T010 de P01). Depende de T020; independiente de T021 en archivos, verificar juntos al terminar.
- [X] T023 [US1] Integrar ProfileExitGuard en mobile/lib/features/profile/presentation/profile_screen.dart y su uso desde mobile/lib/features/navigation/application/navigation_controller.dart: bloquear salida voluntaria en saving, permitir unknown y priorizar cierre/invalidación; preservar activate/deactivate, observer, borrador y reconciliación F02 sin cancelar transacción remota (satisfacer T011). Depende de T011/T021/T022; secuencial respecto de T016–T018.
- [X] T024 [US1] Completar en mobile/lib/features/account/presentation/account_scaffold.dart selección visual adicional al color y Semantics seleccionado, una sola lectura por control, reflujo a320dp/texto200%, objetivos≥48dp y foco comprensible en avisos; usar paleta actual, no reducir escala del usuario ni duplicar anuncios (C6, CA-03.2/03.10). Depende de T023; secuencial respecto de T021.
- [X] T025 [US1] Crear mobile/integration_test/navigation_test.dart para matriz de acceso/destinos, historial, Perfil, fronteras temporales y eventos Android con modo sintético explícito; pruebas Firebase solo con cuentas sintéticas autorizadas y configuración local ignorada, sin crear usuarios/enviar correos ni presentar dobles como F06/F07 real. Preparar ejecución nativa, no marcarla hecha (C1–C6). Depende de T024.

**Checkpoint US1:** el MVP técnico corresponde a HU-03 completa, no a una sola
pantalla Inicio. Exige T026 y validaciones finales para aceptación. Preparar un
runner nativo o pasar contratos sintéticos no demuestra Android ni completa F06/F07.

## Phase 4: Validación y cierre transversal

- [X] T026 Ejecutar todas las pruebas de mobile/test/features/navigation/ y suite completa mobile/test/ con análisis estático/formato, corregir causas en archivos responsables, registrar comandos, recuentos nuevos, defectos y repruebas en specs/003-inicio-navegacion/validation/local-results.md; cobertura de acceso 100%,20 reselecciones sin duplicados y ninguna exposición privada (SC-03.1/03.2). Depende de T025.
- [ ] T027 Compilar APK Android con lockfile en mobile/, registrar commit, versión, SHA256/ruta del artefacto y resultado real en specs/003-inicio-navegacion/validation/builds.md; instalar en matriz aprobada sin iOS ni convertir APK debug en release. No atribuir APK viejo del usuario al nuevo commit. Depende de T026.
- [ ] T028 Ejecutar mobile/integration_test/navigation_test.dart en API24/API36 y Android físico con Home/recientes/notificación/retroceso/reinicio, sesión y Perfil; registrar modelos/AVD, OS, tamaños y resultados en specs/003-inicio-navegacion/validation/native-results.md, separando puerto sintético de módulos reales, y verificar que matar proceso no depende de un callback ni restaura estado. Depende de T027.
- [X] T029 Preparar mobile/integration_test/navigation_performance_test.dart con reloj monotónico desde pulsación a feedback/vista/aviso,20 repeticiones por acción/configuración según quickstart, espera humana separada y fallo/espera de Perfil simulados; emitir solo métricas sanitizadas, sin UID/credenciales/respuestas/resultados ni tiempos de entrega de correo/IA. Preparación no equivale a medición. Depende de T026.
- [ ] T030 Ejecutar pruebas automáticas en mobile/test/features/navigation/navigation_accessibility_test.dart y revisión nativa TalkBack/texto100%/200% en cuatro configuraciones y Android físico; comprobar etiquetas/selección única, señal además de color, foco, objetivos48dp, contraste4.5:1 normal/3:1 grande/componentes y acciones disponibles, registrar defectos/repruebas/modelos en specs/003-inicio-navegacion/validation/accessibility.md (SC-03.4). Depende de T028; cualquier nuevo código exige repetir análisis/suite y build pertinentes.
- [ ] T031 Ejecutar mobile/integration_test/navigation_performance_test.dart en la matriz y perfiles de red acordados; guardar20 muestras por acción/configuración, máximos e incumplimientos en specs/003-inicio-navegacion/validation/performance.md; verificar feedback≤1s y resolución/aviso≤15s sin usar promedio o timeout configurado como prueba de cumplimiento. Depende de T029/T030.
- [ ] T032 Ejecutar protocolo aprobado de5 participantes40–65años×6 tareas de quickstart sobre el mismo build, sin ayuda ni grabaciones, con cuentas sintéticas y marcadores honestos; consolidar30 oportunidades válidas, meta≥21/30 y conteos por tarea en specs/003-inicio-navegacion/validation/usability.md, borrar notas individuales al agregar y no guardar identidades. Falta de participantes es pendiente, no simulación satisfactoria (SC-03.5). Depende de T028/T030; si cambió build, usar artefacto actualizado y documentado.
- [ ] T033 Revisar rutas/argumentos/estado, almacenamiento/logs/tráfico y ciclo de vida con estado sintético; comprobar cero persistencia/restauración de respuestas/resultados, cero datos adicionales o llamadas IA y respeto a F01/F02, registrar alcance real y limitaciones en specs/003-inicio-navegacion/validation/privacy-review.md (RF-05.g, SC-03.3). Depende de T028/T031; no fijar retenciones legales ni resolver PD-10 por inferencia.
- [ ] T034 Consolidar RF-05.a–g/RNF aplicables→HU-03→CA-03.1–03.10/CA-ACC-01–05→tareas→pruebas/resultados y SC-03.1–03.5 en specs/003-inicio-navegacion/validation/traceability.md y current-results.json; diferenciar local, nativo, doble sintético, reporte, bloqueado y pendiente; sin cerrar si faltan mediciones, participantes o CA (contratos C1–C6). Depende de T027–T033.
- [ ] T035 Ejecutar specs/003-inicio-navegacion/quickstart.md, actualizar mobile/README.md y specs/README.md con estado real y revisión de entrega en specs/003-inicio-navegacion/validation/delivery-review.md; comprobar mismo código validado/artefacto, ausencia de secretos y bloqueantes, hacer commit/push y solicitar aceptación explícita de F03. No avanzar F04 ni declarar integrados F06/F07; registrar futura repetición de fronteras al integrarlos. Depende de T034.

## Dependencies & Execution Order

```text
T001 → T002 → T003 + T004 → T005 → T006
T006 → T007 + T008 + T009 + T010 + T011 + T012 + T013
T007 → T014; T012 + T014 → T015
T008 + T015 → T016 → T017; T009 + T017 → T018
T013 + T018 → T019; T010 + T019 → T020
T020 → T021 + T022; T011 + T021 + T022 → T023 → T024 → T025
T025 → T026 → T027 → T028 → T030
T026 → T029; T029 + T030 → T031
T028 + T030 → T032; T028 + T031 → T033
T027–T033 → T034 → T035
```

Las dependencias explícitas de cada tarea prevalecen sobre esta vista resumida.
Solo existe US1/HU-03; no hay una historia posterior a iniciar en este spec. Los
módulos de contenido y PD ajenos mantienen su estado. No hay excepción constitucional.

## Parallel Example: US1

Tras T006, T007–T013 pueden prepararse en archivos separados sin modificar la misma
implementación. Tras T020, T021 (scaffold) y T022 (Inicio) son independientes hasta
su integración en T023. T003/T004 comparten prerrequisito y usan archivos distintos.
Estas son las10 oportunidades `[P]` indicadas; no son una instrucción para lanzar agentes.

Las tareas del mismo coordinador T006/T016–T018/T023 se realizan secuencialmente.
T021/T024 también comparten archivo y no deben ejecutarse a la vez. No mezclar
simultáneamente un cambio de build con mediciones nativas o sesiones de participantes.

## Implementation Strategy

1. Autorizar esta lista antes de ejecutar y completar setup sin cambiar alcance.
2. Completar contratos y tests de HU-03; comprobar fallos funcionales, implementar
   de forma incremental acceso→historial→salida→integración→presentación.
3. Validar el MVP HU-03 de manera independiente, conservando regresión F01/F02.
4. Completar matriz Android, mediciones y protocolo de uso; corregir bloqueantes y
   repetir evidencias afectadas si cambia código o build.
5. Consolidar trazabilidad, sincronizar Git y obtener aceptación de F03. La entrega
   de este spec no autoriza ni completa contenidos de F04–F07.

## Trazabilidad resumida

| Requisito / criterio | Tareas principales | Evidencia final |
| --- | --- | --- |
| RF-05.a / CA-03.1/03.4 | T010,T020–T022,T024 | T026/T028/T030 |
| RF-05.b / CA-03.5/03.6, CA-ACC-01–05 | T007,T012,T014/T015/T017/T020 | T026/T028/T033 |
| RF-05.c / CA-03.2/03.3/03.9 | T008/T011,T016/T017/T020/T023 | T026/T028 |
| RF-05.d / CA-03.7/03.8 | T009/T013,T018/T019/T025 | T026/T028/T033; integración F06/F07 posterior |
| RF-05.e/f / CA-03.5/03.9/03.10 | T007/T010,T020–T024 | T026/T028/T030/T032 |
| RF-05.g / CA-03.6/03.8 | T003–T006,T015/T017–T019 | T026/T028/T033 |
| SC-03.1/03.2/03.3 | T007–T019 | T026/T028/T033 |
| SC-03.4 / RNF-02–06 aplicables | T024/T025 | T027/T028/T030 |
| SC-03.5 / RNF-01 | T002 | T032 (21/30 oportunidades sin ayuda) |
| RNF-07–09 y presupuestos del plan | T019/T025/T029 | T028/T031/T033 |
| Constitución y gobierno de entrega | T001/T002 | T034/T035 y aceptación explícita |

## Estado de esta generación

Generación original:35 tareas,2 setup,4 foundational,19 US1/HU-03 y10 de validación/cierre;
10 marcadores `[P]`. Inicialmente todas pendientes. La autorización y ejecución
posteriores se distinguen mediante los marcadores actuales y validation/. No existe `.specify/extensions.yml`: sin hooks before/after_tasks.
El checklist16/16 es revisión documental del spec, no ejecución de tareas ni aceptación.

## Autorización de ejecución — 2026-11-03

El usuario aprobó las tareas y autorizó iniciar la implementación al responder
«apruebo» a la solicitud explícita sobre `2cd833f`. Esta autorización no declara
resultados de pruebas ni aceptación final de F03.

## Estado de implementación — 2026-11-03

T001–T026 completadas como setup/contratos/implementación/regresión local;
T025 prepara runner nativo, no ejecuta Android. T029 prepara mediciones, no las
realiza. T027/T028/T030–T035 siguen abiertas: compilación/instalación/matriz,
Android real, TalkBack, muestras, participantes, privacidad nativa, trazabilidad
y entrega final. Los documentos parciales no cierran esas tareas. Sin aceptación
final ni avance a F04. Checklist documental sin cambios de marcadores.
