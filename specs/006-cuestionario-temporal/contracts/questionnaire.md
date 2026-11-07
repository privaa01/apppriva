# Contratos F06 — cuestionario temporal

## C-Q06-01 — Banco local

El repositorio carga `questionnaire-1.0.0.json`, valida el banco completo y devuelve
contenido aprobado o `invalid/unavailable`. Rechaza parcial, versión desconocida,
IDs repetidos, clave ausente, campos extra o menos de30 entradas. No registra contenido.

## C-Q06-02 — Creación del intento

`start(ownerUid)` exige sesión válida, banco y conectividad. Produce diez preguntas
distintas, siete temas y máximo dos por tema; mezcla conservando IDs. Una fuente
aleatoria inyectada permite pruebas. Solicitudes concurrentes no crean dos intentos.

## C-Q06-03 — Respuesta y revisión

`select(questionId, optionId)` acepta solo pregunta visible/opción perteneciente y
reemplaza selección. `next()` no avanza sin selección; `previous()` revisa. No revela
clave/explicación. En índice9, completar exige diez selecciones y crea snapshot RAM.

## C-Q06-04 — Temporalidad

`discard(reason)` elimina intento/snapshot y aumenta generación para exit, background,
session y dispose. Cancelar salida conserva. Sin serialización, restoration,
preferencias, archivos, Firestore, analítica, crash bodies o logs.

## C-Q06-05 — Conectividad

El puerto solo expone available/unavailable. Unavailable pausa en primer plano,
conserva RAM y bloquea Continuar; recuperar reanuda sin reordenar. Background descarta.
El adaptador no recibe preguntas, selecciones, UID o resultado.

## C-Q06-06 — P08 y acceso

Visitante/no verificado reciben acceso requerido antes de cargar banco. Sesión válida
ve aviso y Comenzar. P08 muestra progreso, enunciado, tres opciones y Continuar/Ver
resultado. Loading, error, banco inválido y pausa son anunciados y recuperables.

## C-Q06-07 — Accesibilidad

Texto100/200%,320×720/412×915, API24/API36, controles≥48dp, contraste4.5:1 normal y
3:1 grande/controles. TalkBack anuncia encabezado, progreso, grupo, opción/selección,
pausa, error y acciones. Pruebas humanas guardan solo conteos agregados.
