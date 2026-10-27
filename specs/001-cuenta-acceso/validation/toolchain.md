# Preparación de toolchain — T001

**Fecha:** 2026-10-27. **Estado:** bloqueada por red, tarea sin completar.

## Comprobado

- Checklist de requisitos: 18/18 revisados; aprobación del spec, plan, correcciones y tareas registrada.
- Host Linux x86_64; sin Flutter/Dart previamente instalados y sin Xcode.
- Checkout oficial Flutter 3.47.8 en /workspace/.tools/flutter, fuera del proyecto.
- HEAD verificado: 737ba8f885dc774b53b442759999a312c9461e4e.

## Comando y fallo observado

Desde la raíz del proyecto:

```bash
FLUTTER_SUPPRESS_ANALYTICS=true PUB_CACHE=/workspace/.cache/pub /workspace/.tools/flutter/bin/flutter --version
```

Flutter intenta descargar Dart del engine cf636b1dfb818dd6a3ff16e390e93b1a036969c8
en storage.googleapis.com. Termina con estado56: CONNECT tunnel failed, response403.
La lectura del manifiesto oficial de releases en el mismo host también recibe403.
No se desactivaron TLS, firmas o checksums ni se adoptó otra versión para evitar el fallo.

## Acción de entorno necesaria

Se guardó una adición de red para storage.googleapis.com preservando las reglas
existentes. Guardar un borrador no aplica cambios de ejecución ni publica el entorno.
El usuario debe revisar y guardar el cambio en la configuración del entorno y
publicarlo según el flujo del producto; reintentar el comando tras aplicar la red.
No se necesita un token ni una clave de Supabase para descargar el SDK público.

## Pendiente

T001 sigue sin marcar: falta descargar/verificar Dart y ejecutar Flutter/Dart version.
No se inicializó mobile/, no hay lockfile ni pruebas de app ejecutadas.
T002–T045 no se ejecutaron porque dependen de este prerrequisito secuencial.
Después de resolverlo, continuar con las mismas tareas aprobadas, sin regenerarlas.
La compilación y prueba iOS seguirán requiriendo macOS/Xcode.
