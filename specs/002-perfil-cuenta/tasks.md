# Tasks: F02 — Perfil y cuenta

**Fecha**: 2026-10-29. **Rama**: work.
**Input**: [spec](spec.md), [plan aprobado](plan.md), [investigación](research.md),
[modelo](data-model.md), [contratos](contracts/perfil-cuenta.md),
[guía](quickstart.md), [constitución](../../.specify/memory/constitution.md).
**Estado**: implementación en curso;26 tareas de desarrollo/preparación y pruebas
locales completadas,8 validaciones finales pendientes. Tareas e implementación
autorizadas explícitamente mediante «inicia la implementación» sobre5611047.

## Format: `[ID] [P?] [Story?] descripción con ruta`

IDs locales a F02; no renumeran los de F01. [US1] corresponde únicamente a
**HU-02 (P1)**, con consulta/edición/cierre/solicitud como recorridos de esa historia.
No se inventan historias de usuario nuevas. [P] indica archivos independientes
solo después de sus prerrequisitos; no autoriza trabajo de agentes ni ejecución.

**Pruebas:** incluidas porque spec, contratos y plan aprobados requieren aceptación,
reglas, aislamiento y regresión. Preparar las pruebas del bloque antes del
comportamiento correspondiente y comprobar un fallo funcional pertinente. Ausencia
de SDK, dependencia o emulador es bloqueo de entorno, no prueba funcional válida.

## Phase 1: Setup — base existente

- [X] T001 Comprobar baseline Flutter3.47.8/Dart3.13.7, estado limpio y regresión F01; registrar versiones, comandos y resultados reales en specs/002-perfil-cuenta/validation/baseline.md, sin trasladar los69 resultados anteriores como nueva ejecución.
- [X] T002 Añadir url_launcher6.3.3 a mobile/pubspec.yaml y resolver mobile/pubspec.lock manteniendo Firebase y API24; registrar el transitivo Android real y detener cambios que eleven mínimos sin revisión. Depende de T001.
- [X] T003 [P] Registrar entorno sintético, matriz Android API24/actual y pequeña/grande, cliente de correo y límites de acceso/emulador en specs/002-perfil-cuenta/validation/environment.md; no afirmar hardware, despliegues o pruebas disponibles sin comprobar. Depende de T001; independiente de T002.

**Checkpoint:** completar T001–T003 antes de contratos compartidos. No inicializar
otra app, proveedor, backend o colecciones. No modificar el spec durante implementación
para ocultar incumplimientos.

## Phase 2: Foundational — contratos y datos transitorios

- [X] T004 Definir ProfileDetails en mobile/lib/features/profile/data/profile_details.dart con uid, name confirmado y email de identidad: «Email no se almacena de nuevo en Firestore ni se modifica en F02» y «El DTO y borrador solo viven en memoria». No inventar campos o defaults personales.
- [X] T005 [P] Definir ProfileRepository.loadCurrent/updateName en mobile/lib/features/profile/data/profile_repository.dart; contrato de identidad derivada de Auth, consulta servidor y resultado confirmado, nunca UID editable. Depende de T004.
- [X] T006 [P] Definir estados confirmados/cargando/editando/guardando/error/desconocido y borrador ligado a UID/generación en mobile/lib/features/profile/application/profile_state.dart; «Cambiar de identidad nunca traslada datos/borrador/errores personales a otra sesión». Depende de T004.
- [X] T007 [P] Definir interfaz comprobable de apertura de borrador/copia de dirección en mobile/lib/features/profile/data/deletion_contact_service.dart; resultados abierto/fallback, nunca enviado/recibido/eliminado. Sin datos de cuenta en URI. Depende de T004.

**Checkpoint:** T004 precede T005/T006/T007; estos tres archivos son independientes.
Los contratos preparan dobles de pruebas; no conceden permisos ni generan envíos.

