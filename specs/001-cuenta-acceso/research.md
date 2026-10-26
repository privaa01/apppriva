# Investigación técnica — F01

**Fecha:** 2026-10-26. **Estado:** investigación documental; comprobaciones técnicas
pendientes. No hay cuentas ni servicios creados ni correo enviado.

## Método y fuentes

Se consultó la documentación fuente oficial mediante GitHub. El acceso directo a
`supabase.com` y `docs.flutter.dev` fue bloqueado con 403 por el proxy; no se eludió TLS.
Las dos investigaciones delegadas fueron de solo lectura y no cambiaron el proyecto.

- Supabase: repositorio `supabase/supabase`, commit
  `5bdb7399e80c8ed09c4633174f6e569fd58d8d7f`.
  Archivos `apps/docs/spec/supabase_dart_v2.yml` y guías de Auth indicadas abajo.
- Flutter: repositorio `flutter/website`, commit
  `6693355d92d8e28596e3350b5a8abe0e90bbbfcd`.
  Archivos bajo `sites/docs/src/content/`.

| Tema | Referencia oficial |
| --- | --- |
| Registro Dart | https://supabase.com/docs/reference/dart/auth-signup |
| Verificación OTP | https://supabase.com/docs/reference/dart/auth-verifyotp |
| Solicitud de recuperación | https://supabase.com/docs/reference/dart/auth-resetpasswordforemail |
| Contraseñas/recuperación | https://supabase.com/docs/guides/auth/passwords |
| Plantillas y Token | https://supabase.com/docs/guides/auth/auth-email-templates |
| SMTP | https://supabase.com/docs/guides/auth/auth-smtp |
| Límites | https://supabase.com/docs/guides/auth/rate-limits |
| Arquitectura Flutter | https://docs.flutter.dev/app-architecture/guide |
| Pruebas Flutter | https://docs.flutter.dev/testing/overview |
| Android | https://docs.flutter.dev/platform-integration/android/setup |
| iOS | https://docs.flutter.dev/platform-integration/ios/setup |
| Plataformas por SDK | https://docs.flutter.dev/reference/supported-platforms |

