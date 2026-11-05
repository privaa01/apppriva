# Entorno F05 — estado de puertas externas

**Fecha:** 2026-11-05. **Estado:** verificación parcial; T004/T005 pendientes.

## Proyecto de pruebas

- Proyecto autorizado por el usuario: `priva-785cb`.
- Evidencia local pública: `mobile/lib/app/firebase_android_options.dart` contiene
  el mismo `projectId` y los identificadores del cliente Android.
- Responsable de facturación declarado: usuario responsable del proyecto.
- La confirmación no activa facturación, APIs o consumo y no demuestra acceso de
  consola, plan de pago, región, IAM, App Check ni cuenta de servicio.
- No se inspeccionaron ni imprimieron credenciales.

## Herramientas y configuración observadas

- `node` y `npm` están disponibles.
- En la reanudación actual existen Flutter en `/tmp/priva-flutter` y Firebase CLI
  local en `firebase/node_modules/.bin/firebase`; no están expuestos globalmente
  en `PATH`, pero son ejecutables mediante las rutas de trabajo documentadas.
- `firebase login:list --json` terminó correctamente y no enumeró cuentas. El
  manifiesto de identidades del entorno contiene cero conexiones; no hay identidad
  GCP/Firebase administrativa disponible para verificar el proyecto hospedado.
- `gcloud` no está disponible.
- `firebase/firebase.json` configura únicamente reglas y emulador de Firestore;
  todavía no declara Functions.
- El paquete `firebase/` sirve actualmente para validar reglas. Su lockfile no
  contiene `firebase-functions`, `firebase-admin` ni `@google/genai`.
- `mobile/pubspec.yaml` y su lockfile aún no contienen `cloud_functions` ni
  `firebase_app_check`.

## Pendiente antes de completar T004/T005

- Comprobar en consola el plan con facturación, APIs, región común, IAM mínimo,
  cuenta de servicio y App Check con Play Integrity.
- Verificar en el proyecto el modelo aprobado `gemini-3.5-flash-lite`, región
  `us-central1` y condiciones registradas en `provider-review.md`.
- Incorporar las versiones fijadas mediante la estructura de Functions prevista y
  resolver lockfiles sin actualizar pins por conveniencia.

No se modificaron servicios hospedados ni dependencias. T001–T003 están cerradas;
T004 permanece bloqueada por ausencia de una identidad administrativa conectada.
