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