## Phase 3: US1 — HU-02 Gestionar mi cuenta (P1)

**Objetivo:** P12 con datos propios, edición exclusiva del nombre, cierre seguro y
solicitud por correo explícita. Mantener los wireframes y fronteras de F01.

**Prueba independiente:** dos cuentas sintéticas A/B; consulta y gestión de A sin
acceso a B; cancelar/error/guardar, cerrar y retroceder; apertura/fallo/copia de canal
sin enviar correo real ni borrar datos. No requiere implementar F03–F08.

### Pruebas primero

- [X] T008 [P] [US1] Crear mobile/test/features/profile/profile_repository_test.dart para C1/C2: servidor frente a caché, correo Auth, identidad/confirmación/password/evidencia, perfil ausente, nombre vacío/espacios/legítimo, transacción exclusiva name y cambio de UID en espera/reintento; evidencia sin cambios (CA-02.1/02.4–02.9).
- [X] T009 [P] [US1] Crear mobile/test/features/profile/profile_controller_test.dart para consulta, borrador/cancelar, guardado confirmado/fallido, doble envío, timeout desconocido y reconciliación, respuesta tardía tras salida/cierre/cambio UID y sincronización de nombre sin crear permisos (C1–C3).
- [X] T010 [P] [US1] Crear mobile/test/features/profile/profile_screen_test.dart para P12: saludo/correo real de lectura, carga/error sin ejemplos/teléfono/historial, edición/cancelación, cierre y retroceso, información de eliminación y ausencia de mensajes enviados/eliminados (CA-02.1–02.17).
- [X] T011 [P] [US1] Crear mobile/test/features/profile/deletion_contact_service_test.dart para destinatario y escape de URI, apertura false/excepción, copia/fallo de copia bajo pulsación, cancelación sin mutación y exclusión de UID/credenciales/cuestionario (C4).
- [X] T012 [P] [US1] Crear firebase/tests/profile.test.mjs para actualización name propia verificada/password con evidencia; denegar visitante/otra cuenta/no verificado/sin evidencia, nombre vacío/solo espacios, correo/UID/campos extra/borrado y cambios de autorización; conservar pruebas de alta F01 y comparar evidencia antes/después (C2).

T008–T012 dependen de Phase2, trabajan en archivos distintos y pueden prepararse en
paralelo. Sus fallos deben corresponder al comportamiento aún no implementado.

### Implementación e integración

