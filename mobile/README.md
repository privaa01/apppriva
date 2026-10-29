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

## Recuperación vigente con Firebase Auth

Olvidé mi contraseña envía enlace al correo con sendPasswordResetEmail. La nueva
contraseña se define en la página alojada de Firebase y después se vuelve a Priva
para iniciar sesión. No requiere servidor adicional ni campos de código. Deben
validarse entrega, caducidad y política de contraseña en el proyecto real.
Las notas anteriores de recuperación bloqueada o por código quedan sustituidas.
Registro y evidencia de autorización siguen pendientes; esto no completa F01.

## Registro nativo y evidencia Firestore

El registro ya carga la política priva-1.0.0 y utiliza createUserWithEmailAndPassword.
Tras aceptar se guarda perfil/evidencia en un batch Firestore y se envía enlace de
confirmación. Volver al acceso con contraseña después de verificar. No se usa el
claim provisional priva_account_ready. Necesita Cloud Firestore creado y reglas
publicadas: ver `../firebase/README.md`. Las notas previas de alta sin implementar
son históricas; no sustituir las reglas por modo de prueba para habilitar registro.

## Corrección del arranque normal

La configuración pública Android aportada por el usuario ahora se incluye en
`mobile/lib/app/firebase_android_options.dart`. No son credenciales administrativas.
Ya no depende de copiar archivos ignorados por Git ni de dart-define para iniciar
el cliente de priva-785cb. Un `flutter run` normal usa esa configuración. Los
overrides siguen disponibles, completos; una configuración parcial se rechaza
sin mezclar proyectos. El manifiesto referencia MainActivity por su nombre completo.

Para cuentas existentes sin evidencia, Crear cuenta permite aceptar la política
y registrar evidencia tras comprobar su correo/contraseña con Firebase; no borra
cuentas existentes ni sobrescribe autorizaciones anteriores. Sin prueba de control
no escribe evidencia y nunca concede acceso privado. El acceso directo con una
cuenta que aún no tiene evidencia sigue denegado, según el spec.

Actualizar/recompilar la app para incorporar estos cambios; una instalación vieja
no se actualiza por hacer push. La base Firestore y las reglas deben estar listas
en Firebase: incluir la configuración cliente no las crea ni despliega.

## Perfil y cuenta — F02

La ruta Perfil ahora consulta nombre/correo reales y permite editar exclusivamente
el nombre, cancelar y cerrar sesión. La solicitud de eliminación abre un borrador
a priva202611@gmail.com o permite copiar el correo; no envía mensajes ni borra datos.

**Para habilitar edición remota:** validar y publicar las reglas actualizadas de
`firebase/firestore.rules` siguiendo `../firebase/README.md`. Las del001 negaban
update de perfiles. No abrir permisos globales si falla el guardado. Configuración
Android predeterminada y APIs de Auth/evidencia del001 se conservan.

Regresión/Perfil: `flutter test --no-pub`. Análisis desde raíz:
`bash mobile/tool/analyze.sh`. Prueba hospedada controlada en Android:

```bash
flutter test integration_test/profile_account_test.dart --dart-define-from-file=config/profile-test.local.json -d DEVICE_ID
flutter test integration_test/profile_performance_test.dart --dart-define-from-file=config/profile-test.local.json -d DEVICE_ID
```

Copiar `config/profile-test.example.json` al archivo local ignorado y completar
solo con una cuenta sintética propia verificada y su UID; activar el flag únicamente
para ejecutar esa prueba. No enviar contraseñas por chat ni versionar el archivo.
El recorrido cambia temporalmente y restaura el nombre de ese perfil, nunca crea
usuarios ni envía correos. No se ha ejecutado desde este runner sin dispositivo.

Resultados/límites: `../specs/002-perfil-cuenta/validation/`. No declarar F02 aceptado
por disponer de pruebas locales; reglas, TalkBack, correo nativo y matriz pendientes.
