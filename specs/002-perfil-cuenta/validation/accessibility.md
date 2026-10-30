# Accesibilidad F02

Cuatro estados (consulta, edición, error y eliminación) pasan las guidelines de
etiquetas, objetivos Android48dp y contraste de texto de Flutter tester.
Texto200%,320×720 y teclado simulado: Guardar nombre permanece alcanzable.
Colores de texto y componentes significativos comprobados con luminancia: onSurface,
error y onPrimary≥4.5:1, primary/outline respecto a surface≥3:1.

Se reemplazó la dirección seleccionable de objetivo menor a48dp por texto informativo
y un botón explícito Copiar correo. Ninguna acción se excluyó de semántica para
forzar las pruebas. Icono de perfil decorativo excluido de lectura.

TalkBack, foco/teclado nativos, contraste por dispositivo y matriz reales pendientes.
El reporte del usuario de TalkBack del001 no se usa como prueba de Perfil F02.
# Actualización de evidencia — 2026-10-30

El usuario reportó que funcionan las comprobaciones manuales indicadas de
accesibilidad. Se registra como evidencia reportada, no observada de forma
independiente. No se especificaron dispositivo/OS, API, tamaño, versión de build,
TalkBack, pasos ni cobertura de texto al 200%; por tanto T027 permanece pendiente.
Los resultados automatizados T026 existentes cubren pruebas Flutter, no hardware.
