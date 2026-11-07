# Implementation Plan: F07 — Resultados orientativos y repetición

**Branch:** `work` | **Date:** 2026-11-07 | **Spec:** [spec.md](spec.md)
**Selección:** `SPECIFY_FEATURE_DIRECTORY=specs/007-resultados-repeticion`
**Estado:** plan aprobado explícitamente por el responsable el 2026-11-07; tareas pendientes de aprobación.

## Summary

Convertir el `CompletedAttempt` temporal de F06 en un resultado orientativo local:
promedio exacto de diez porcentajes, nivel bajo/medio/alto, tres módulos prioritarios
y acciones editoriales revisadas. P09 consume y conserva todo solo en RAM. Repetir
descarta el snapshot anterior y solicita a F06 un intento nuevo. No se añade backend,
IA, telemetría, almacenamiento ni dependencia de cálculo.

## Technical Context

| Campo | Decisión |
| --- | --- |
| Language/Version | Flutter 3.47.8 y Dart 3.13.7 vigentes; conservar pins. |
| Primary Dependencies | Flutter Material, Navigator y ChangeNotifier existentes; ninguna dependencia nueva. |
| Storage | Asset editorial local `result-recommendations-1.0.0.json`; intento, cálculo y resultado exclusivamente en objetos Dart en RAM. |
| Testing | Unitarias de fórmula/fronteras/empates; widgets P09; navegación, ciclo de vida y privacidad; integración Android sintética. |
| Target Platform | Android API 24/API 36; 320×720 y 412×915 dp; texto 100/200 %; TalkBack. |
| Project Type | Extensión del módulo Flutter `features/questionnaire`; sin servicio externo. |
| Performance Goals | Cálculo y feedback local ≤1 s; carga/error de asset ≤15 s; 20 ciclos sintéticos. |
| Constraints | Exactamente diez respuestas; promedio con precisión de décima; clasificación exacta; cero persistencia/envío/logs; resultado protegido por sesión. |
| Scale/Scope | P09, un cálculo, tres módulos de cinco, catálogo de 15 acciones y transición Repetir→P08. |

## Constitution Check

**Puerta previa:** aprobada para planificar. El spec y catálogo fueron aprobados el
2026-11-07. F06 está cerrado. El plan fue aprobado por separado el 2026-11-07;
todavía no autoriza la implementación sin aprobar las tareas.

| Principio | Control del plan |
| --- | --- |
| I — fuente de verdad | RF-12–15 y CA-07.1–5 se trazan a fórmula, contrato, tareas y pruebas; no se reutiliza la fórmula histórica. |
| II — privacidad | No se incorporan datos personales, destinatarios ni proveedores; el resultado no sale del proceso. |
| III — sin persistencia | Modelos no serializables; sin preferences, archivos de estado, Firestore, analítica, crash bodies ni IA; descarte por salida/background/logout/dispose. |
| IV — Zyro | Ninguna llamada o contenido generado por Zyro. |
| V — accesibilidad | Porcentaje y nivel textuales, no solo color; scroll, texto 200 %, controles ≥48 dp, foco y TalkBack. |
| VI — calidad/seguridad | Guarda de sesión/resultados existente; cálculo entero verificable, asset estricto, errores seguros, doble toque bloqueado. |
| VII — trazabilidad | Valores frontera, empates, módulos, repetición y descartes tienen pruebas identificables. |
| VIII — simplicidad | Funciones puras y un asset local; no se añade paquete ni capa remota. |
| IX — etapas | El plan se sincroniza y requiere aprobación antes de `$speckit-tasks`. |

**Revisión posterior al diseño:** pasa. Los contratos conservan la frontera F06/F07,
el modelo calcula con sumas enteras y los artefactos prohíben persistencia. No quedan
`NEEDS CLARIFICATION`. La evidencia física/humana pertenece a validación posterior.

## Project Structure

```text
specs/007-resultados-repeticion/
├── spec.md
├── catalogo-recomendaciones.md
├── plan.md
├── research.md
├── data-model.md
├── contracts/results.md
├── quickstart.md
└── checklists/requirements.md

mobile/assets/content/result-recommendations-1.0.0.json
mobile/lib/features/questionnaire/
├── domain/question_bank.dart                 # CompletedAttempt existente
├── domain/result_assessment.dart             # resultado y módulos inmutables
├── domain/result_calculator.dart              # fórmula y orden determinista
├── data/result_recommendation_repository.dart # puerto de solo lectura
├── data/bundled_result_recommendation_repository.dart
├── application/questionnaire_controller.dart # repetir/descarte coordinado
└── presentation/result_screen.dart            # P09
mobile/test/features/questionnaire/
mobile/integration_test/result_test.dart
```

