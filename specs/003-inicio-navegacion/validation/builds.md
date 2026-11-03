# Compilación F03 — APK debug generado, T027 parcial

2026-11-03. Flutter3.47.8/Dart3.13.7, JDK21.0.13 y Gradle9.3.1.
`flutter build apk --debug --no-pub` terminó exit0. Se repitió tras el último
ajuste de privacidad; el build final terminó en25.9s con caches preparados.
No se modificó código de producto después del build validado.

Artefacto local, ignorado por Git: `mobile/build/app/outputs/flutter-apk/app-debug.apk`.
SHA256: `e16284129cbea7720e0a3a1b20d28dd731e9226f33814e5b898f592f09027f13`. Tamaño: 169062099 bytes.
Base Git:2cd833f con los cambios de implementación incluidos en esta entrega.
El snapshot de fuentes está en current-results.json. Se compiló el árbol de trabajo
antes del commit final; no se atribuye falsamente el APK al código del commit base.

- `package: name='com.priva' versionCode='1' versionName='0.1.0' platformBuildVersionName='16' platformBuildVersionCode='36' compileSdkVersion='36' compileSdkVersionCodename='16'`
- `minSdkVersion:'24'`
- `targetSdkVersion:'36'`

Intentos anteriores: Gradle sin proxy no resolvía services.gradle.org; se configuró
solo /tmp. El JRE no tenía JAVA_COMPILER; se preparó JDK completo. No se cambiaron
pins, minSdk o reglas ni se evitó TLS. El build advierte de KGP en plugins Firebase
y versiones de metadatos SDK; no impidió compilar. Su compatibilidad deberá revisarse
antes de futuras actualizaciones, sin actualizar ahora fuera del plan aprobado.

**T027 sigue pendiente** por instalación/matriz API24/API36 y Android físico.
Compilar no equivale a ejecutar, probar TalkBack o medir uso. APK debug para pruebas;
no se publica como release ni se sube el binario a Git.
