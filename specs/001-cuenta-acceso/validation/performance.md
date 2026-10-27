# Rendimiento T045 — evidencia local parcial

Se agregó mobile/integration_test/account_performance_test.dart y se ejecutó mediante
el runner local. Veinte registros independientes contra Auth/PostgREST reales en
Docker pasaron feedback≤1 s y respuesta≤15 s. Duraciones sanitizadas en
performance-local.json, sin nombres, correos, contraseñas, códigos o tokens.

También pasó una respuesta de acceso demorada artificialmente 16 s: el controlador
produjo aviso al vencer su timeout 15 s y la sesión que llegó tarde fue revocada.
La aserción de laboratorio permite 0,5 s de tolerancia al planificador para observar
el timeout; no cambia el presupuesto configurado de 15 s ni demuestra latencia de UI nativa.

No se incluye la entrega del correo en esa ventana. Los resultados son del cliente
headless/servicio local, no de un teléfono, red móvil o Supabase hospedado. Faltan
veinte repeticiones por las demás operaciones/perfiles de red y dispositivos de la
matriz. T045 sigue sin completar; no se sustituyen las condiciones aprobadas por esta muestra.
