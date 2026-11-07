# Data Model: F05 — Asistente Zyro local

F05 no define entidades persistentes.

## ZyroMessage

- `role`: usuario o Zyro.
- `text`: texto visible, máximo de entrada 300 caracteres.
- Ciclo de vida: memoria de la pantalla; se elimina al salir.

## ZyroReply

- `text`: respuesta aprobada incluida en la aplicación.
- `kind`: `guidance`, `unverified`, `sensitive` o `refused`.

## GuideTopic

- Frases normalizadas que activan una respuesta.
- Contenido determinista y probado.
- No contiene URL, credenciales ni acciones externas.

## Estados de pantalla

1. Inicial: presentación, aviso y consultas rápidas.
2. Conversación: mensajes de la sesión actual.
3. Límite: respuesta no verificada, sensible o rechazada.
4. Destruido: al abandonar P07 no queda estado recuperable.

