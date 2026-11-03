# Accesibilidad F03 — validación parcial

Las pruebas widget comprueban P01 y cinco controles a320×720 y412×915dp con
texto100%/200%: etiquetas, objetivos Android48dp, contraste de texto, selección
semántica y acciones alcanzables. Una entrada directa protegida sin sesión muestra
acceso sin seleccionar falsamente Perfil u otra sección privada. La selección
incluye borde/peso además del color y los iconos no duplican la etiqueta.

Se corrigieron dos defectos detectados durante regresión: etiquetas accesibles
separadas del nodo pulsable y cabecera insuficiente para texto200%. Los checks
F01/F02 completos se vuelven a ejecutar junto a F03; resultados en current-results.json.

**Pendiente T030:** TalkBack, foco, sistema Android API24/API36 y dispositivo físico.
La geometría widget no acredita esa matriz nativa. No se reutilizan las confirmaciones
anteriores de TalkBack como validación de F03. No se declara cierre de SC-03.4.
