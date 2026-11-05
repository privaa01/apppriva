# Implementation Plan: F05 — Orientación confiable mediante Zyro

**Branch**: `work` | **Date**: 2026-11-05 | **Spec**: [spec.md](spec.md)

**Input**: spec F05 aprobado el 2026-11-05. El responsable aprobó este plan, sus
límites y puertas previas con «apruebo» el 2026-11-05. Autoriza preparar tareas,
no ejecutarlas, desplegar ni tratar mensajes reales.

## Summary

Entregar P07 como conversación protegida y temporal. Las guías de
eliminación/desactivación de Instagram, Facebook y Google provienen de un catálogo
versionado del servidor y nunca del modelo. Las consultas generales admitidas se
envían a una Cloud Function callable v2, que valida acceso, App Check, límites y
contenido, invoca Gemini mediante Vertex AI con identidad de servicio y valida la
salida. Priva no persiste mensajes; conserva la conversación solo en memoria durante
la sesión/proceso.

La arquitectura queda propuesta, pero la implementación permanece bloqueada hasta
cerrar [provider-review.md](provider-review.md) y comprobar manualmente las fuentes
de [guide-catalogue.md](guide-catalogue.md).

## Technical Context

| Campo | Decisión propuesta |
| --- | --- |
| Language/Version | Flutter3.47.8/Dart3.13.7; Functions Node22/TypeScript; reglas Firestore v2 |
| Mobile dependencies | `cloud_functions 7.0.1`, `firebase_app_check 0.5.1`; conservar pins Firebase actuales |
| Server dependencies | `firebase-functions 7.4.0`, `firebase-admin 14.5.0`, `@google/genai 2.32.0`; confirmar resolución antes de tareas |
| Provider | Cloud Functions callable v2 → Vertex AI Gemini mediante cuenta de servicio; modelo/región exactos sujetos al cierre documental |
| Storage | mensajes/respuestas/contexto solo memoria; catálogo empaquetado con función; un contador técnico por UID con TTL≤24h, sin texto |
| Authentication | Firebase Auth password, correo verificado, evidencia `priva-1.0.0` y App Check Play Integrity |
| Testing | Flutter unit/widget/integration; Functions unit/emulator; reglas; dobles de modelo; APK Android y TalkBack |
| Target | Android API24–36; 320×720/412×915dp; texto100%/200% |
| Performance | feedback≤1s; respuesta/límite/error≤15s;20 ciclos por escenario |
| Scope | una pantalla P07,3 plataformas, guías fijas, IA general limitada; sin voz/adjuntos/acciones externas |

## Constitution Check

| Principio | Diseño y puerta |
| --- | --- |
| I. Spec | Spec aprobado; P07/RF-07–09 únicamente |
| II. Privacidad | Mensajes sin persistencia; inventario de tránsito, proveedor, logs y contador; términos/región pendientes bloquean implementación |
| III. Cuestionario | No se leen ni envían respuestas/resultados |
| IV. Zyro | Catálogo fijo, fuentes, incertidumbre y filtros antes/después; sin credenciales, ejecución o garantías |
| V. Accesibilidad | TalkBack, texto200%, teclado,48dp, contraste y comprensión definidos |
| VI. Calidad/seguridad | Auth+evidencia+App Check+cuota; secretos fuera de APK; pruebas negativas y timeout |
| VII. Trazabilidad | Spec→contratos→pruebas→futuras tareas |
| VIII. Simplicidad | Una callable; funciones existentes de Firebase; sin API/CMS adicional |
| IX. Gobierno | Plan aprobado; bloqueos deben cerrar antes de tareas de implementación |

**Resultado previo y posterior al diseño**: no se propone excepción constitucional.
El plan puede revisarse, pero no queda apto para implementación mientras las fuentes
oficiales y el tratamiento de Vertex/Logging no estén comprobados y aprobados.

## Project Structure

```text
specs/005-zyro-orientacion/
├── plan.md
├── research.md
├── data-model.md
├── guide-catalogue.md
├── provider-review.md
├── quickstart.md
└── contracts/
    ├── zyro-callable.md
    ├── zyro-policy.md
    └── zyro-ui.md

mobile/lib/features/zyro/
├── application/zyro_controller.dart
├── data/functions_zyro_repository.dart
├── data/zyro_repository.dart
├── domain/zyro_message.dart
└── presentation/zyro_screen.dart

mobile/test/features/zyro/
mobile/integration_test/zyro_test.dart

firebase/functions/
├── src/zyro/
│   ├── callable.ts
│   ├── router.ts
│   ├── policy.ts
│   ├── vertex_adapter.ts
│   └── guides.v1.json
└── test/zyro/
```

**Structure Decision**: módulo móvil vertical más una única callable. El catálogo y
los filtros viven en servidor para que una APK modificada no pueda alterar guías o
eludir controles. La conversación vive por encima de P07, asociada al UID actual.

## Flujo por pantalla P07

| Estado | Comportamiento |
| --- | --- |
| Inicial | Zyro, alcance, aviso sensible, campo ≤1000 caracteres y Enviar |
| Conversación | mensajes locales diferenciados; máximo8 mensajes/6000 caracteres enviados como contexto |
| Guía | servidor responde catálogo fijo, revisión y hasta6 pasos; modelo no interviene |
| IA general | servidor filtra entrada, llama modelo y valida JSON/salida |
| Límite | credencial/daño/fuera de alcance/no verificado recibe texto seguro local/servidor |
| Carga | una solicitud activa, requestId estable, campo/envío bloqueados y salida permitida |
| Error | reintento del mismo requestId sin duplicar burbuja; timeout15s |

