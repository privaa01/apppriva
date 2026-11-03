# Entorno F03 — 2026-11-03

Matriz aprobada: API24/API36,320×720 y412×915dp, texto100%/200%,
un Android físico para TalkBack/ciclo de vida. No hay dispositivo Android,
emulador iniciado ni participantes disponibles en esta sesión. Las ejecuciones
nativas y el estudio de cinco participantes permanecen pendientes. No se dispone
de credenciales administrativas Firebase; F03 no requiere despliegues ni reglas nuevas.

Toolchain se prepara en /tmp, sin cambios de pins o minSdk24. Se comprobó el tag
Flutter3.47.8 contra GitHub:737ba8f885dc774b53b442759999a312c9461e4e.
Los destinos F04–F07 se mantendrán como marcadores honestos; los contratos temporales
se validarán con dobles sintéticos y no representan integración real de esos módulos.

Git ignore de Flutter y configuración Firebase revisados. Se añadió .dockerignore
para excluir secretos/configuración local y artefactos en contextos Docker. Sin
hooks de implementación: .specify/extensions.yml no existe. Checklist documental16/16
sin modificar marcadores. Este registro no declara la matriz ejecutada.

## Herramientas preparadas durante ejecución

Flutter/Dart y artefactos de engine descargados desde fuentes oficiales, lockfile
sin cambios; Android commandline-tools, platform-tools y SDK API24/36 (más plataformas
34/35 pedidas por dependencias existentes), build-tools36.0.0 y NDK28.2.13676358
en /tmp/priva-android. No se elevó minSdk24. El Java del host era JRE sin javac;
se obtuvo JDK21.0.13 de eclipse-temurin:21-jdk, digest
sha256:ebfbb18d11ff163ee83b21258acf12248af48d22a0fdfdc68fa1a1516c05976a,
extraído sin ejecutar servicios a /tmp/priva-jdk-complete. Gradle usa proxy/config
solo en /tmp y certificados de confianza existentes; sin desactivar TLS.

No se dispone de Android físico/AVD ni participantes. Instalar SDK no equivale a
validar compatibilidad nativa de la matriz. HOME no se modificó. .dockerignore
excluye artefactos y configuración local sensible del contexto de build.
