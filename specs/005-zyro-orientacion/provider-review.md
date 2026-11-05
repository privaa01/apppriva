# Revisión de proveedor y flujo de datos — F05

**Estado**: revisión de proveedor aprobada; configuración del proyecto pendiente de T004.

## Intento de ejecución T002 — 2026-11-05

Se intentaron las páginas oficiales de callable Functions, App Check, gobierno de
datos y ubicaciones de Vertex AI con acceso de red autorizado y TLS verificado. El
proxy del entorno devolvió HTTP403. No se confirmó modelo, región, entrenamiento,
retención, eliminación, términos o Logging. Todos los controles siguientes permanecen
sin marcar y T002 continúa pendiente.

## Flujo propuesto

```text
P07 (memoria) → callable Firebase → router/catálogo
                                ├─ guía fija → P07
                                └─ consulta general → Vertex AI → posfiltro → P07
                       ↘ contador TTL sin texto
```

| Sistema | Datos | Finalidad | Persistencia propuesta |
| --- | --- | --- | --- |
| App Android | mensaje/contexto y UID de sesión | conversación activa | RAM; hasta descarte de sesión/proceso |
| Callable | Auth/AppCheck, mensaje/contexto, requestId | autorizar, enrutar y responder | procesamiento transitorio; no cuerpos en logs |
| Vertex AI | mensaje/contexto general acotado | generar orientación general | por verificar contractualmente |
| Firestore | UID, ventana, contador, expiración | limitar abuso | TTL≤24h; sin texto |
| Cloud Logging | código, latencia, política, requestId | operación/errores | retención real por verificar |

No se envían nombre, correo, perfil, evidencia completa, respuestas/resultados del
cuestionario, archivos o permisos. La función usa UID solo para autorización/cuota.

## Decisiones aprobadas

- [x] Modelo `gemini-3.5-flash-lite` y endpoint regional
  `us-central1-aiplatform.googleapis.com` fijados.
- [x] Function y modelo en `us-central1`; se registra transmisión desde Colombia
  hacia Estados Unidos y no se usa fallback global silencioso.
- [x] Restricción de entrenamiento documentada: Google no usa datos para entrenar
  o ajustar modelos sin permiso o instrucción previa, según la fuente oficial.
- [x] Retención documentada sin afirmar retención cero: se excluyen grounding,
  Interactions con almacenamiento, caché y logging de request/response; pueden
  aplicar controles de abuso y condiciones del servicio.
- [x] Logging aprobado sin cuerpos, UID ni correo; registros propios sanitizados
  con retención objetivo de 7 días. T004 verificará buckets, sinks y registros
  obligatorios reales antes de habilitar el servicio.
- [x] Eliminación documentada: no se persisten conversaciones; el contador expira
  en ≤24h y las condiciones del proveedor prevalecen para registros obligatorios.
- [x] Se identificaron el acuerdo de procesamiento y términos de Google Cloud; el
  usuario responsable del proyecto aprobó esta configuración el 2026-11-05.
- [x] El usuario se declaró responsable de facturación; presupuesto y alertas son
  obligatorios antes de pruebas hospedadas y se verificarán en T004.
- [x] Finalidad y TTL del contador técnico aprobados e incorporados al inventario.

La aprobación configura el diseño técnico y el tratamiento propuesto; no declara
cumplimiento jurídico general. T004 debe verificar que el proyecto real materializa
estas decisiones antes de enviar mensajes al proveedor.

## Controles técnicos

- Cuenta de servicio con IAM mínimo para invocar Vertex y operar contador.
- Play Integrity en producción y `enforceAppCheck: true`; debug solo test.
- Secretos y prompts de sistema fuera de APK y repositorio público cuando proceda.
- Exclusión explícita de request/response en logs, errores y trazas.
- Prueba con mensajes sintéticos e inspección de Firestore/Logging/tráfico.

## Reanudación T002 — 2026-11-05

Autorización del usuario: «okey, continua con las siguientes tareas». Permite
continuar la investigación; no acredita aceptación contractual, facturación ni
comprobaciones de consola. La aprobación del PDF corresponde a las guías, no a
este proveedor.

El proxy del executor continúa sin conectar (curl7/HTTP000); `git fetch origin`
también falla. Se pudo consultar documentación pública mediante la herramienta
de navegación. Esta consulta resuelve parte de la falta de fuentes, pero no
verifica la configuración de una cuenta Google Cloud.

### Evidencia documental consultada

Consulta: 2026-11-05, responsable de investigación: Codex.

