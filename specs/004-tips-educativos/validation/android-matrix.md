# F04 — estado Android

Fecha2026-11-05. Instalados: commandline-tools23.0, platform-tools37.0.1, SDK
API24/34/35/36, build-tools36.0.0 y NDK28.2.13676358. Flutter requiere compile/target36
 y conserva minSdk24. No se modificó la configuración de versiones del proyecto.

Runners preparados: integration_test/tips_test.dart reutiliza recorridos sintéticos
 de lectura/expansión/retorno; tips_performance_test.dart registra20 muestras por
operación con latencia sintética250ms. Ambos se analizan, pero no se han ejecutado
 en un dispositivo. No acreditan configuración hospedada ni tiempos de red real.

`flutter devices` solo muestra Linux desktop; no hay Android conectado ni /dev/kvm.
La matriz nativa API24/API36, tamaños y TalkBack queda pendiente; instalar plataformas
SDK no equivale a haber ejecutado una matriz de dispositivos.

La compilación APK debug terminó satisfactoriamente (458.6s tras corregir setup). Se detectó Java runtime sin
javac y se instaló JDK21.0.13+9 oficial con SHA256 comprobado; Java usa el proxy
 y el almacén de confianza del entorno, sin desactivar TLS. Resultado real:
`mobile/build/app/outputs/flutter-apk/app-debug.apk`,192066564 bytes; paquete
com.priva, minSdk24/target36/compile36, actividad dev.priva.priva_mobile.MainActivity,
ABIs armeabi-v7a/arm64-v8a/x86_64 confirmados con aapt. SHA256:
aae853d37b891a24eb5bf4ccb3ae6c9a95dce23a6b0114add9952a5dbe4bde3c.
Es depuración, no publicación/firma de distribución. Avisos de plugins Kotlin
heredados y XML SDK no impidieron el build; no se actualizaron dependencias.
Un APK compilado no acredita ejecución de la matriz nativa.

Recompilación final tras ajustar el adaptador de lectura:22.6s, satisfactoria.
El hash anterior de este documento se actualizó al APK final de esta revisión.
