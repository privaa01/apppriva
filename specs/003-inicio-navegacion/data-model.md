# Modelo de datos F03 — estado transitorio

**Estado**: propuesto con el plan; sin colecciones, esquemas remotos o migraciones.
No introduce tratamiento de respuestas/resultados ni cambia conservación de cuenta.

## Entidades y propiedad

| Entidad | Campos / relaciones | Validación y vida |
| --- | --- | --- |
| Destination | path canónico, section opcional, access(public/entry/private), available, requiresResult | Catálogo cerrado, sin UID ni parámetros personales; detalles Tips→Tips, Resultados→Cuestionario |
| NavigationState | destino visible, historial reconocido, generation, pendingIntent opcional | Memoria por app, sincronizada con Navigator; sin copiar payload de vistas |
| AccessSnapshot | UID vigente opcional, habilitación de AccountController, generación capturada | Solo comparación de contexto, nunca concede permisos ni persiste UID en historial |
| NavigationIntent | destino conocido o back, generation y contexto capturados | Una intención pendiente; invalidar al cambiar sesión, recorrido o ciclo de vida |
| ExitDecision | allow, blockSaving, confirmDiscard, previousQuestion | Decisión efímera; ningún resultado del diálogo supera guardas de acceso |
| TemporaryJourney | fase idle/attempt/result, canPrevious, generation | Puerto sin respuestas ni score; producción vacío hasta integración F06/F07 |
| ProfileExitGuard | allow o blockSaving para la vista activa | Consulta local a F02; unknown permite salir, no cancela escritura remota |

El coordinador posee navegación, no datos de Perfil ni respuestas. El adaptador
F06/F07 futuro posee el contenido temporal y lo destruye al descartar; exponer su
fase no autoriza guardar contenido, incluirlo en rutas o usarlo para analítica.
En F03 el doble de pruebas solo representa estado sintético, no un banco aprobado.

## Transiciones

| Estado/evento | Resultado obligatorio |
| --- | --- |
| Ruta actual reseleccionada | No-op, sin duplicado ni nuevo diálogo |
| Destino reconocido y permitido | Consultar salida; luego push o retorno a entrada existente |
| Desconocido | Estado seguro con acción pública/permitida, nunca builder arbitrario |
| Protegido sin concesión válida | Acceso requerido, sin render privado; Tips disponible |
| UID distinto o permiso perdido | Invalidar intenciones, descartar puerto, ocultar privado y retirar historial privado |
| Back en intento con anterior | previousQuestion; sin salir ni persistir |
| Salida de intento → cancelar | Misma fase/generación/contenido temporal, cero navegación |
| Salida de intento → confirmar vigente | discard y generación nueva antes de salir |
| Salida de resultado | discard; cualquier ruta antigua a resultados falla su precondición |
| hidden/paused/detached/dispose | discard idempotente e invalidar confirmaciones pendientes |
| inactive | Cubrir contenido sensible; si luego hay hidden/paused se descarta |
| resumed tras descarte | Puerto idle, no restaurar; no cerrar sesión por ese evento |
| Perfil saving → salida voluntaria | Bloqueada con aviso; no cancelación remota |
| Perfil unknown → salida | Permitida conforme a F02; respuesta tardía no restaura vista |

`discard` es sincrónico e idempotente: incremento de generación e invalidación del
estado antes de notificar. Tras muerte de proceso no se depende de este callback;
la instancia nueva empieza idle y no tiene archivos/estado restaurable del intento.

## Prohibiciones y revisión de datos

No crear tablas de navegación, documentos Firestore, preferencias de historial,
rutas con respuestas, crash breadcrumbs de contenido o restauración del intento.
No enviar datos de cuestionario a IA. Errores públicos no incluyen UID, correo,
path bruto, credenciales ni contenido temporal. Evidencia solo de escenarios,
conteos, duraciones y estados sintéticos; no volcar objetos en logs. La evidencia de
usabilidad se conserva agregada y sin identificación según la guía; no establece
plazos legales ni cambia finalidades o política de datos de cuenta.