- [X] T013 [US1] Implementar loadCurrent en mobile/lib/features/profile/data/firestore_profile_repository.dart: derivar UID/email de Auth, exigir sesión normal y evidencia, leer perfil de servidor y verificar contexto al resolver; no usar email del formulario, caché, displayName como fuente ni datos de ejemplo. Satisfacer T008 de consulta.
- [X] T014 [US1] Implementar updateName en mobile/lib/features/profile/data/firestore_profile_repository.dart con transacción de perfil existente y guardas por UID en cada intento: «Normalizar extremos con trim, rechazar vacío/solo espacios y permitir caracteres legítimos»; actualizar solo name, sin upsert, Auth.updateDisplayName o escritura de evidencia. Depende de T013/T008.
- [X] T015 [US1] Implementar consulta/edición/cancelación y confirmado frente a borrador en mobile/lib/features/profile/application/profile_controller.dart; fallo conserva confirmado anterior y borrador de esa identidad; cancelar antes de enviar produce cero escrituras. Depende de T005/T006/T009/T013/T014.
- [X] T016 [US1] Completar generaciones, UID, operación única, timeout≤15s y reconciliación en mobile/lib/features/profile/application/profile_controller.dart; descartar respuestas tardías y vaciar datos al invalidar sesión/salir. No afirmar cancelación remota ni habilitar otro guardado antes de resolver/reconciliar el anterior. Depende de T015/T009.
- [X] T017 [P] [US1] Implementar apertura externa mailto mediante url_launcher y copia con Clipboard en mobile/lib/features/profile/data/deletion_contact_service.dart; destinatario fijo priva202611@gmail.com, asunto/cuerpo genéricos escapados, false/excepción con fallback y sin canLaunchUrl obligatorio. Depende de T002/T007/T011; independiente de T013–T016.
- [X] T018 [US1] Añadir sincronización de nombre confirmado protegida por UID en mobile/lib/features/account/application/account_controller.dart y, si hace falta, copia inmutable en mobile/lib/features/account/application/account_state.dart; no alterar identidad, verificación o fase de acceso. Probar que una respuesta antigua no crea sesión ni cambia otra cuenta. Depende de T009/T016.
- [X] T019 [US1] Implementar consulta y editor P12 en mobile/lib/features/profile/presentation/profile_screen.dart usando AccountScaffold, nombre confirmado/correo de lectura, guardar/cancelar y mensajes sanitizados accesibles; sin teléfono, estado de riesgo, fotos, fila vacía o historial. Depende de T010/T015/T016/T018.
- [X] T020 [US1] Inyectar repositorio/servicio y conectar /profile dentro de la guarda existente en mobile/lib/main.dart, mobile/lib/app/priva_app.dart y mobile/lib/app/account_router.dart; preservar destinationBuilder de pruebas y no habilitar otros módulos ni perfiles de otra identidad. Depende de T013–T019.
- [X] T021 [US1] Conectar cierre en mobile/lib/features/profile/presentation/profile_screen.dart y limpieza en mobile/lib/features/profile/application/profile_controller.dart: limpiar local antes de esperar Auth, eliminar historial privado y conservar Tips público aun con error remoto. Reutilizar AccountController.signOut; no prometer cierre global o eliminación. Depende de T016/T019/T020.
- [X] T022 [US1] Integrar explicación, botón de borrador y fallback Copiar correo en mobile/lib/features/profile/presentation/profile_screen.dart; instruir envío desde correo de cuenta y no mostrar solicitud recibida/enviada/borrado. No crear expedientes o datos nuevos. Depende de T017/T019/T021.
- [X] T023 [US1] Ajustar firebase/firestore.rules para update exclusivo name en perfil propio con correo verificado/password/evidencia válida, nombre no vacío/solo espacios y claves afectadas permitidas; mantener create F01, autorización inmutable y denegación de otros datos. Satisfacer T012 sin reglas públicas ni permitir borrar evidencia.
- [X] T024 [US1] Crear mobile/integration_test/profile_account_test.dart para consulta/edición real, cancelación, fallos y cambio de sesión, cierre/retroceso y solicitud sin envío automático; no sustituir servidor/Android por dobles sin declarar alcance. Depende de T020–T023.
- [X] T025 [US1] Ejecutar T008–T011 y regresión de mobile/test/features/account/ y mobile/test/bootstrap_test.dart; corregir conflictos en los archivos responsables antes de avanzar y registrar estados reales en specs/002-perfil-cuenta/validation/local-results.md. Depende de T024; T012 se valida en T028 y cualquier bloqueo de emulador se registra por separado, nunca como aprobado.

**Checkpoint US1:** consulta/edición/cierre/solicitud integradas y pruebas pertinentes
satisfactorias o bloqueo explícito registrado. Este checkpoint no acepta una entrega
con CA incumplido ni autoriza despliegue o avance al003.

## Phase 4: Validación y cierre transversal

