# Entorno F04 — preparado y validado localmente

2026-11-05. Checkout existente /workspace/apppriva, rama work; sincronización
fast-forward de6883bb5 a31ee98f antes de implementar. Sin worktree ni pérdida de
cambios locales. No se cambiaron pubspec, lockfiles ni versiones Gradle del proyecto.

- Flutter3.47.8 desde tag oficial737ba8f885dc774b53b442759999a312c9461e4e.
- Engine cf636b1dfb818dd6a3ff16e390e93b1a036969c8; Dart3.13.7.
- JDK Temurin21.0.13+9 local, SHA256 de archivo comprobado contra fuente oficial:
  d7f5d5cf865a2902b70ff549b97586a7d3f234e016f041ab447ea740c7d66d1c.
- Android commandline-tools23.0 (archivo16111833), SHA1 del XML oficial:
  e025545c62a8e64c7559119566a569fb1dec5f60. platform-tools37.0.1, plataformas24/34/35/36,
  build-tools36.0.0, NDK28.2.13676358 y CMake3.22.1.
- Node24.22.1; emulador Firestore1.22.0, disponible para pruebas sintéticas locales.

Activación: `source /workspace/.tools/priva-toolchain.sh`. Cachés bajo
/workspace/.cache/priva, sin modificar HOME. JAVA_HOME apunta al JDK completo;
Java utiliza el proxy del entorno y el truststore /etc/ssl/certs/java/cacerts.
Se resolvieron UnknownHost al arrancar Gradle, ausencia de javac y falta del CA
del proxy en el JDK nuevo; no se desactivaron TLS/checksums ni se cambiaron pins.

Validado: pub get --enforce-lockfile, baseline135, regresión182, análisis0,
reglas/preflight24 y APK debug. El manifiesto Flutter global aún devuelve404;
la etiqueta y los artefactos del engine fijado sí se verificaron/instalaron.

Limitaciones: sin dispositivo Android ni /dev/kvm; no pruebas nativas/TalkBack o
participantes. Chrome/Linux desktop no preparados por estar fuera de alcance.
CISA403 no impide usar fuentes alternativas primarias ya revisadas. No hay
identidad administrativa verificada para Firebase; no se publicó contenido/reglas.


Configuración reutilizable: install_script completo y start_skill actualizados en
el borrador, conservando nombre/repositorios/red. Script probado con dependencias
cacheadas y npm ci de nuevo satisfactorio; no se declaró probado un restore futuro.
No se publicó la configuración por esta operación. El usuario podrá revisar,
guardar y publicar el borrador para reutilizar el snapshot preparado en otras tareas.
