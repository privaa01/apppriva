# Revisión de entrega F03 — aceptada con limitaciones documentadas

Implementación autorizada por «apruebo» sobre2cd833f. Checklist documental16/16
con marcadores intactos. Sin hooks before/after_implement: no existe extensions.yml.

## Trabajo terminado y verificado

- P01 con textos educativos aprobados y tres tarjetas; cinco controles comunes
  con selección visual/semántica, Tips público y P11 preservado.
- Catálogo cerrado, guardas anteriores al builder y precondición de resultados;
  revocación UID y limpieza de historial privado sin conceder permisos por stream.
- Historial sin duplicados, detalle Tips con padre, guardado Perfil protegido y
  conservación de observer/reconciliación; contratos temporales y ciclo de vida.
-124 pruebas locales satisfactorias,0 fallidas; análisis0 diagnósticos.
- APK Android debug compilado, hash y metadata en builds.md/current-results.json.
- Runners nativos/rendimiento preparados; producción usa puerto vacío hasta F06/F07.
  No se entrega cuestionario real, preguntas o puntuación en este spec.

## Controles abiertos —8 tareas

T027: APK listo; falta instalación/matriz. T028: ejecución Android y ciclo de vida
real. T030: automatización accesible pasó, faltan TalkBack/foco nativo. T031:
mediciones con20 muestras por escenario/configuración. T032:5 participantes,
30 oportunidades y meta21/30. T033: inspección nativa de privacidad/tráfico. T034:
consolidación final dependiente de esas evidencias. T035: guía completa y revisión/
aceptación final; commit/push de esta entrega parcial no cierra esa tarea.

No hay Android físico/AVD ni participantes disponibles. adb requiere una carpeta
de solo lectura del host; HOME no se modificó. Las pruebas sintéticas no sustituyen
la matriz real, el estudio de uso o integración futura F06/F07. No hay muestras
nativas ni datos de participantes; no se inventaron resultados.

Estado:27/35 tareas completadas, entrega funcional local, **sin aceptación final**.
Se sincronizan código y evidencias para revisión, sin avanzar a F04 ni presentar
F03 como cerrado. Los pendientes conservan sus condiciones de cierre explícitas.

## Seguimiento — 2026-11-04

Nueva incidencia de acceso: ver [investigación y validación](signin-incident-2026-11-04.md).
La suite actual tiene129 pruebas satisfactorias, análisis0 y un nuevo APK debug;
los resultados anteriores se conservan como historial. La causa real del fallo
reportado sigue pendiente de clasificación desde el dispositivo afectado. El hash
y artefacto vigentes están en current-results.json; el binario de la compilación
anterior ha sido reemplazado localmente, sin representar una aceptación nativa.

## Confirmación funcional posterior — 2026-11-04

El usuario confirmó que ya inicia sesión y que la navegación del003 se ve y funciona.
La incidencia AC-05 queda resuelta según ese reporte; los pendientes anteriores
de comprobar acceso real son históricos. Ver [alcance de la confirmación](user-reported-manual.md).
No constituye observación independiente, matriz Android completa, TalkBack, medición
de rendimiento, estudio de usabilidad ni aceptación final de F03.

## Corrección de conservación de sesión — 2026-11-04

Se implementó restauración de Firebase Auth validada contra servidor y conservación
de concesión previa ante errores de red transitorios, sin restaurar cuestionario.
135 pruebas locales, análisis0, APK nuevo. Ver [incidencia](session-background-2026-11-04.md).
Falta confirmar en Android real;27/35 tareas y aceptación pendiente sin cambios.

## Cierre posterior — 2026-11-04

El usuario confirmó conservación de sesión y aprobó cerrar F03. Ver
[aceptación y limitaciones](closure-2026-11-04.md):29 tareas completadas,6 parciales/
aplazadas. Los pendientes anteriores describen el estado histórico; no se convierten
en resultados satisfactorios. Se preservan los límites de la evidencia ejecutada.
