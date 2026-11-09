# Modelo de datos y estados — F06

Todos los objetos de intento son efímeros, no serializables y nunca se escriben.

## QuestionBank

`schemaVersion=2`, `contentVersion=question-bank-es-CO-2.0.1`, `status=approved`, fecha y
67 `Question`. Validación atómica: campos exactos, IDs únicos, cinco módulos cerrados,
67 activas y ningún texto obligatorio vacío.

## Question

| Campo | Regla |
| --- | --- |
| id | Q001–Q067 estable y único |
| version | Entero1 |
| topic | passwords, access, networks, phishing o devices |
| prompt | Texto aprobado no vacío |
| options | Exactamente3 `QuestionOption` con IDs A/B/C únicos |
| options | Cada opción incluye `vulnerabilityPercent`, entero entre 0 y 100; no se muestra en P08 |
| sourceIds | Lista no vacía con referencia al PDF aprobado |
| reviewedOn/status | 2026-11-09 y `approved` |

## ActiveAttempt

`generation`, `ownerUid` solo para aislamiento en memoria, lista fija de10 preguntas,
índice0–9 y mapa `questionId→selectedOptionId`. Invariantes: diez IDs únicos,
cobertura de cinco módulos, exactamente dos por módulo y opciones pertenecientes.

## AttemptQuestion y CompletedAttempt

`AttemptQuestion` referencia `Question` y option IDs reordenados; cada porcentaje permanece unido a su opción. `CompletedAttempt` es snapshot inmutable en RAM con diez preguntas y diez
selecciones, disponible solo con generación/sesión vigente. F07 podrá leerlo; F06
no calcula resultado. Se elimina junto con el intento.

## QuestionnaireState

Fases: `idle`, `loading`, `active`, `paused`, `error`, `completed`. Incluye generación,
índice, error seguro y conectividad; solo active/paused/completed referencian intento.

```text
idle → loading → active
loading → error | active
active ↔ active (selección/revisión)
active → paused → active
active → completed
error → loading
active|paused|completed → idle (salida/background/logout/dispose)
```

Eventos de generaciones anteriores no cambian estado. Background descarta incluso
si estaba pausado; cancelar salida conserva.

```text
Asset APK → validación → selección/mezcla → RAM → P08
                                      └→ CompletedAttempt RAM → F07 futuro
Conectividad → pausa; nunca recibe contenido
Lifecycle/sesión/navegación → discard → referencias eliminadas
```
