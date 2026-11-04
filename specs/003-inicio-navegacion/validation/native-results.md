# Validación Android F03 — pendiente T028

Se preparó integration_test/navigation_test.dart, con binding de integración,
contratos de acceso/historial/Perfil/ciclo y una prueba de cierre→Tips→Perfil.
Las identidades y recorridos son sintéticos, sin crear cuentas ni enviar correos.
Los eventos inyectados no prueban haber pulsado Home o recientes en Android real.

No hay Android físico o AVD iniciado disponible. flutter devices y adb devices
intentados no pudieron consultar dispositivos porque adb intenta crear
/home/agent/.android en el filesystem de solo lectura, incluso con configuración
ANDROID_USER_HOME/ANDROID_SDK_HOME de /tmp. No se cambió HOME para sortearlo.
No existe /dev/kvm. Este bloqueo no es un resultado funcional de la aplicación.

Pendientes: ejecutar runner en API24/API36 y geometrías aprobadas; Home, recientes,
notificación, retorno, destrucción/reinicio, sesión, retroceso y Perfil en Android
físico. Registrar modelos/versiones/eventos/repruebas. No se afirma integración real
F06/F07: producción usa un puerto vacío y los módulos de contenido siguen pendientes.

## Confirmación funcional posterior — 2026-11-04

El usuario confirmó que ya inicia sesión y que la navegación del003 se ve y funciona.
La incidencia AC-05 queda resuelta según ese reporte; los pendientes anteriores
de comprobar acceso real son históricos. Ver [alcance de la confirmación](user-reported-manual.md).
No constituye observación independiente, matriz Android completa, TalkBack, medición
de rendimiento, estudio de usabilidad ni aceptación final de F03.
