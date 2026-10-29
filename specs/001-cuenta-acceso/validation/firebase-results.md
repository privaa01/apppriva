# Firebase: validación parcial — 2026-10-28

El usuario autorizó revisar el plan, adaptar y repetir pruebas. Checklist 18/18;
sin cambios de marcadores ni hooks registrados. No se cambia el spec.

## Implementación

Arranque Firebase Core/Auth, configuración pública validada por plataforma, sin
fallback Supabase. Acceso por contraseña exige correo verificado y claim de servidor
`priva_account_ready == true`. Este claim es una barrera provisional contra acceso
sin evidencia de autorización; su emisor no está implementado. No habilitarlo
manualmente para simular aceptación. Eventos SDK pueden revocar, nunca conceder acceso.
Errores sanitizados y cierre local de sesión. Sin Analytics, Crashlytics ni SMS.

Registro, política, confirmación y recuperación por código quedan bloqueados:
no se sustituyen por enlaces ni se simula alta/evidencia atómica. Firebase no está
conectado a un proyecto real. Supabase queda como código/suite histórica, no se inicia.

## Verificación

Dependencias reales pub.dev: firebase_core 5.1.0 y firebase_auth 7.0.1, con lockfile.
Core declara Android minSdk24; podspecs core/auth iOS15.0. No son builds ejecutados.
47 pruebas locales aprobadas: 42 de regresión y 5 nuevas con dobles SDK Firebase.
Cubren configuración, sesión válida, rechazo sin verificación/aprovisionamiento,
cierre, eventos sin acceso y flujos pendientes bloqueados. No prueban correo/servidor.
Análisis estático sin diagnósticos. Integraciones Supabase anteriores no prueban Firebase.
Documentación oficial firebase.google.com todavía responde CONNECT403 en esta red.

## Pendientes

ID de proyecto y apps Android/iOS; configuración pública real; diseño y aprobación
de alta/evidencia y códigos; reglas del servicio y pruebas HTTP/emulador/hosted;
política, región, retención y acuerdos revisados; builds Android/iOS, dispositivos,
accesibilidad nativa y piloto. Sin despliegue, facturación ni aceptación final.
37 tareas previas son evidencia histórica Supabase: no se marcan nuevas como completas.

## Continuación — proyecto confirmado

Proyecto `priva-785cb` confirmado por el usuario. No hay configuraciones públicas
Android/iOS disponibles ni Firebase CLI autenticado; el archivo señalado por
GOOGLE_APPLICATION_CREDENTIALS contiene un objeto vacío (sin secretos inspeccionados).
Se preparó importador JSON/plist con validación de proyecto y rechazo de cuentas
de servicio: cuatro verificaciones sintéticas aprobadas. No equivalen a Auth real.
Se repitió build Android: bloqueado antes de compilación por CONNECT403 al descargar
android-arm-profile del motor Flutter. iOS sigue requiriendo macOS/Xcode.
Ver `firebase/README.md` para obtener e importar la configuración pública pendiente.
No se pueden cerrar T037–T045 por estas comprobaciones de configuración.

## Revisión de cierre

Configuración Android ya recibida e importada; este dato corrige las notas anteriores
que la marcaban ausente. Consulta de API pública Firebase intentada con datos locales:
fallo de conectividad antes de respuesta; no se prueba el proveedor habilitado.
El registro/recuperación siguen siendo carencias de implementación. Ver la propuesta
`../firebase-completion-plan.md`, con sustitución U1 pendiente de aprobación.

Revalidación de esta revisión: `flutter test --no-pub` 47/47 aprobadas;
`bash mobile/tool/analyze.sh` sin diagnósticos. No son pruebas hosted ni nativas.

## Recuperación nativa por enlace aprobada e implementada

Se utiliza sendPasswordResetEmail de firebase_auth, sin Cloud Functions/Firestore.
UI muestra solicitud/reenvío y regreso a acceso, sin código ni nueva contraseña.
Usuario inexistente mantiene respuesta pública uniforme; errores técnicos se sanitizan.
No concede acceso privado ni crea cuentas. 49 pruebas locales aprobadas, incluidas
solicitud SDK, correo inexistente, error de red, UI sin código y espera de reenvío.
No se ha probado envío real, enlace vencido/usado, formulario alojado ni configuración
de contraseña: no se declara aceptación final. Registro/evidencia siguen pendientes.
