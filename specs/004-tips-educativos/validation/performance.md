# F04 — rendimiento pendiente de dispositivo

Runner preparado: mobile/integration_test/tips_performance_test.dart.20 repeticiones
por catálogo/detalle/reintento/expansión, reloj monotónico, feedback≤1s y resolución
≤15s; registra duración de cada muestra y perfil sintético250ms en reportData.

No se ha ejecutado en Android porque no hay dispositivo conectado. No existen
muestras nativas; Tips lee un asset local y no mide red. Las pruebas de
timeout/reintento con Futures y los tiempos de la suite Flutter no equivalen a esta
medición en dispositivo.

El responsable reportó20 repeticiones en Motorola G22/Android12, incluido modo avión,
sin pausas, errores ni respuesta perceptible superior a1s. No se conservaron las
duraciones individuales ni un máximo numérico; se registra esta limitación sin
inventar mediciones. El responsable acepta el resultado manual y T030 se completa.