Snapshots reproducibles:
[Supabase](https://github.com/supabase/supabase/tree/5bdb7399e80c8ed09c4633174f6e569fd58d8d7f/apps/docs)
y [Flutter](https://github.com/flutter/website/tree/6693355d92d8e28596e3350b5a8abe0e90bbbfcd/sites/docs/src/content).
Estos son commits de documentación, no versiones elegidas de dependencias.

## R01 — Plataforma

**Decisión:** Flutter + Supabase confirmados por respuesta del usuario del 2026-10-26.
Flutter usa su Dart incluido; Supabase Auth se propone para registro y acceso.
**Motivo:** una base móvil Android/iOS y un proveedor que documenta confirmación de
correo y recuperación mediante código.
**Alternativas:** React Native + Supabase (presentada al usuario); Firebase Auth
requiere estudiar un flujo de recuperación diferente del enlace habitual antes de
satisfacer el código exigido. No se eligió por analogía ni se afirma imposibilidad.
**Pendiente:** versiones exactas, mínimos móviles, región, coste/plan del proveedor,
acuerdos y seguridad. La decisión de tecnología no cierra PD-05/07/08/09.

## R02 — Confirmación de correo

**Decisión propuesta:** activar Confirm email y usar código de alta dentro del flujo;
el usuario aprobó la obligación de verificar, no el mecanismo concreto.
**Evidencia:** con confirmación habilitada, el alta retorna usuario y sesión nula.
**Motivo:** no habilitar contenido por la mera existencia del usuario.
**Alternativa:** enlace con deep link revisado y allowlist; añade validación de rutas
entrantes. Ninguno de los dos mecanismos se declara ya configurado.

## R03 — Recuperación por código

**Decisión del usuario:** código enviado al correo, sin teléfono.
**Diseño documentado:** `resetPasswordForEmail(email)` envía el template Reset password;
mostrar `{{ .Token }}` (documentado como OTP de seis dígitos) en lugar de depender
solo de `{{ .ConfirmationURL }}`. Verificar con `verifyOTP(..., type: OtpType.recovery)`;
solo después actualizar contraseña con `updateUser`. No usar `signInWithOtp` para
recuperación ni permitir creación automática de cuentas en este recorrido.
**Motivo:** cumplir Q3 sin sustituirlo por un enlace o acceso passwordless.
**Limitación:** validar en un proyecto de pruebas la plantilla, propósito, uso único,
expiración, reintentos y sesión emitida. No son pruebas ejecutadas por leer la API.

## R04 — Sesión de recuperación

**Decisión propuesta:** modelar recuperación como estado restringido; al terminar,
cerrar su sesión y volver al acceso normal, sin ruta automática a Inicio.
**Motivo:** CA-01.13 y separación de identidad válida de intención de recuperación.
**Límite crítico:** la API puede devolver una sesión autenticada al verificar OTP.
La documentación NO demuestra que esa sesión sea incapaz de consultar otras APIs.
Una guarda de Flutter no añade una restricción del lado del servidor. Debe probarse
la frontera real con llamadas directas a datos y revisar autorización si es necesario.
**Estado:** bloqueo técnico abierto; no declarar arquitectura completamente validada.
No se prescribe una capa extra o un mecanismo de claims no investigado para ocultarlo.

## R05 — Correo y anti-enumeración

**Decisión propuesta:** SMTP propio evaluado, mensajes públicos uniformes y pruebas
de correo existente/inexistente para alta y recuperación.
**Evidencia:** el SMTP predeterminado limita destinatarios, impone límites restrictivos
y no está diseñado para producción. No asumir entrega a todos los usuarios.
La documentación de alta describe ofuscación de usuario existente al habilitar
Confirm email y Confirm phone, incluso con proveedor de teléfono deshabilitado.
**Regla:** esa configuración del servidor no crea un requisito de teléfono en Priva.
**Pendiente:** proveedor SMTP, dominio, remitente y acuerdos; secretos solo en servidor,
no en repo o app. En esta etapa no se solicita ninguna clave ni se envían mensajes.

## R06 — Arquitectura y pruebas

**Decisión propuesta:** vistas/estado, coordinador de acceso y adaptador de Auth;
pruebas unitarias, widgets y recorridos reales separados. Evitar microservicios propios.
**Motivo:** la guía Flutter recomienda separar UI y datos y adaptar complejidad.
**Alternativa:** vistas que llamen directamente a SDK; dificulta probar red, errores y
estados de recuperación. No se exige una capa de dominio adicional sin necesidad.
**Pendiente:** Android requiere SDK/dispositivo o emulador; iOS requiere macOS/Xcode.
Los mínimos del SDK no sustituyen la aprobación de compatibilidad del producto.

## R07 — Persistencia y tratamiento

**Decisión propuesta:** sesión en almacenamiento nativo protegido mediante adaptador
revisado; no asumir que el almacenamiento predeterminado del SDK satisface seguridad.
Perfil mínimo y autorización con RLS por identidad propia. Contraseñas/códigos nunca
en archivos, preferencias comunes, analítica ni logs.
**Motivo:** minimización y control de acceso constitucionales.
**Alternativas:** memoria solamente pierde sesión al cerrar; almacenamiento común de
preferencias no se acepta como almacén seguro de credenciales.
**Pendiente:** paquete/versiones de almacenamiento, región, borrado, copias, proveedor
SMTP y matriz legal. No se fijan años de conservación ni se aprueba tratamiento
internacional por elegir un servicio disponible.

## Cierre de investigación

Base tecnológica elegida; fuentes y alternativas documentadas. Fase 0 no completada:
falta cerrar compatibilidad, parámetros y frontera de recuperación con el proveedor.
Los artefactos de diseño son preliminares y no autorizan tareas ni implementación.

## R08 — Respuestas posteriores del usuario

El 2026-10-26 solicitó compatibilidad con todos los dispositivos. Se conserva el alcance
móvil Android/iOS y se interpreta como objetivo de máxima cobertura viable, no como
una capacidad demostrada de Flutter o del producto. Se debe verificar el mínimo común
del SDK estable y dependencias, arquitecturas y exclusiones. No se inventa un mínimo
ni se amplía el alcance a escritorio o tablets.

El usuario aceptó, sujeto a validación del proveedor, mínimo de 12 caracteres,
caducidad de código de 10 minutos, reenvío cada 60 segundos y máximo de 5 fallos
antes de exigir nuevo desafío. No hay evidencia de enforcement todavía. El límite
de fallos debe verificarse de forma independiente de la UI; si no es configurable,
la investigación debe reportarlo y proponer una revisión, sin sustituirlo en silencio.
Los valores de sesión y demás propuestas siguen sin aprobarse.
