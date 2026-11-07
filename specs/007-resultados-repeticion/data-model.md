# Modelo de datos y estados — F07

Todos los modelos son inmutables, efímeros y no serializables.

## ResultAssessment

| Campo | Regla |
| --- | --- |
| totalPoints | Entero 0–1000; suma de diez porcentajes |
| displayPercent | `totalPoints / 10`; entero o una décima |
| level | `low` si total<200; `medium` si total<600; `high` en otro caso |
| priorities | Exactamente tres `ModuleAssessment`, ordenadas |
| generation | Generación del intento; impide aplicar resultados tardíos |

No conserva UID, correo, nombre ni copia adicional de selecciones.

## ModuleAssessment

| Campo | Regla |
| --- | --- |
| topic | Uno de los cinco `QuestionTopic` |
| points | Suma entera de las dos respuestas, 0–200 |
| actions | Tres textos del catálogo aprobado para el topic |
| tieOrder | Orden fijo del enum, usado solo en empates |

## ResultRecommendationCatalog

`schemaVersion=1`, `contentVersion=result-recommendations-es-CO-1.0.0`,
`status=approved`, `reviewedOn=2026-11-07`; cinco módulos exactos, tres acciones no
vacías por módulo y sin campos adicionales. Se cachea solo en RAM.

## Estados de P09

`loading → ready | error`; `error → loading` mediante reintento. `ready → restarting`
mediante Repetir. Cualquier salida/background/logout/cambio UID/dispose → descartado.
Una generación anterior no actualiza el estado.

```text
CompletedAttempt RAM → ResultCalculator → ResultAssessment RAM
Catálogo asset ─────────────────────────→ acciones RAM → P09
P09 repetir → discard → F06.start → P08
salida/lifecycle/sesión ────────────────→ discard total
```
