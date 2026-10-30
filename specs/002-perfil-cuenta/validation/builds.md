# Compilación y análisis F02

Formato aplicado con dart format. Suite completa:103 aprobadas.
Análisis: bash mobile/tool/analyze.sh, sin diagnósticos.

Intento real: flutter build apk --debug --no-pub, falla antes de compilación al
descargar android-arm-profile/linux-x64.zip del motor cf636b1dfb... mediante
storage.googleapis.com: CONNECT403. No se generó artefacto/hash nuevo ni se modificó
SDK/certificados/firma para eludirlo.

El usuario informó APK del001; no se etiqueta ese artefacto como versión del002.
Pendiente build Android y matriz nativa. iOS está fuera de alcance.
# Reintento de validación — 2026-10-30

- `bash mobile/tool/analyze.sh`: no ejecutable; falta `docker` (y Dart/Flutter no
  están en PATH). No se produjo análisis nuevo.
- `flutter build apk --debug --no-pub`: no ejecutable; falta `flutter`.
- No se generó APK ni hash de artefacto. La suite Flutter, el formato y el análisis
  estático de este intento quedan pendientes. El resultado histórico de 103 pruebas
  y cero diagnósticos se conserva como evidencia previa, no como una nueva corrida.
