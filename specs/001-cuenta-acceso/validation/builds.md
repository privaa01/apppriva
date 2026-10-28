# Análisis y compilación T038 — parcial

## Alcance de plataforma vigente — 2026-10-28

Decisión explícita del usuario: «solo preparala para android». Esta entrega se
prepara únicamente para Android (mínimo API24 del plan); iOS, VoiceOver y Xcode
quedan fuera del alcance actual. Las menciones anteriores a ambas plataformas
son históricas. Se mantienen todos los requisitos funcionales, de privacidad y
seguridad aplicables a Android. No implica aprobación de otros specs ni entrega.

## Análisis estático resuelto

El analizador oficial Dart 3.13.7 ejecutó dart analyze --fatal-infos sobre todo mobile/,
con analysis_options.yaml del proyecto: resultado «No issues found!», salida 0.
Se corrigieron llaves y una opción SDK obsoleta, sin silenciar reglas.

Se usó un contenedor Ubuntu 24.04 oficial, digest
sha256:24737cef17f4e22b1977df7d9a05e77c4e28b7da5b8911f8d8ccda136bf3573c,
con directorio personal propio escribible. Fuente, SDK exacto y caché de paquetes se
montaron en sus rutas originales. Dependencias del contenedor instaladas mediante
APT con comprobación normal de firmas. No se modificó HOME ni el SDK para eludir permisos.

## Builds pendientes

flutter build apk --debug --no-pub se reintentó desde el contenedor y falla antes de
compilar al descargar:
https://storage.googleapis.com/flutter_infra_release/flutter/cf636b1dfb818dd6a3ff16e390e93b1a036969c8/android-arm-profile/linux-x64.zip
CONNECT403 del proxy. No se bajó verificación ni se cambió la versión aprobada.
No hay APK generado ni se declara build satisfactorio.

iOS no puede compilarse en Linux: requiere macOS/Xcode. No hay dispositivo ni
simulador nativo conectado. T038 permanece abierta hasta completar ambos builds y matriz.
