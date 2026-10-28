# Priva móvil — F01

## Alcance de plataforma vigente — 2026-10-28

Decisión explícita del usuario: «solo preparala para android». Esta entrega se
prepara únicamente para Android (mínimo API24 del plan); iOS, VoiceOver y Xcode
quedan fuera del alcance actual. Las menciones anteriores a ambas plataformas
son históricas. Se mantienen todos los requisitos funcionales, de privacidad y
seguridad aplicables a Android. No implica aprobación de otros specs ni entrega.

Configuración Android ya importada localmente para `priva-785cb` / `com.priva`.
Ejecutar desde `mobile/`:

```bash
flutter run --dart-define-from-file=config/firebase-android.local.json
flutter build apk --debug --dart-define-from-file=config/firebase-android.local.json
```

No se requiere plist ni macOS para esta entrega. El APK sigue pendiente por el
bloqueo de descarga del SDK; registro y recuperación Firebase siguen pendientes.

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

## Validación reproducible

Desde la raíz del repositorio, después de flutter pub get:

- bash mobile/tool/analyze.sh: analizador oficial Dart en contenedor Ubuntu fijado,
  sin red durante el análisis y sin sobrescribir HOME; necesita Docker y SDK/caché en las rutas indicadas.
- python mobile/tool/run_local_integration.py: nueve escenarios contra Auth,
  PostgREST, Postgres y buzón reales pero locales y efímeros. No crea servicios alojados.
- flutter test --no-pub desde mobile/: 42 pruebas unitarias/widgets y accesibilidad.

El runner local usa una entrada bajo tool/ para Flutter tester: no es una ejecución
sobre teléfono. Los archivos integration_test/ contienen los recorridos y las pruebas
nativas correspondientes siguen pendientes en la matriz. No se trasladan los endpoints
/__test al producto: existen solo en el fixture efímero enlazado a localhost.
El ejemplo de configuración no contiene un proyecto autorizado ni habilita datos reales.

## Firebase: adaptación parcial

El arranque utiliza Firebase. Copia `config/firebase.example.json` a
`config/hosted.json` (ignorado) y completa identificadores públicos de la app
registrada para cada plataforma. Nunca cuentas de servicio. Ejecuta
`flutter run --dart-define-from-file=config/hosted.json`.

Sin proyecto real conectado. Registro y recuperación siguen bloqueados hasta resolver
códigos y evidencia de autorización. El acceso requiere correo verificado y claim
de servidor `priva_account_ready`; su emisor está pendiente. No habilitar manualmente
para simular aceptación. No usar datos reales. Instrucciones Supabase previas son históricas.
