# Resultados técnicos — F05 Zyro

**Fecha:** 2026-11-05. **Entorno:** nube local, rama `work`.

## Resultados ejecutados

| Control | Resultado |
| --- | --- |
| Análisis Flutter mediante `tool/analyze.sh` | 0 diagnósticos |
| Suite Flutter completa | 199/199 satisfactorias |
| Pruebas específicas Zyro móvil | 19/19 satisfactorias |
| Compilación y pruebas Functions | 17/17 satisfactorias |
| Firestore Emulator y reglas | 18/18 satisfactorias |
| APK Android debug | construido satisfactoriamente |

APK: `mobile/build/app/outputs/flutter-apk/app-debug.apk`, 192108375 bytes,
SHA-256 `b8563759ce96abde2bd876cd2eff11ba12fc32a24f2a78b9f13738f8c4c27a57`.

La primera compilación Android eligió `/usr/lib/jvm/java-21-openjdk-amd64`, que
no contenía compilador Java. Se repitió con el JDK completo autorizado en
`/tmp/priva-jdk-complete` y terminó correctamente. Gradle informó advertencias
no bloqueantes sobre la futura migración de plugins al Kotlin integrado y la
diferencia de versión del XML del SDK.

## Límites de esta evidencia

No se ejecutó la prueba `integration_test/zyro_test.dart` en un dispositivo o
emulador Android. Tampoco se desplegó `zyroRespond`, se llamó Vertex real ni se
inspeccionó Cloud Logging: Firebase CLI carece de una sesión administrativa.
Estos límites mantienen abiertas T004, T033, T036 y T038–T043 según corresponda.