- [X] T026 Ejecutar y completar pruebas automáticas de etiquetas, objetivos Android≥48dp, contraste≥4.5:1 normal/≥3:1 grande/componentes y texto200%/teclado en mobile/test/features/profile/profile_accessibility_test.dart; registrar estados de consulta/edición/error/correo en specs/002-perfil-cuenta/validation/accessibility.md. Depende de T025.
- [X] T027 Ejecutar TalkBack, foco, teclado y texto200% en la matriz Android mínima/actual y pequeña/grande y registrar dispositivo/OS/recorridos/defectos/repruebas en specs/002-perfil-cuenta/validation/accessibility.md; no inferir que el reporte del001 cubre P12. Depende de T026/T003. **Evidencia reportada por el usuario (2026-10-30):** la validación se realizó en el emulador. No se proporcionaron identificador/versión del emulador, matriz, recorridos ni defectos/repruebas; esos detalles quedan señalados como no especificados, sin invalidar el reporte de ejecución.
- [X] T028 Validar firebase/tests/profile.test.mjs y reglas por solicitudes directas del entorno autorizado y comparar autorización sintética antes/después de editar en specs/002-perfil-cuenta/validation/firestore.md; preparar publicación de reglas revisadas solo con acceso autorizado y tras validación. La postergación del001 no aprueba la nueva escritura; registrar bloqueos sin abrir permisos. Depende de T023/T025. **Evidencia reportada por el usuario (2026-10-30):** validación de escenarios realizada. Este registro no afirma despliegue de reglas; el intento local fallido anterior se conserva como tal y no contradice una validación posterior reportada.
- [ ] T029 Ejecutar apertura/cancelación real de correo en Android API24/actual, con/sin cliente y fallback/copia, registrando URI sanitizada, dispositivo y resultado en specs/002-perfil-cuenta/validation/mail-contact.md; no enviar mensajes reales automáticamente ni afirmar eliminación. Depende de T022/T025/T003. **Parcial:** el usuario confirma que funcionan las comprobaciones manuales indicadas del contacto; no reporta dispositivo/API ni se ejecutó la matriz Android en este entorno.
- [X] T030 Ejecutar formato/análisis, suite completa y build APK Android con lockfile; registrar comando, hash/versión del artefacto y matriz mínima/actual en specs/002-perfil-cuenta/validation/builds.md; distinguir APK proporcionado por usuario de compilación propia, sin iOS ni bypass de TLS. Depende de T025/T026. **Evidencia reportada por el usuario (2026-10-30):** T030 está completada. La ejecución previa bloqueada de esta sesión se conserva como historial y no representa la validación posterior reportada. Los comandos, hash y matriz no se incluyeron en la confirmación recibida.
- [X] T031 Medir feedback≤1s y respuesta/aviso≤15s con reloj monotónico:20 repeticiones por carga/guardado, perfil de red y dispositivo, incluyendo espera artificial y respuesta tardía; medir apertura/fallback del redactor sin contar entrega de correo. Guardar solo métricas sanitizadas en specs/002-perfil-cuenta/validation/performance.md y pruebas en mobile/integration_test/profile_performance_test.dart. Depende de T027–T030. **Evidencia reportada por el usuario (2026-10-30):** medición realizada. No se han proporcionado al repositorio cifras, perfil de red, dispositivo ni resultados por repetición; se registra explícitamente esa limitación documental.
- [X] T032 Revisar flujos/datos y comprobar que perfil no duplica email ni escribe datos de autorización/cuestionario, y que borrador/copia no filtran datos privados; documentar en specs/002-perfil-cuenta/validation/privacy-review.md. No convertir la solicitud por correo en eliminación automática o cerrar retenciones ajenas por inferencia. Depende de T022/T025/T028/T029. **Evidencia reportada por el usuario (2026-10-30):** revisión y validación completadas.
- [ ] T033 Consolidar RF-02/RF-04→HU-02→CA-02.1–02.19→tareas→pruebas/resultados y SC-02.1–02.5 en specs/002-perfil-cuenta/validation/traceability.md; diferenciar satisfactorio, fallido, no ejecutado, reporte de usuario y aplazado. Depende de T027–T032; no cerrar con mediciones pendientes.
- [ ] T034 Ejecutar specs/002-perfil-cuenta/quickstart.md, actualizar mobile/README.md y firebase/README.md, corregir bloqueantes y registrar revisión final en specs/002-perfil-cuenta/validation/delivery-review.md; hacer commit/push y solicitar aceptación de F02. Depende de T033; no avanzar al003 ni dar por enviada una solicitud de eliminación.