Salir de P07 conserva mensajes ya recibidos y cancela el efecto de una solicitud
pendiente. Regresar durante misma sesión/proceso muestra la conversación. Logout,
cambio de UID, eliminación de cuenta, fin de proceso o dispose del propietario la
descarta. Segundo plano la conserva únicamente mientras Android mantenga el proceso.

## Arquitectura y controles

1. Cliente valida vacío/longitud y patrones sensibles evidentes; crea UUID aleatorio,
   añade una sola burbuja y llama la callable con contexto acotado.
2. Callable exige Auth, email verificado, proveedor password, evidencia vigente y
   App Check. Revalida esquema, longitud y frecuencia.
3. Router bloquea credenciales/daño/fuera de alcance. Detecta intención de guías y
   responde solo catálogo vigente; guía ausente/vencida produce límite.
4. Consulta general admitida llega a Vertex con prompt de sistema versionado y
   esquema de salida. La función no registra cuerpo, prompt o respuesta.
5. Posfiltro rechaza URL, petición de credenciales, certeza/garantía, acción externa,
   más de6 pasos o estructura inválida y devuelve límite seguro.
6. Cliente acepta solo requestId/generación/UID vigentes y muestra texto plano no
   accionable; no interpreta Markdown con enlaces.

**Cuota propuesta para aprobación**: máximo10 solicitudes por10 minutos y una activa
por conversación. `zyro_rate_limits/{uid}` contiene ventana, contador y `expiresAt`
con TTL máximo24h; nunca mensajes, correo, prompt o respuesta. Solo Admin SDK accede.
El propósito es seguridad/abuso y debe añadirse al inventario de datos; el plazo es
operativo propuesto, no plazo legal.

**Registros**: códigos de resultado, latencia agregada, versión de política y requestId
aleatorio; nunca UID, correo, mensaje, contexto o respuesta. La configuración real de
Cloud Logging y su retención se verifica antes de implementar.

## Catálogo editorial

Versión propuesta `zyro-guides-es-CO-1.0.0`. Equipo Priva abre cada fuente oficial,
reproduce la ruta con cuenta sintética sin confirmar eliminación, contrasta Android
y web, aprueba texto/consecuencias y fecha. Una guía sin revisión vigente pasa a
`unavailable`; Gemini nunca completa pasos.

- Instagram: desactivar temporalmente y eliminar permanentemente.
- Facebook: desactivar y eliminar cuenta/perfil, incluidas consecuencias relevantes.
- Google: eliminar cuenta y eliminar un servicio; no llamar «desactivación» a una
  acción general no sustentada.

Los pasos candidatos están en [guide-catalogue.md](guide-catalogue.md); el HTTP403
de este entorno impide marcarlos verificados.

## Datos, proveedor y despliegue

El diagrama/inventario está en [provider-review.md](provider-review.md). Vertex recibe
mensaje y contexto acotado; Firebase Functions procesa Auth/App Check y catálogo;
Firestore solo guarda contador técnico. No hay Firestore/Storage/Analytics para chat.

Antes de tareas de implementación, el equipo debe registrar y aprobar: modelo y
endpoint regional disponibles; ubicación y transferencia desde Colombia; uso para
entrenamiento; retención por abuso/caché/logs; eliminación; términos y acuerdo
aplicable; región común de función/modelo; facturación y límites. `us-central1` es
candidata y no una decisión cerrada.

**Secuencia enmendada 2026-11-05:** por aprobación «okey», la verificación hospedada
T004 se ejecutará justo antes de T043. El desarrollo local T005–T042 usa exclusivamente
emuladores, dobles de Vertex y datos sintéticos; no habilita APIs, facturación,
despliegue ni llamadas reales. T004 conserva todos sus controles y sigue bloqueando
T043 y la entrega.

Producción usa Play Integrity; proveedor debug solo en builds de prueba. La cuenta de
servicio recibe IAM mínimo para Vertex y contador. Ninguna API key se añade a APK,
Git, variables Dart o `google-services.json`.

## Validación

- Unitarias móviles: ciclo/UID, memoria, doble toque, retry, timeout, respuesta tardía,
  límites, texto plano y descarte.
- Servidor: Auth/AppCheck/evidencia, esquema, cuota, router, catálogo, filtros y
  respuesta hostil del modelo mediante falso; nunca llamar modelo real en suite.
- Emulator: callable y contador, acceso cliente denegado, regresión cuenta/perfil.
- Widgets: todos los estados P07, teclado,320×720/412×915,100%/200%, semántica,
  foco,48dp y contraste.
- Android físico: TalkBack, atrás, background/return, logout y red interrumpida.
- Privacidad: inspeccionar almacenamiento, tráfico y logs con datos sintéticos;
  confirmar ausencia de cuerpos y persistencia.
- SC-05.5: cinco participantes40–65, ambos tramos y experiencia digital baja; cinco
  tareas del spec, éxito individual5/5 sin ayuda, meta≥4/5. Solo conteos agregados.

Bloquean entrega: guía no verificada, fuga/persistencia de mensaje, acceso sin
autorización/AppCheck, pasos generados para cuentas, credenciales/garantías, duplicado,
acción inaccesible, regresión de sesión o prueba requerida fallida.

## Complexity Tracking

| Decisión | Justificación | Alternativa descartada |
| --- | --- | --- |
| Callable + Vertex | controles centralizados, identidad sin secreto móvil, catálogo no manipulable | Firebase AI Logic directo deja prompt/filtros críticos en cliente |
| Contador TTL | abuso verificable sin guardar texto | solo App Check no limita frecuencia |

No se añade API HTTP propia, Cloud Run separado, CMS, base de conversaciones o
proveedor externo adicional.
