# Rendimiento F03 — runner preparado, medición pendiente

T029 prepara integration_test/navigation_performance_test.dart con Stopwatch,
feedback≤1s, vista/aviso≤15s y20 repeticiones por escenario: menú a sección nueva,
retorno a existente, reselección, tarjeta, decisión de salida, acceso denegado y
carga/error de Perfil con demora sintética. El tiempo humano para decidir el diálogo
queda fuera de la medición tras confirmar. reportData/debugPrint solo contienen
etiquetas de escenario y números; no UID, correos, credenciales o respuestas.

El runner se analiza estáticamente, pero no se ha ejecutado en Android. No hay
muestras ni máximos obtenidos. La demora de200ms de un doble no acredita latencia
real de un proveedor ni un perfil de red nativo. Los tiempos de la suite widget
no constituyen mediciones de esta tarea. **T031 permanece pendiente**, con matrices
y red real/simulada etiquetadas según quickstart. No atribuir a F03 entrega de
correo o respuesta de IA.
