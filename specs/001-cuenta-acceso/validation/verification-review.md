# Validación adicional de F01 — Firebase / Android

## Resultados y alcance

- 69 pruebas locales aprobadas, cero fallos. Incluye 27 pruebas específicas Firebase
  con dobles SDK; las demás son regresión, navegación y control de estado.
- Análisis estático sin diagnósticos.
- Cuatro pantallas del flujo Firebase (registro, acceso, confirmación y recuperación)
  pasan las guidelines de etiquetas, tamaño táctil Android y contraste de Flutter.
- Registro y recuperación permanecen operables con texto 200%, pantalla 320×720 y
  teclado simulado. No equivale a TalkBack o a una medición en hardware.
- Registro, inicio y recuperación hospedados: resultados satisfactorios comunicados
  por el usuario, no observados de forma independiente por el asistente.

## Defecto reproducido y corregido

Confirmación y reenvío comparaban correo Firebase y correo ingresado distinguiendo
mayúsculas. Se añadieron dos pruebas que fallaron con AccountFailure antes de la
corrección. Ahora se compara la misma dirección normalizada; otra dirección sigue
rechazada. No se modifica el correo de la cuenta ni se relaja la verificación.

## Seguridad y evidencia: revisión de código más pruebas locales

- Ausencia de evidencia o fallo al leer Firestore impide acceso y cierra la sesión;
  retirar la evidencia revoca el estado privado al procesar eventos del SDK.
- Alta exige aceptación expresa y versión conocida; evidencia y perfil se guardan
  juntos en batch. Respuesta perdida se reconcilia sin reescribir autorización.
- UID de Auth, fecha de servidor, versión, finalidades y acción en evidencia. Sin
  contraseña, correo duplicado, IP, teléfono o datos del cuestionario.
- Reglas versionadas: solo creación propia validada, fecha del servidor y documento
  de perfil vinculado; actualización/borrado/listado de evidencia denegados.
- Acceso a perfil requiere identidad propia, password y correo verificado. Las
  demás colecciones se deniegan por defecto.
- Auth/Firestore no comparten transacción; la compensación de cuenta puede fallar.
  Una identidad sin evidencia permanece sin acceso, sin prometer rollback global.

Estas conclusiones describen código y dobles locales, NO demuestran reglas
publicadas ni inspección de registros reales. No se han tratado credenciales de
usuarios, modificado datos reales o eliminado cuentas durante esta revisión.

## Intentos bloqueados y pendientes

- Siete tests de reglas Firestore preparados; npm test vuelve a fallar al descargar
  el JAR oficial cloud-firestore-emulator-v1.22.0.jar. No se ejecutaron los tests.
- flutter build apk --debug --no-pub falla antes de compilación: HTTP CONNECT403
  descargando android-arm-profile del motor. No se generó APK.
- Revisión independiente del proyecto/reglas/datos reales sin acceso administrativo
  disponible. Usuario confirmó base creada y reglas publicadas.
- TalkBack, matriz de Android, teclado/foco nativos, protección efectiva de sesión
  en dispositivo, enlaces usados/vencidos, política de contraseña y límites reales,
  conservación/eliminación, piloto y mediciones completas de rendimiento pendientes.

T037/T038/T039/T041/T042/T045 siguen incompletas; T043/T044 dependen de su cierre.
No se avanza al002 ni se declara aceptación final. No se repiten integraciones
Supabase como sustituto de validación Firebase.

## Reproducir

Desde mobile/: flutter test --no-pub.
Desde raíz: bash mobile/tool/analyze.sh.
Desde firebase/: npm ci y npm test (requiere descarga oficial del emulador y Java).

## Aclaración posterior del usuario

El usuario informó que ya obtuvo el APK. Se registra como artefacto obtenido en
su entorno, sin inspección independiente de versión, firma o compatibilidad.
El fallo de build documentado corresponde solo al runner cloud, no niega ese APK.

El usuario autorizó dejar pendientes las pruebas de reglas durante la fase de
prueba. Es aplazamiento explícito, no resultado satisfactorio, permiso para reglas
públicas ni aceptación de entrega con datos reales. Se mantienen reglas restrictivas.
TalkBack y demás pruebas de dispositivos siguen sin ejecución registrada.