| Fuente oficial | Hallazgo y límite |
| --- | --- |
| [Gobierno de datos](https://cloud.google.com/vertex-ai/generative-ai/docs/data-governance) | Redirige a documentación de Gemini Enterprise Agent Platform. Indica restricción de entrenamiento sin permiso o instrucción previa. Describe excepciones de retención por supervisión de abuso y funciones opcionales; no acredita retención cero para Priva. Debe verificarse aplicabilidad al modelo/contrato elegido. |
| [Ubicaciones y endpoints](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations) | Distingue endpoints regionales, multirregionales y global. Advierte que elegir endpoint no garantiza por sí solo residencia/procesamiento regional. Hace falta seleccionar modelo y comprobar sus condiciones de residencia. |
| [Cloud Data Processing Addendum](https://cloud.google.com/terms/data-processing-addendum) | Documento contractual público identificado. Leerlo no prueba aceptación por el titular ni establece el tratamiento internacional aplicable a Priva. |
| [Cloud Logging: rutas](https://cloud.google.com/logging/docs/storage) | Los sinks pueden enviar registros a buckets y otros destinos. Se deben inspeccionar destinos, retenciones y permisos reales, además del código que produce registros. |
| [Callable Functions](https://firebase.google.com/docs/functions/callable) | Fuente técnica localizada para el contrato callable; no sustituye validación explícita de autorización del proyecto. |
| [App Check para Functions](https://firebase.google.com/docs/app-check/cloud-functions) | Fuente para enforcement; no prueba que el proyecto tenga App Check/Play Integrity configurados. |

### Configuración propuesta para revisar

- Mantener callable → catálogo fijo / IA general con identidad de servicio.
- Usar solicitudes de generación sin herramientas externas, grounding, carga de
  archivos ni historial persistente. No habilitar logging de request/response.
- Modelo aprobado: `gemini-3.5-flash-lite`, versión estable con retiro publicado
  para el 21 de julio de 2027 o posterior. La selección sustituye al retirado
  `gemini-2.5-flash` y debe revisarse antes de esa fecha.
- Región aprobada: `us-central1`; endpoint
  `https://us-central1-aiplatform.googleapis.com`. Sin fallback global silencioso.
- Logging de aplicación: solo código, latencia, versión y requestId aleatorio.
  Retención operativa propuesta: 7 días para registros propios sanitizados,
  pendiente de aprobación y separación de registros obligatorios del proveedor.
- Eliminación: mensajes locales por eventos de descarte del plan; no almacenar
  chats en Firestore. El borrado/retención del proveedor depende del contrato y
  de funciones habilitadas, y sigue por documentar.
- Costes: no se activó facturación, ninguna API ni consumo de modelo. Se necesitan
  presupuesto y alertas antes de una prueba hospedada. El usuario responsable del
  proyecto confirmó el 2026-11-05 que asume la responsabilidad de facturación.

### Evidencia del proyecto y decisiones que faltan

El cliente Android contiene el identificador público `priva-785cb` en
`mobile/lib/app/firebase_android_options.dart`. El usuario confirmó expresamente
el 2026-11-05: «Sí, usa priva-785cb como proyecto Firebase de pruebas para Zyro.
Yo soy responsable de la facturación». Esto autoriza identificar ese proyecto como
destino de pruebas y registra al usuario responsable del proyecto como responsable
de facturación. No activa facturación, APIs ni consumo, y tampoco acredita acceso
administrativo o configuración de consola. No se encontraron `gcloud` o `firebase`
en PATH en este intento. No se leyeron credenciales.

T002 queda cerrada documentalmente con las fuentes y decisiones anteriores. T004
debe verificar en `priva-785cb` el plan, APIs, región, IAM, Logging, presupuesto y
App Check antes de realizar una prueba hospedada.

### T003 — inventario y aprobación

| Dato | Finalidad | Acceso | Expiración propuesta | Exclusiones |
| --- | --- | --- | --- | --- |
| `zyro_rate_limits/{uid}`: ventana, contador, expiresAt; UID en identificador | limitar abuso: 10 solicitudes/10 minutos | servidor con Admin SDK; cliente denegado | expiresAt ≤24h desde escritura; eliminación física y retraso TTL por verificar | sin mensajes, contexto, respuestas, correo ni perfil |

El usuario aprobó expresamente esta configuración el 2026-11-05 con el mensaje
«Apruebo esa configuración para Zyro». Quedan aprobados la finalidad de limitar
abuso, el máximo de 10 solicitudes por 10 minutos y `expiresAt` ≤24h. El plazo
lógico del contador no acredita borrado físico puntual por Firestore; T027/T038
deben comprobar la política TTL y su comportamiento real.

### Fuente adicional para la selección de modelo

- [Versiones y ciclo de vida](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/model-versions):
  `gemini-3.5-flash-lite` publicado como modelo estable con retiro el 21 de julio
  de 2027 o posterior; `gemini-2.5-flash` figura retirado desde el 20 de octubre
  de 2026.
- [Ubicaciones y endpoints](https://docs.cloud.google.com/gemini-enterprise-agent-platform/resources/locations):
  catálogo oficial de disponibilidad y endpoints. La configuración real se
  valida en T004.
