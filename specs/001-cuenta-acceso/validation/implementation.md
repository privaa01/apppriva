# Implementación F01 — avance y límites

## Entregado en código

Proyecto Flutter Android/iOS con pins y lockfile, configuración por entorno,
almacenamiento de sesión mediante adaptador nativo seguro, estados de acceso y
guardas; formularios de registro, política, confirmación, acceso y recuperación.
Errores públicos uniformes y sin teléfono. Las demás funcionalidades tienen solo
frontera de navegación y estado no disponible; no se implementa su contenido.

Supabase: políticas publicadas, perfil/evidencia, trigger transaccional con rollback,
evidencia inmutable y RLS por usuario propio y AMR password. Plantillas de códigos
por correo. Modo sintético local explícito; sin política real no se permite registro
productivo. No se crearon proyectos hospedados ni enviaron correos a personas.

## Evidencia ejecutada

- Flutter3.47.8/Dart3.13.7 instalados desde checkout/artefactos oficiales. Bloqueo
  inicial de Dart resuelto. Dependencias exactas resueltas en mobile/pubspec.lock.
- 42 pruebas Flutter unitarias/widgets/bootstrap/accesibilidad satisfactorias. El controlador
  tuvo primero cinco fallos funcionales esperados y luego pasó sus nueve escenarios.
- 33 comprobaciones SQL/Auth/PostgREST HTTP locales satisfactorias, incluidas firma
  JWT alterada, visitante, otra identidad, OTP y recuperación, transacción de alta,
  metadata sin efecto sobre evidencia y límites temporales. backend-results.json.
- La prueba de firma se corrigió para alterar el primer carácter de firma: cambiar
  el último puede afectar solo bits de relleno base64 y no alterar la firma real.
- Formato Dart aplicado y pruebas ejecutadas con CI=true para evitar caché de
  analytics en HOME de solo lectura. No se modificó HOME ni se omitió TLS/checksums.

## Pendiente / bloqueado

- El análisis estático ya se resolvió con el analizador Dart oficial dentro de un
  contenedor cuyo directorio personal es escribible: sin diagnósticos. El comando
  reproducible es bash mobile/tool/analyze.sh, sin desactivar reglas.
- flutter build apk --debug falla descargando android-arm-profile del engine fijado:
  storage.googleapis.com devuelve CONNECT403 para ese artefacto. Android SDK/NDK se
  descargaron oficialmente con verificación de sus hashes, pero no hay APK generado.
- iOS requiere macOS/Xcode; no hay dispositivos conectados ni pruebas de integración
  móvil, TalkBack/VoiceOver, tiempos, contraste completo o piloto con participantes.
- Supabase hospedado/SMTP, región, responsable, política real, conservación y acuerdos
  siguen sin configurar/aprobar para datos reales.

37 tareas completadas; 8 pendientes. No hay aceptación de entrega ni publicación.
La evidencia local no sustituye esas validaciones. Continuar desde las tareas abiertas
cuando estén disponibles el entorno de compilación y los recursos externos necesarios.

## Continuación verificada

Nueve escenarios de integración SDK/controlador/widgets contra servicios locales
reales pasaron; incluyen correo capturado, rollback de evidencia, respuesta perdida,
caída de red y sesión tardía revocada. Veinte registros medidos quedaron en
performance-local.json. La revisión de código minimiza el payload local de sesión
y conserva la recuperación compatible con SDK, comprobada por test.

No se marcan completas T037/T038/T039/T041/T042/T043/T044/T045. Sus evidencias
parciales y dependencias están en los informes específicos de validación.
