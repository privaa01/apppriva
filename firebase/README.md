# Firebase de Priva

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
