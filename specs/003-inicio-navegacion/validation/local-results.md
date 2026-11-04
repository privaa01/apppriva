# Resultados locales F03 — 2026-11-03

Baseline nuevo:103 pruebas satisfactorias,0 diagnósticos (baseline.md).
Tras preparar contratos compilables se ejecutaron dos regresiones contra el
comportamiento anterior/stub: cambio de UID válido y decisión de salida temporal.
Ambas fallaron funcionalmente (9 pruebas adicionales pasaron en esa ejecución),
sin atribuir a un import/SDK ausente un resultado RED.

Se implementaron catálogo cerrado, política de acceso, historial idempotente,
Inicio, guard de Perfil, contratos de intento/resultado y ciclo de vida. Las
regresiones localizaron y permitieron corregir selección semántica separada del
botón, overflow con texto200% y cierre de diálogo tras reanudar. Se conserva el
baseline F01/F02 y se añadió regresión de revocación por UID al archivo de cuenta.

La ejecución final y su recuento se registran en current-results.json y en la
revisión de entrega, sin trasladar las103 del baseline como única evidencia nueva.
Análisis mediante mobile/tool/analyze.sh con Flutter/PUB_CACHE de /tmp y contenedor
Ubuntu fijado por digest, sin red; el análisis directo en host no puede crear
/home/agent/.dartServer. No se modificó HOME ni se deshabilitó una regla del analizador.

Cobertura nueva: todos los destinos por visitante/no verificado/validado antes del
builder; desconocidos y resultados sin precondición; P01,20 reselecciones/A→B→A,
entrada directa a detalle Tips y padre catálogo; guardado Perfil; salida cancelada/
confirmada, pregunta anterior por back, resultado sin restauración, invalidación de
sesión con diálogo pendiente y eventos sintéticos de ciclo de vida. Es cobertura
local y de contratos, no prueba de Android físico ni de cuestionarios reales.

Resultado final: **124 pruebas satisfactorias**,0 fallidas (103 baseline +21
regresiones/casos F03, incluida la revocación UID en cuenta), análisis **0 diagnósticos**.
Comandos flutter test --no-pub y analizador Docker descrito arriba, ambos exit0.
Logs de trabajo: /tmp/priva-f03-complete-tests.log y
/tmp/priva-f03-complete-analysis.log. No se modificó código tras estas validaciones.

## Seguimiento — 2026-11-04

Nueva incidencia de acceso: ver [investigación y validación](signin-incident-2026-11-04.md).
La suite actual tiene129 pruebas satisfactorias, análisis0 y un nuevo APK debug;
los resultados anteriores se conservan como historial. La causa real del fallo
reportado sigue pendiente de clasificación desde el dispositivo afectado. El hash
y artefacto vigentes están en current-results.json; el binario de la compilación
anterior ha sido reemplazado localmente, sin representar una aceptación nativa.
