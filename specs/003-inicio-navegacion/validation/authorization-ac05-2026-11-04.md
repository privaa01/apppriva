# Seguimiento AC-05 — 2026-11-04

El usuario confirmó la referencia AC-05 y reportó correo verificado. El código
alcanza esa etapa después de autenticar por contraseña, verificar correo y proveedor,
pero recibe una excepción al consultar authorization_evidence/{uid} de servidor.
No se confunde con AC-04 (consulta satisfactoria sin evidencia válida).

## Validación ejecutada

npm ci con cache escribible y npm test usando Firebase CLI15.34.2,
Firestore Emulator1.22.0 y Java21. Proyecto **demo-priva**, host127.0.0.1:8085;
ningún acceso a datos hospedados. Resultado final: **14 pruebas satisfactorias**,
0 fallidas,0 omitidas. Incluye7 originales,6 de Perfil y1 de diagnóstico de lectura
de evidencia ausente. Las13 pruebas previas también pasaron antes de añadir el caso.

El caso nuevo demuestra que, con las reglas versionadas, una identidad password
propia y verificada puede consultar un documento inexistente sin error de permisos;
otra identidad y un visitante no pueden consultarlo. Por tanto, si estas mismas
reglas están publicadas y el servicio es accesible, falta de documento produce
AC-04, no AC-05. Un permiso denegado, servicio/red indisponible u otra configuración
pueden causar AC-05; el mensaje no identifica por sí solo cuál ocurre en producción.

SHA256 del archivo validado: `b5e8e5d8f669a0b28ff54a684f3c819f1bf1776c99411975ef1cac76e3e53d29`.
No se cambió una regla ni se abrió acceso público para pasar las pruebas.
No se modificó código móvil ni se regeneró APK en este seguimiento. Las129 pruebas
móviles del commit25f5dff son evidencia anterior; no se declaran ejecutadas de nuevo.

## Acceso real y siguiente comprobación

Sin credencial administrativa válida, sin FIREBASE_TOKEN y sin sesiones del CLI
configurado; el perfil predeterminado del CLI no está disponible en este entorno.
La configuración Android pública no autoriza leer/publicar configuración administrativa.
No existe conector Firebase en las herramientas disponibles. No se desplegaron reglas.

Se solicitó el texto de Firebase Console → proyecto priva-785cb → Firestore Database
→ Reglas, para contrastarlo con firebase/firestore.rules. Falta verificar reglas
publicadas, base(default), estado del servicio y, si coinciden las reglas, los controles
de acceso del servicio y conectividad. No se presume una causa específica ni se
recomienda desactivar controles, borrar evidencia o inventar consentimiento.

Estado: configuración hospedada y acceso del usuario sin resolver hasta obtener
esa comprobación. Este resultado del emulador no valida Firebase real, Android
nativo, rendimiento ni usabilidad; F03 conserva sus tareas de entrega pendientes.

## Causa identificada y corrección preparada

El usuario aportó después el texto de las reglas publicadas. Solo permiten crear
`demo_contact` con datos ficticios y deniegan el resto: no hay match que permita
leer authorization_evidence o profiles. Se conserva esa referencia en
firebase/tests/fixtures/deployed-before-priva-20261104.rules, como configuración
reportada por el usuario, no obtenida por una API administrativa.

Se reprodujo el rechazo de lectura con identidad password propia y verificada en
el emulador. Se combinaron las reglas Priva ya aprobadas con el bloque demo_contact
aportado, conservado textualmente: misma whitelist, privacy_suppressions, campos,
fecha servidor y denegación de lectura/update/delete. No se añadió acceso público
a cuentas, perfiles o autorizaciones. Los contratos F01/F02 mantienen su semántica;
esta corrección sincroniza la configuración necesaria del servicio y no agrega
funciones o datos a F03.

La suite final pasó **17/17**,0 fallidas,0 omitidas:14 anteriores,1 reproducción
con reglas publicadas reportadas y2 casos del demo/supresión conservados. El caso
nuevo de evidencia ausente permite diferenciar ausencia válida de permisos denegados.
SHA256 del archivo combinado: `16a6bb1350db45412ee6fd01f221202814b05ed89e9fe2c048e73617a168ffa0`.

**Pendiente externo concreto:** publicar el archivo completo firebase/firestore.rules
en Firestore de priva-785cb, base(default), y reintentar con el APK actual. No hay
sesión administrativa utilizable en este entorno, por lo que no se ha publicado.
La causa de bloqueo en las reglas aportadas queda demostrada, pero el login real
seguirá pendiente hasta aplicar/confirmar el cambio. No se crea evidencia manual,
se modifican datos remotos ni se requiere regenerar la app para aplicar reglas.

## Actualización reportada por el usuario — 2026-11-04

El usuario indicó «ya actualice lasreglas» después de recibir el archivo corregido
del commit cdbe38e. Se registra la actualización como reportada por el usuario,
sin inspección administrativa independiente ni despliegue ejecutado por el asistente.
El pendiente de publicación anterior describe el estado previo a esta confirmación.
Falta confirmar inicio de sesión real con el APK actual; no se marca la incidencia
resuelta, la entrega F03 aceptada ni tareas nativas completadas por este reporte.
