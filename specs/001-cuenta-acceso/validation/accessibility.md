# Accesibilidad T037 — avance parcial

Se ejecutaron tres pruebas automatizadas en Flutter tester para acceso, registro y
recuperación: etiquetas de acciones, tamaño de objetivo táctil Android y contraste
de texto mediante las guidelines oficiales de flutter_test. Todas pasaron.
La prueba de formulario existente también amplía texto 200 % y simula teclado en
pantalla 320×720 sin excepciones ni pérdida de acceso al control de envío.

No equivale a ejecutar TalkBack/VoiceOver, foco nativo o dispositivos mínimos/actuales.
No se marca T037 completada: faltan esos recorridos, estados adicionales y mediciones
completas de contraste de componentes con sus condiciones reales. Los valores de
aceptación siguen siendo 4,5:1 normal y 3:1 grande/componentes significativos.
