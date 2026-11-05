# Revisión de proveedor y flujo de datos — F05

**Estado**: bloqueo previo a implementación.

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

## Bloqueos que debe cerrar el equipo Priva

- [ ] Modelo y endpoint regional disponibles y fijados.
- [ ] Región de Function/modelo y transferencia/transmisión desde Colombia evaluadas.
- [ ] Uso de prompts/respuestas para entrenamiento documentado.
- [ ] Retención de proveedor por abuso, caché y soporte documentada.
- [ ] Cloud Logging configurado sin cuerpos y retención aprobada.
- [ ] Eliminación y atención de derechos documentadas.
- [ ] Términos/acuerdo aplicable y responsable aprobados.
- [ ] Facturación, cuotas, presupuesto y alertas aprobados.
- [ ] Finalidad y TTL del contador técnico incorporados a inventario/política.

`us-central1` es solo candidata. Este documento no establece fundamento jurídico,
plazo legal o conformidad. Una respuesta comercial o configuración observada debe
adjuntarse antes de marcar cada control.

## Controles técnicos

- Cuenta de servicio con IAM mínimo para invocar Vertex y operar contador.
- Play Integrity en producción y `enforceAppCheck: true`; debug solo test.
- Secretos y prompts de sistema fuera de APK y repositorio público cuando proceda.
- Exclusión explícita de request/response en logs, errores y trazas.
- Prueba con mensajes sintéticos e inspección de Firestore/Logging/tráfico.
