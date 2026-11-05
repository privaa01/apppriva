# F04 — revisión local de flujos y límites

**Revisión posterior al cambio 2026-11-05:** contenido aprobado→asset JSON incluido
en APK→validación de mapa cerrado→estado de pantalla en memoria. F04 ya no genera
tráfico, metadatos de ruta, lecturas ni dependencia de disponibilidad Firestore.
No usa sesión o identificadores de cuenta. Firebase continúa en módulos ajenos a
Tips. El adaptador local no expone escrituras, inputs, permisos, enlaces externos,
cuestionario o IA. Cambiar textos requiere otra APK.

Diseño anterior (histórico): contenido remoto público→get servidor por4 IDs
cerrados→modelo validado→estado de pantalla en memoria. Ese adaptador Firestore se
eliminó; no queda lectura, regla ni persistencia de Tips. En la arquitectura vigente
el asset local→validación→estado en memoria es el único flujo: no inputs, fotos
reales, enlaces accionables, clipboard, analítica nueva ni escrituras de visitas.
No hay nuevas dependencias o permisos, y Tips se crea antes e independientemente de
la autorización de cuenta.

Respuestas/resultados no entran en Tips; regresión de descarte preservada. Cubrir
una PageRoute invalida y borra estado; regresar recarga. Ejemplos, máscara y consejo
son ficticios, no capturas del usuario. No se registran errores crudos en la nueva UI.

Límite: la revisión local de código/tests no demuestra por sí sola el comportamiento
del APK instalado. Queda pendiente la inspección nativa de tráfico y almacenamiento
en un dispositivo; Tips no requiere identidad administrativa ni configuración remota
porque no usa backend. No se presume cumplimiento jurídico ni se cambian
finalidades/conservación por estas pruebas.
