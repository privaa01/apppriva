# Incidencia de acceso — 2026-11-04

El usuario reportó el mensaje genérico de inicio fallido, incluso tras cambiar la
contraseña, y confirmó haber verificado el correo. Se registra como reporte del
usuario, no comprobación independiente de la identidad ni de la configuración Firebase.

## Investigación y cambio

Una prueba nueva del formulario con identidad sintética llega correctamente a P01
sin reinicios de navegación. Esto comprueba el recorrido local, no descarta fallos
nativos o de servicios en el dispositivo afectado. No se dispone de una sesión de
esa cuenta para inspeccionar sus registros y no se solicitaron credenciales.

FirebaseAccountRepository convertía rechazo de Auth, ausencia/fallo de evidencia y
fallo de lectura del perfil en la misma excepción pública. Se distinguieron etapas
con una excepción tipada sin datos del proveedor. AccountController muestra mensajes
recuperables para configuración/conexión/comprobaciones posteriores al acceso, sin
registrar UID, email, tokens, contraseñas o cuerpos de errores. La identidad se vuelve
a comprobar después de leer el perfil antes de conceder acceso.

CA-01.11 se conserva: correo inexistente, contraseña incorrecta y correo no verificado
mantienen exactamente el mismo mensaje público. La guía sobre enlace de verificación
aparece para todos esos fallos por igual y no confirma estado de una cuenta. No se
reenvían correos automáticamente, omite verificación o inventa evidencia de autorización.
El repositorio no disponible informa fallo del servicio, no credenciales incorrectas.

Referencias recuperables: AC-01 configuración de Auth, AC-03 red de Auth, AC-04
comprobación de autorización no satisfecha después de contraseña/verificación,
AC-05 error al consultar autorización, AC-06 lectura de perfil, AC-07 identidad
cambiada durante la comprobación, AC-08 limitación de intentos, AC-09 servicio no
disponible/error no clasificado. Ninguna referencia contiene detalles o códigos
arbitrarios del proveedor. No se expone AC-02 para conservar CA-01.11.

## Validación real de este cambio

- flutter test --no-pub: **129 satisfactorias**,0 fallidas, incluido formulario→P01,
  igualdad de mensajes para credenciales, etapas de servicio/autorización/perfil,
  verificación sin concesión y bootstrap seguro con servicio no disponible.
- Analizador mediante mobile/tool/analyze.sh en Docker: **0 diagnósticos**, exit0.
- flutter build apk --debug --no-pub: exit0,24.7s; mismo código después de tests/análisis.
- APK local: `mobile/build/app/outputs/flutter-apk/priva-003-acceso-20261104.apk`; SHA256 `8e45544e17a4fdba78fbfb57e8043dd06d8eec508c3eab1a43d5ff79ac6f4de8`.
- Base Git b79c5cc más los cambios de esta incidencia, incluidos en el commit posterior.

**Pendiente:** reproducir con este APK en el dispositivo afectado y obtener el
mensaje/referencia segura. El correo verificado es un reporte del usuario; no se
asume que cambiar la contraseña resuelva comprobaciones de autorización/perfil.
La causa real y el acceso de esa cuenta siguen sin confirmarse. F03 conserva sus8
controles de entrega pendientes y no se declara aceptado. Sin cambios de reglas,
SDK, dependencias, política o datos remotos; no se contactó a terceros.
