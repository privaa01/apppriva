# Investigación F03 — Inicio y navegación

**Fecha**: 2026-11-03. **Estado**: decisiones propuestas para aprobar con el plan.
Investigación de solo lectura del repositorio, apoyada por dos agentes de revisión
según la skill `speckit-plan`. No se ejecutaron pruebas ni se verificaron APIs en un
SDK instalado. Las decisiones siguientes resuelven las alternativas de diseño;
no convierten las limitaciones del entorno en resultados satisfactorios.

## R1 — Navegación sin nueva dependencia

**Decisión:** conservar `MaterialApp` y `Navigator`, introducir un catálogo cerrado
de destinos, un coordinador de navegación por aplicación y un historial de rutas
controlado. La guarda se aplica antes de construir cualquier contenido, incluso
cuando se usa el `destinationBuilder` de pruebas. Mantener un único Navigator y el
`RouteObserver<PageRoute<dynamic>>` existente para Perfil.

**Motivo:** `app/account_router.dart`, `app/priva_app.dart` y
`features/account/presentation/account_scaffold.dart` ya implementan esas APIs.
Actualmente cada pulsación hace `pushNamed`, sin selección activa ni deduplicación.
`canOpenDestination` permite rutas desconocidas para sesiones válidas; se debe
separar destino reconocido de acceso autorizado y de precondiciones de resultados.

**Alternativas:** un paquete de rutas o múltiples navegadores persistentes añaden
migración y estado retenido sin necesidad de este alcance. Reemplazar siempre la
ruta elimina el retorno detalle→catálogo; apilar siempre crea bucles. Se elige
push para destino nuevo, popUntil si ya existe en el historial y no-op al reseleccionar.
Las transiciones de acceso limpian la pila; las salidas se consultan antes de mutarla.

## R2 — Permisos e identidad durante operaciones pendientes

**Decisión:** reutilizar la habilitación de `AccountController`, sin reconstruirla
solo desde `FirebaseAuth.currentUser`. Añadir al controlador la revocación si un
evento de sesión corresponde a un UID diferente del que posee el permiso vigente.
Un evento del SDK puede revocar, nunca conceder por sí mismo una identidad nueva.
El coordinador captura UID/generación para cancelar intenciones antiguas.

**Motivo:** el listener actual revoca si `canAccessPrivate` pasa a false, pero no
compara UID cuando recibe otra sesión válida. Las guardas de perfil reducen el
riesgo de acceso a datos, pero no sustituyen invalidar el permiso de navegación.

**Alternativas:** confiar en visibilidad del menú, UID de ruta o solo `emailVerified`
rompe F01. El coordinador no hará consultas propias a Firestore ni cambiará reglas.

## R3 — Salida y ciclo de vida con un contrato temporal

**Decisión:** definir una interfaz mínima de recorrido temporal con estado
idle/attempt/result, posibilidad de pregunta anterior y generación; callbacks para volver una
pregunta y descartar sincrónicamente. No recibe respuestas, puntuación ni resultados.
Producción F03 usa implementación vacía mientras F06/F07 no estén aprobados;
las pruebas inyectan un doble sintético. Al integrar los módulos se sustituirá por
su adaptador real y se repetirán las pruebas conjuntas.

La salida voluntaria del intento consulta un diálogo único; cancelar no muta.
Abandonar resultado descarta sin confirmación adicional. Pérdida/cambio de sesión
invalida el diálogo y descarta antes de permitir otra vista. El ciclo de vida se
observa en la raíz: en `hidden`, `paused` o `detached`, descarte idempotente; en
`inactive` se cubre temporalmente contenido sensible, pero no se interpreta por sí
solo como abandono, pues un diálogo del sistema puede causar ese estado. En
`resumed` no se restaura contenido descartado. La muerte de proceso no garantiza
callback: la ausencia de persistencia evita restauración al relanzar.

**Alternativas:** guardar el historial o restaurar respuestas con estado de Android
viola la constitución. Implementar preguntas/score en F03 excede alcance. PD-10 de
red en primer plano permanece fuera de este contrato.

## R4 — Integración de Perfil

**Decisión:** un guard de salida local distingue permitir/bloquear por guardado
pendiente; lo consulta el coordinador para cabecera, menú y retroceso, no solo el
`PopScope`. Invalidación de identidad y cierre forzado prevalecen. Conservar observer,
`activate/deactivate`, generation, unknown/reconcile y la limpieza de borrador de F02.

**Motivo:** el `PopScope` de Perfil bloquea pop durante saving, pero no `pushNamed`.
Una salida de sección no debe evadir su contrato ni prometer cancelar la transacción.
No duplicar el controlador ni crear otra fuente de datos de Perfil.

## R5 — Accesibilidad, medición y evidencia

**Decisión:** reutilizar paleta y presupuestos F01/F02; 48dp de objetivo táctil,
contraste 4.5:1 normal/3:1 grande y componentes significativos, texto100%/200%, TalkBack.
Proponer API24 y API36, 320×720 y 412×915 dp, documentando imagen/modelo real.
Si el SDK fijado no admite esa combinación, resolver la compatibilidad antes de
implementar sin elevar silenciosamente el mínimo. No se promete todos los dispositivos.

Proponer prueba formativa de 5 personas de 40–65 años con 6 tareas por persona;
meta 21/30 completadas sin ayuda, además de pruebas negativas que no dependen del
porcentaje. Las seis tareas usan Inicio y Tips como navegación, sin evaluar contenido
no entregado; se describen en `quickstart.md`. No se recoge nombre, correo, audio,
video, respuestas ni resultado. ID efímero P1–P5, rango etario de elegibilidad sin
fecha de nacimiento, resultado y duración monotónica de la tarea. Si no hay
participantes, se registra pendiente, no se sustituye por agentes ni pruebas widget.

**Alternativas:** inferir usabilidad de una prueba de TalkBack o de un único usuario
no demuestra SC-03.5. Inventar un porcentaje o almacenar capturas de respuestas no
es evidencia válida. La muestra es formativa, no representatividad estadística.

## Fuentes y límites de la comprobación

- Código y tests existentes en `mobile/lib/app/`, `features/account/`,
  `features/profile/` y `mobile/test/features/` (baseline `d8c4a55`).
- `mobile/pubspec.yaml` y lockfile: Flutter/Dart documentados, Firebase y
  url_launcher fijados; ninguna dependencia nueva propuesta.
- `spec.md`, constitución, original §§5/12/15 y plan F02 aprobado.
- Entorno observado: Docker y Java existen; Flutter/Dart no están en PATH y
  `/workspace/.tools` no existe. No se deduce que la prueba o el build sean imposibles
  en la etapa siguiente; es necesario preparar/verificar toolchain antes de ejecutar.
- Ningún cambio de Firestore, despliegue, lectura de cuentas reales o servicio externo.
