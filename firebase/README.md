# Firebase de Priva

## Alcance de plataforma vigente — 2026-10-28

Decisión explícita del usuario: «solo preparala para android». Esta entrega se
prepara únicamente para Android (mínimo API24 del plan); iOS, VoiceOver y Xcode
quedan fuera del alcance actual. Las menciones anteriores a ambas plataformas
son históricas. Se mantienen todos los requisitos funcionales, de privacidad y
seguridad aplicables a Android. No implica aprobación de otros specs ni entrega.

Proyecto confirmado por el usuario: **priva-785cb** (2026-10-28).

## Obtener configuración pública

En Firebase Console → Configuración del proyecto → General → Tus apps:

- Android: descarga `google-services.json` para la aplicación Android registrada.
- iOS: descarga `GoogleService-Info.plist` para la aplicación iOS registrada.

Si no hay apps registradas, confirmar primero sus identificadores; no inventar IDs
productivos. Los identificadores de desarrollo existentes se consultan en
`mobile/android/app/build.gradle.kts` e `mobile/ios/Runner.xcodeproj/project.pbxproj`.
No descargar ni compartir claves privadas de cuentas de servicio para esta operación.

Desde la raíz del repositorio:

```bash
python mobile/tool/import_firebase_config.py /ruta/google-services.json
python mobile/tool/import_firebase_config.py /ruta/GoogleService-Info.plist
```

El importador valida proyecto/plataforma/remitente, rechaza cuentas de servicio,
no sobrescribe configuración existente y genera archivos locales ignorados por Git.
Los archivos son distintos por plataforma; no usar el app ID Android para iOS.

```bash
cd mobile
flutter run --dart-define-from-file=config/firebase-android.local.json
# En macOS con Xcode y dispositivo/simulador iOS:
flutter run --dart-define-from-file=config/firebase-ios.local.json
```

La configuración pública no concede permisos administrativos. Sigue pendiente acceso
seguro autenticado al proyecto para revisar Auth, reglas y pruebas del servicio.
No se han creado recursos ni habilitado facturación. El acceso privado permanece
condicionado al diseño de autorización; registro y recuperación por código aún no
se han completado. No emitir manualmente claims para dar por superadas esas pruebas.

## Android incorporado — 2026-10-28

Archivo del usuario validado para `priva-785cb`, paquete `com.priva`.
`applicationId` Android ajustado; namespace Kotlin se conserva para MainActivity.
Configuración importada en `mobile/config/firebase-android.local.json` y copia del
archivo original en `mobile/android/app/google-services.json`, ambos ignorados por Git.
El arranque usa FirebaseOptions explícitos mediante el comando Android anterior;
no necesita procesar google-services.json con Gradle para Core/Auth. No se añaden
Analytics ni servicios no solicitados. Para otro entorno, volver a importar el archivo.

Esto configura el cliente Android, no acredita conexión Auth, cuentas de servicio,
reglas, registro/recuperación completos ni build. iOS necesita su propio plist.

## Activar el registro implementado

Se autorizó Cloud Firestore para la evidencia, sin Cloud Functions. La app crea:

- `profiles/{uid}`: nombre para saludo.
- `authorization_evidence/{uid}`: ID, versión/finalidades aceptadas, acción,
  aceptación y `authorized_at` con fecha de servidor. Sin correo duplicado, IP,
  dispositivo, contraseña, enlaces o datos del cuestionario.

No crear manualmente documentos ni marcar una autorización por el usuario.
Firestore necesita existir como base `(default)` del proyecto `priva-785cb`.
La región y las condiciones se eligen tras revisión del responsable; este trabajo
no ha creado base ni aceptado contratos por el usuario.

Con acceso autenticado autorizado a Firebase, validar y publicar exclusivamente
las reglas versionadas (desde `firebase/`):

```bash
npm ci
npm test
npx firebase deploy --only firestore:rules --project priva-785cb
```

Alternativa: Firebase Console → Firestore Database → Reglas, copiar
`firestore.rules` y publicar tras validarlas. No habilitar reglas públicas o modo
de prueba. Este entorno no tiene credencial administrativa válida: el archivo
Android público no autoriza desplegar reglas. La publicación real sigue pendiente.

En Authentication, comprobar Email/Password, verificación y plantillas de correo;
configurar/exigir política de contraseña mínima de 12 también en Firebase para
el formulario alojado de recuperación. La validación del cliente no la sustituye.
Probar con correo sintético propio el enlace, verificación, registro duplicado,
recuperación y acceso denegado sin evidencia o con correo sin verificar.

El emulador usa proyecto `demo-priva`, sin datos reales, requiere Java y descargar
el JAR oficial. En este entorno esa descarga está bloqueada por la red: las siete
pruebas de reglas están preparadas pero no se han ejecutado. No declarar las reglas
validadas ni el registro hospedado listo antes de esos controles.

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

## Edición de nombre F02 — reglas nuevas

Se añadió autorización restrictiva para update de `profiles/{uid}`: solo name propio,
correo verificado, password y evidencia válida; rechaza vacío/solo espacios y campos
extra. No permite modificar/borrar evidencia, email o cuestionario. Las reglas
anteriores del001 bloquean la edición, por lo que necesitan actualización.

`npm test` ahora incluye `tests/profile.test.mjs` y la suite anterior, de forma
secuencial. Seis escenarios nuevos,13 totales; no ejecutados aquí por bloqueo de
descarga oficial del emulador. No se publicó nada desde este runner.
Antes de publicar reglas nuevas, ejecutar las pruebas en entorno con emulador y
acceso apropiados; después usar Firebase Console o el comando de despliegue
exclusivo de reglas ya documentado. No usar modo público/de prueba como solución.
La postergación de tests del001 no equivale a validación de la escritura nueva.
