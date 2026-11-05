# Investigación — F05 Zyro

**Fecha**: 2026-11-05. **Estado**: decisiones técnicas propuestas; verificaciones
externas pendientes se conservan como puertas, no como hechos aprobados.

## Intermediario de IA

**Decisión**: Cloud Function callable v2 con Auth/App Check y Vertex AI mediante
identidad de servicio.

**Razón**: centraliza catálogo, autorización, cuotas y filtros; no incluye una clave
en APK; permite dobles deterministas y una única interfaz Firebase.

**Alternativas**:

- Firebase AI Logic directo: oficial y sencillo, pero prompt, catálogo y controles
  críticos quedarían en cliente modificable.
- Cloud Run HTTP: repite validación Auth/App Check/contrato sin beneficio actual.
- Proveedor externo: agrega encargado, secreto, transferencia y contrato no justificados.

## Modelo híbrido

**Decisión**: intenciones de eliminar/desactivar se responden exclusivamente con
catálogo fijo versionado. Solo consultas generales admitidas llegan al modelo.

**Razón**: el modelo no puede inventar menús ni consecuencias; una guía ausente se
puede bloquear de forma verificable.

## Estado temporal

**Decisión**: propietario de conversación sobre P07, asociado al UID y proceso. Sin
serialización. Solicitud pendiente se invalida al salir; mensajes completos se
conservan al navegar y se borran por logout/cambio UID/eliminación/fin de proceso.

**Razón**: cumple la decisión2.B sin crear historial permanente.

## Dependencias

Metadatos oficiales consultados el 2026-11-05: `cloud_functions 7.0.1`,
`firebase_app_check 0.5.1`, `firebase-functions 7.4.0`, `firebase-admin 14.5.0`
y `@google/genai 2.32.0`. Deben resolverse contra los lockfiles antes de tareas.

## Cuota

**Decisión**: una solicitud activa,10 por10 minutos, contador sin texto y TTL≤24h.

**Razón**: App Check reduce clientes falsos, pero no sustituye control de abuso. El
TTL limita metadatos. La finalidad y retención deben aprobarse en el plan.

## Fuentes editoriales

Se identificaron páginas oficiales para Instagram, Facebook y Google, pero el
entorno devolvió HTTP403. Los pasos quedan candidatos hasta contraste manual del
equipo Priva. Google no tiene sustento revisado para una «desactivación» general:
solo eliminar cuenta o servicio se incorporará si la fuente lo confirma.

## Fuentes técnicas

Comprobadas mediante metadatos oficiales:

- https://pub.dev/packages/cloud_functions
- https://pub.dev/packages/firebase_app_check
- https://github.com/firebase/flutterfire
- https://registry.npmjs.org/

Identificadas y pendientes de comprobación documental por HTTP403:

- https://firebase.google.com/docs/functions/callable
- https://firebase.google.com/docs/app-check/cloud-functions
- https://cloud.google.com/vertex-ai/generative-ai/docs/data-governance
- https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations
- https://cloud.google.com/vertex-ai/generative-ai/docs/multimodal/configure-safety-filters

No se afirma retención cero, ausencia de entrenamiento o región disponible hasta
cerrar el registro de proveedor.
