# Rendimiento F02 — parcial

Controlador y contacto aplican aviso/fallback a15s; tests locales usan duraciones
inyectadas pequeñas para demostrar espera, respuesta tardía y reconciliación sin
falso éxito. No son mediciones de20 muestras en hardware.

profile_performance_test.dart preparado para20 cargas y20 guardados de servidor
en Android con cuenta sintética autorizada; reportData solo operación/índice/us.
Protege uso real mediante flag explícito y requiere UID/cuenta de pruebas segura.
No se ejecutó: falta dispositivo y acceso/control de prueba apropiados.

T031 pendiente: feedback≤1s, respuesta/aviso≤15s en cada muestra y combinación de
dispositivo/red, incluida espera artificial y apertura/fallback de correo. No
promediar excesos, medir entrega de correo o presentar timeout como finalización.