`PrivaApp` compone el repositorio local. `AccountRouter` resuelve `/results` solo si
`NavigationController.hasResult` es verdadero y entrega el mismo
`QuestionnaireController`; no se copia el snapshot a argumentos de ruta.

## Diseño

### Cálculo exacto

`ResultCalculator` recibe únicamente un `CompletedAttempt` válido. Obtiene el
porcentaje de cada selección buscando el option ID dentro de su propia pregunta.
Suma diez enteros (`totalPoints`, 0–1000). El valor mostrado es `totalPoints / 10`;
la clasificación evita errores de punto flotante: suma <200 bajo, suma <600 medio,
resto alto. Formatea entero si termina en cero y una décima en otro caso.

Para cada módulo suma sus dos valores y conserva `modulePoints` (0–200). Ordena de
mayor a menor. Empates usan el orden enum aprobado. Los tres primeros reciben las
acciones del catálogo por ID de módulo. No se modifica ni duplica el intento.

### Catálogo editorial

El asset local exige versión, estado aprobado, cinco módulos exactos y tres acciones
no vacías por módulo. Se carga de forma atómica y se cachea solo en RAM. Un catálogo
inválido muestra error recuperable y nunca un resultado parcial o recomendaciones
inventadas. El cálculo puede probarse sin el asset; P09 se considera listo únicamente
cuando ambos están disponibles.

### Estado, navegación y repetición

P09 deriva su estado del mismo `QuestionnaireController`: sin `JourneyPhase.result`
la guarda impide acceso. Al entrar calcula una vez por generación y carga el catálogo.
Eventos tardíos se rechazan por generación. Salir de P09, background, logout, cambio
de UID o dispose usa el descarte F03/F06 y elimina intento, cálculo y referencias.

Repetir bloquea doble toque, descarta el resultado, llama `start()` y reemplaza/navega
a `/questionnaire`. Si el nuevo inicio falla, P08 muestra su error recuperable; nunca
restaura el resultado anterior. Preguntas coincidentes entre intentos son válidas.

### P09 y accesibilidad

Mostrar «Resultado orientativo», porcentaje, nivel textual, explicación sencilla,
aviso obligatorio, tres tarjetas de módulos prioritarios con tres acciones cada una
y «Repetir cuestionario». No mostrar las diez selecciones ni afirmar diagnóstico,
probabilidad o protección. Nivel usa texto e icono además del color.

Usar `AccountScaffold`, scroll y tema vigentes. Encabezados semánticos, porcentaje y
nivel en una frase, listas comprensibles, orden de foco visual, objetivos ≥48 dp,
contraste 4.5:1 normal/3:1 grande y texto 200 % sin ocultar acciones.

## Riesgos y validación

| Riesgo | Control |
| --- | --- |
| Promedio o frontera incorrectos | Pruebas por suma entera: 0, 19/19.5, 20, 59/59.5, 60 y 100. |
| Porcentaje separado de su opción | Resolver dentro de la pregunta y probar opciones mezcladas. |
| Empates no deterministas | Orden enum fijo y permutaciones de módulos en pruebas. |
| Recomendación parcial/inventada | Validación atómica del catálogo; error seguro y reintento. |
| Resultado restaurado | Pruebas negativas de rutas, background, logout, dispose, proceso y storage. |
| Doble repetición | Estado pending/generación; una sola creación de intento. |
| Mensaje interpretado como garantía | Revisión editorial y prueba de textos/semántica. |

La validación final incluye análisis, suite Flutter, Functions/reglas sin regresión,
APK Android, auditoría de almacenamiento/logs/tráfico, matriz de pantalla/API,
TalkBack y comprensión con personas de 40–65 años, conservando solo agregados.

## Complexity Tracking

No hay violaciones. Separar cálculo puro, lectura editorial y presentación permite
probar las reglas sin acoplarlas a Flutter o al asset y no añade infraestructura.
