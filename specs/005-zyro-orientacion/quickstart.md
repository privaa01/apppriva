# Guía de validación — F05 Zyro

Se ejecuta después de aprobar plan/tareas e implementar. No registra resultados aún.

## Puertas previas

1. Completar todos los controles de `provider-review.md`.
2. Verificar/aprobar cada fuente y texto de `guide-catalogue.md`.
3. Confirmar versiones/lockfiles, facturación, región, IAM y App Check.
4. Usar únicamente cuentas y mensajes sintéticos.

## Automatización

1. Análisis y suite Flutter completa.
2. Unitarias de conversación, descarte, concurrencia, timeout y retry.
3. Unitarias Functions con adaptador Vertex falso para cada decisión de política,
   guía vigente/vencida, salida hostil y error.
4. Emulator Suite: Auth/AppCheck/evidencia/cuota/TTL y denegación total al cliente
   sobre `zyro_rate_limits`; regresión de reglas previas.
5. Widgets P07 en estados inicial/conversación/guía/límite/carga/error con tamaños,
   texto100/200%, teclado, foco, semántica,48dp y contraste.
6. Compilar APK debug; registrar hash, SDK y configuración sin secretos.

## Seguridad y privacidad

- Negativos: sin Auth, correo no verificado, proveedor incorrecto, evidencia ausente,
  AppCheck inválido, cuota excedida, esquema extra/inválido.
- Inspeccionar tráfico, Firestore, almacenamiento y Cloud Logging. Mensaje/contexto/
  respuesta no deben aparecer; solo contador técnico y eventos sanitizados.
- Revisar APK/repositorio para API keys, credenciales, prompts sensibles y endpoints
  no aprobados. Confirmar IAM mínimo.

## Android físico

API24/API36 cuando estén disponibles,320×720/412×915 y texto100/200%. En al menos
un físico: TalkBack, teclado, atrás, salida/retorno, background, red interrumpida,
logout y cambio de cuenta. Un omitido se registra como pendiente.

## Rendimiento y comprensión

Veinte ciclos por escenario: feedback≤1s y respuesta/límite/error≤15s; registrar
solo cantidad, máximo e incumplimientos.

Cinco personas40–65, ambos tramos y experiencia digital baja. Cada una identifica
alcance, envía consulta, evita credenciales, comprende límite y distingue orientar
de ejecutar. Éxito=5/5 sin ayuda; meta≥4/5. Guardar solo conteos agregados.

## Despliegue

Desplegar primero en proyecto Firebase de pruebas. Confirmar callable, AppCheck,
catálogo y Vertex con mensajes sintéticos; no desplegar producción ni afirmar
cumplimiento por pasar emuladores. La aceptación final requiere resultados,
limitaciones, commit, sincronización y aprobación explícita.