## Dependencies & Execution Order

```text
T001 → T002 + T003 → T004 → T005 + T006 + T007
     → T008 + T009 + T010 + T011 + T012
T008 → T013 → T014 → T015 → T016 → T018 → T019
T002/T007/T011 → T017
T013–T019 → T020 → T021 → T022
T012 → T023
T020–T023 → T024 → T025
T025 → T026 → T027
T023/T025 → T028       T022/T025 → T029
T025/T026 → T030
T027–T030 → T031       T022/T025/T028/T029 → T032
T027–T032 → T033 → T034
```

Las dependencias detalladas de cada tarea prevalecen sobre la simplificación del
diagrama. La generación requiere que estén aprobados spec/plan (cumplido); ejecutar
esta lista requiere su aprobación posterior. Ninguna tarea usa estado futuro como
prerrequisito satisfecho ni considera el timeout una cancelación del proveedor.

## Parallel Example — US1

Tras Foundation, T008/T009/T010/T011/T012 preparan pruebas de archivos distintos.
Después, el servicio de correo T017 puede avanzar junto al adaptador/controlador
T013–T016, una vez cumplidos sus contratos y pruebas. No modificar simultáneamente
el mismo archivo: T013/T014, T015/T016, T019/T021/T022 son secuenciales.

En validación, T027/T028/T029/T030 usan evidencias distintas y pueden programarse
independientemente tras sus prerrequisitos; T031 y consolidación esperan resultados.
Esto describe oportunidades, no promete hardware o autoriza trabajo paralelo de agentes.

## Implementation Strategy y trazabilidad resumida

Un único MVP corresponde a HU-02 completa: datos propios → edición → cierre →
solicitud por correo, con seguridad y accesibilidad. Se puede comprobar cada recorrido
incrementalmente, pero ninguno se declara producto terminado antes de validar el conjunto.

| Alcance / contrato | Tareas principales | Evidencia de aceptación |
| --- | --- | --- |
| C1 / CA-02.1/02.4/02.5/02.8/02.9 | T008–T010,T013,T015–T020 | Consulta real, errores, 2UIDs y ausencia de datos ajenos. |
| C2 / CA-02.6/02.7/02.8/02.9 | T008/T009/T012,T014–T016,T018/T019/T023/T028 | Cancelar/guardar/error/offline/tardía; solo name y evidencia idéntica. |
| C3 / CA-02.2/02.10–02.12 | T009/T010/T016/T020/T021/T024 | Cierre local, retroceso, Tips público y error remoto sin restauración. |
| C4 / CA-02.3/02.13–02.17 | T007/T010/T011/T017/T022/T029 | Apertura/fallback/copia/cancelación; sin envío ni borrado automático. |
| C5 / CA-02.18/02.19 | T026/T027/T030/T031 | Automatización, nativos, texto/teclado y matriz registrada. |
| Privacidad, regresión y SC-02.1–02.5 | T025/T028/T030–T034 | Datos mínimos, resultados reales y trazabilidad final. |

**Resultado de esta generación:**34 tareas,18 de HU-02 ([US1]),7 de Setup/Foundation
y9 de validación/cierre;10 oportunidades [P] señaladas. No se creó código, dependencias,
reglas nuevas ni pruebas ejecutadas. No hay hooks configurados en `.specify/extensions.yml`.

## Registro de autorización y ejecución

El usuario indicó «inicia la implementación» después de las tareas del5611047,
autorizando su ejecución. Se conservan abiertas las8 validaciones finales; ver
validation/current-results.json y delivery-review.md para estados reales. No
modificar el checklist de calidad documental ni afirmar pruebas nativas ejecutadas.
