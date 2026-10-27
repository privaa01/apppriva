# Informe de validación del plan 001

**Fecha:** 2026-10-27. **Alcance:** revisión técnica del diseño y sonda local reproducible
del proveedor. No es aceptación de una app implementada ni despliegue de Supabase.

## Resultado

- **21 comprobaciones locales: 21 satisfactorias**, salida final del runner **0**,
  con límites nativos expresamente elegidos por el usuario.
- **Prueba inicial con la regla de cinco fallos:** 20 comprobaciones, 19 satisfactorias
  y 1 fallida. El código correcto seguía siendo aceptado después de cinco errores.
  Se informó al usuario y eligió «Usar límites nativos y retirar el máximo exacto de cinco».
- El resultado inicial no se borra ni se transforma en éxito: [baseline](baseline-before-native-limit-decision.json).
  [Resultado final](results-native-limits.json) registra el comportamiento nativo,
  incluida la condición observada de que cinco errores no invalidan el código.
  Esa observación no se presenta como control de seguridad.
- Sin credenciales de usuarios reales, sin servicios hospedados creados y sin correos
  externos. Los mensajes se recibieron en un buzón local aislado.

## Qué se ejecutó

[Sonda](auth_provider_probe.py), Python 3 y Docker, con imágenes verificadas/fijadas:

| Servicio local | Versión observada / imagen | Digest |
| --- | --- | --- |
| Supabase Auth | gotrue v2.197.0 | `sha256:1736a63078f5922b198c4cbe50f80ab9a2d3b54fe8b7b6cfb2e9dc5dbbc12c6b` |
| Postgres | 15-alpine, contenido fijado | `sha256:54e0dd8e8cddcdbb9156c2486eed5a43eccb7214d7c6828097d41ce049fb3984` |
| Mailpit | v1.27.1 | `sha256:986b14ff7b253e62883ea19fd3112806f116e5e2f221e03f12fb81c7312ff532` |
| Servidor de template | python:3.12-alpine, contenido fijado | `sha256:5789aa194f757888f41fa3d48e14b6feaa1b57c0af0b56fcb1372d6474d3bff0` |

La prueba levanta Auth con longitud mínima 12, OTP 600 s y frecuencia de correo 60 s.
Se configura explícitamente el limitador de verificación y una cabecera de IP estable
para simular un proxy de confianza en laboratorio. En producción esa cabecera debe
provenir de infraestructura confiable; no aceptar como prueba de IP una cabecera
arbitraria enviada por el cliente. La plataforma hospedada debe revisarse por separado.

| Grupo | Evidencia positiva |
| --- | --- |
| Registro y verificación | Rechaza 11 caracteres; alta con contraseña de 12 queda sin sesión; acceso antes de confirmación falla; código de alta válido confirma. |
| Sesiones | Acceso por contraseña emite AMR `password`; recuperación emite AMR `otp`; ambos conservan su distinción en refresh. |
| Recuperación | Correo local con código, errores rechazados, código válido permite cambiar contraseña y el código usado no se reutiliza. |
| Tiempo/reenvío | Reenvío temprano HTTP 429, después de 60 s permitido; OTP de más de 600 s rechazado. |
| Limitación nativa | Solicitudes sucesivas de verificación agotan cuota y devuelven HTTP 429; no se afirma bloqueo por código o cinco fallos. |
| Aislamiento SQL | Política exige ID propio y método `password`; permite fila propia al acceso normal y niega otra identidad y claims de recuperación. |

## Límites de la evidencia

- Se envejecieron timestamps de la base **de pruebas** para comprobar condiciones de
  60/600 segundos; no se esperó diez minutos de reloj ni se alteró base ajena.
- La prueba SQL usa claims obtenidos de tokens reales del Auth local y los inyecta
  en una sesión SQL restringida. Valida el predicado de RLS con roles sin privilegio;
  **no** prueba PostgREST, verificación criptográfica de JWT en la capa HTTP ni el
  despliegue del proyecto final. Eso requiere aceptación posterior por HTTP directo.
- No se probaron contra un servicio hospedado los límites de plan comercial,
  configuración de sesiones, proveedor SMTP, retención o borrado de respaldos.
- No hay SDK Flutter instalado, resolución de lockfile, compilación o pruebas sobre
  Android/iOS en esta validación. No hay mediciones de accesibilidad, latencia o usabilidad.
- La entrega a Mailpit no demuestra entregabilidad por internet ni comportamiento
  del proveedor SMTP que finalmente elija el equipo.
- La matriz candidata Android API24/iOS15 se verificó por metadatos y archivos oficiales;
  no es certificación de todos los dispositivos. Ver pins, fuentes y checksums en
  [research.md](../research.md).

## Correcciones de diseño respaldadas

1. Retirar máximo exacto de cinco solo por autorización explícita del usuario;
   conservar expiración/reenvío y aplicar límites nativos, sin contador de UI sustituto.
2. No negar solo AMR `recovery`: este flujo de código emite `otp`. Para recursos
   privados exigir `password` y cuenta propia, con autenticación verificada por servicio.
3. Tras confirmar alta por OTP o terminar recuperación, pedir acceso por contraseña
   para obtener sesión normal; no abrir toda la app por cualquier evento signed-in.
4. Proponer baseline exacta Flutter/Dart/dependencias y sus exclusiones antes de
   aprobación; no prometer universalidad de dispositivos.

## Puerta de aprobación

La revisión técnica del plan está completada en el alcance anterior y se entrega
para aprobación explícita. Las pruebas finales del producto y la configuración con
datos reales corresponden a puertas posteriores; no se marcan ejecutadas.
No se crearon tareas ni se implementó la app. Esta sonda es un experimento aislado
de validación del proveedor, no código de producción.
