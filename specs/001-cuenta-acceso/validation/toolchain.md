# Toolchain F01 — bloqueo de red resuelto

Flutter3.47.8, Dart3.13.7 ejecutados correctamente desde el checkout oficial
737ba8f885dc774b53b442759999a312c9461e4e. Engine cf636b1dfb818dd6a3ff16e390e93b1a036969c8.
La descarga oficial de Dart ya devuelve200. No se desactivaron TLS o verificaciones.
El manifiesto global de releases devuelve404 pero el artefacto exacto del engine es válido.

Se usa /workspace/.tools/priva-toolchain.sh para PATH, XDG_CONFIG_HOME, PUB_CACHE
y caché Gradle escribibles, sin cambiar HOME. El intento inicial falló por .config
no escribible y se corrigió por XDG_CONFIG_HOME soportado.

flutter create Android/iOS ejecutado; flutter pub get resolvió los pins directos
supabase_flutter2.18.3 y flutter_secure_storage11.2.0. mobile/pubspec.lock retiene
la resolución reproducible. Se verificará análisis, pruebas y builds por separado.
No hay Xcode en Linux; Android toolchain se prepara independientemente.
