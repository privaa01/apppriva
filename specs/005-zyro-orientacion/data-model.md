# Modelo de datos y estados — F05 Zyro

## Conversation

Memoria de proceso asociada a `ownerUid`: `generation`, mensajes ordenados,
solicitud pendiente y estado de pantalla. Nunca serializable. Transiciones:

```text
idle → sending → ready | limit | error
error → sending (retry)
route exit → retained messages + invalidate pending
logout/UID change/account deletion/process end → discarded
```

Máximo contexto enviado:8 mensajes/6000 caracteres. La interfaz puede conservar más
mensajes visibles dentro del límite de memoria que fije la implementación, pero
solo el contexto acotado y necesario cruza la red.

## ZyroMessage

| Campo | Regla |
| --- | --- |
| `localId` | UUID en memoria; no se registra |
| `role` | `user|zyro|status` |
| `text` | plano, no vacío, máximo1000 entrada |
| `kind` | `general|guide|limit|error` |
| `steps` |0–6 textos; sin URL/acción |
| `guideId/revision` | solo para guía fija |
| `requestId` | correlación en memoria; igual en retry |

## CallableRequest/Response

Request: `schemaVersion=1`, requestId UUID, message≤1000 y contexto≤8/6000.
Response: mismo requestId, `kind`, texto,0–6 pasos, metadatos de guía opcionales,
`retryable` y versión de política. Campos extra/tipos inválidos se rechazan.

## VerifiedGuide

`guideId`, plataforma `instagram|facebook|google`, acción exacta, superficie
`android|web|accounts-center`, revisión, estado, pasos, consecuencias, fuente,
fecha de revisión y responsable. Solo `vigente` y versión aprobada puede servirse.

## RateWindow

Documento administrativo `zyro_rate_limits/{uid}`: `windowStartedAt`,
`requestCount`, `expiresAt`. Sin mensaje, correo, IP, resultado o contexto.
Solo servidor; TTL≤24h. La aplicación no puede leer/listar/escribir.

## PolicyDecision

Resultado efímero `allowGeneral|serveGuide|limitSensitive|limitHarmful|
limitOutOfScope|limitUnverified`. No se persiste. La posvalidación puede convertir
cualquier respuesta en `limitUnverified`, nunca en una autorización mayor.
