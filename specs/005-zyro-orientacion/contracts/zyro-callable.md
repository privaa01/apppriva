# Contrato callable `zyroRespond` — F05

## Precondiciones

Firebase Auth válido, correo verificado, proveedor password, evidencia de autorización
`priva-1.0.0`, App Check válido y cuota disponible. El servidor comprueba todo;
un cliente no concede acceso enviando campos.

## Entrada

```json
{
  "schemaVersion": 1,
  "requestId": "uuid",
  "message": "texto",
  "context": [{"role": "user|zyro", "text": "texto"}]
}
```

Mensaje≤1000 caracteres; contexto≤8 elementos/6000 caracteres; sin campos extra.

## Salida

```json
{
  "schemaVersion": 1,
  "requestId": "mismo uuid",
  "kind": "guide|general|limit",
  "message": "texto plano",
  "steps": ["máximo seis"],
  "guideId": "opcional",
  "guideRevision": "opcional",
  "retryable": false,
  "policyVersion": "zyro-policy-1"
}
```

No contiene Markdown accionable, URLs, credenciales ni instrucciones de ejecución
automática. Guía exige ID/revisión aprobados. Error recuperable usa código estable
y no expone proveedor, stack, UID o contenido.

## Concurrencia/retry

Una solicitud activa por conversación. Retry reutiliza requestId y no añade otra
burbuja. Sin persistir solicitudes no se promete idempotencia global; el cliente
deduplica por requestId/generación y el servidor controla ventana de abuso.
