# Priva móvil — F01

Flutter 3.47.8 / Dart 3.13.7. Android API24+, iOS15+. Los identificadores dev.priva.*
son de desarrollo, no identificadores de publicación aprobados. No se publica ni firma distribución.

En este entorno: source /workspace/.tools/priva-toolchain.sh. En otro, instalar el SDK
oficial fijado y configurar un directorio de caché escribible sin modificar HOME.

Comandos desde mobile/: flutter pub get, dart format lib test integration_test,
flutter analyze, flutter test. Integración con dispositivo: flutter test integration_test -d ID.
Android: flutter build apk --debug. iOS requiere macOS/Xcode y flutter build ios --simulator.

Copiar config/example.json a config/local.json (ignorado), configurar URL y clave
publicable del entorno autorizado y usar flutter run --dart-define-from-file=config/local.json.
PRIVA_TEST_MODE solo permite hosts locales; usar exclusivamente datos sintéticos.
Nunca poner SMTP o service key en la app, flags compartidos o repositorio. El cliente
publicable no evita RLS. El registro requiere una política activa del servidor;
la producción permanece bloqueada sin documento, responsable y conservación revisados.

F01 implementa la entrada a la app. Inicio, Perfil, Tips, Zyro y cuestionario son
interfaces de integración de otros specs; no se entregan sus funcionalidades aquí.
