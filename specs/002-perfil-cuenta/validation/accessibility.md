# Accesibilidad F02

Cuatro estados (consulta, edición, error y eliminación) pasan las guidelines de
etiquetas, objetivos Android48dp y contraste de texto de Flutter tester.
Texto200%,320×720 y teclado simulado: Guardar nombre permanece alcanzable.
Colores de texto y componentes significativos comprobados con luminancia: onSurface,
error y onPrimary≥4.5:1, primary/outline respecto a surface≥3:1.

Se reemplazó la dirección seleccionable de objetivo menor a48dp por texto informativo
y un botón explícito Copiar correo. Ninguna acción se excluyó de semántica para
forzar las pruebas. Icono de perfil decorativo excluido de lectura.

## Reporte posterior del usuario — 2026-10-30

El usuario confirmó que T027 se realizó en el emulador Android. No se aportó
identificador/versión del emulador, matriz mínima/actual y pequeña/grande, ni
detalle de TalkBack, foco, teclado, texto200% y defectos/repruebas. Se clasifica
como evidencia reportada por el usuario y actualiza el estado pendiente anterior;
los detalles no disponibles no se inventan. Véase `user-reported-manual.md`.
# Actualización de evidencia — 2026-10-30

El usuario reportó que funcionan las comprobaciones manuales indicadas de
accesibilidad. Se registra como evidencia reportada, no observada de forma
independiente. No se especificaron dispositivo/OS, API, tamaño, versión de build,
TalkBack, pasos ni cobertura de texto al 200%; por tanto T027 permanece pendiente.
Los resultados automatizados T026 existentes cubren pruebas Flutter, no hardware.
