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

## Alta y evidencia autorizadas por el usuario e implementadas

Responsable informado: equipo de Priva. Canal: priva202611@gmail.com. El usuario
autorizó expresamente evidencia en una colección Firebase: se incorpora Firestore
7.1.0 con perfil/evidencia en batch atómico, sin persistencia local. Auth no comparte
transacción; compensación intentada en fallo y denegación sin evidencia. No se usa
el claim priva_account_ready ni Cloud Functions. Confirmación nativa por enlace.
Política versionada incluida; no se afirma revisión jurídica/operativa cerrada.

Pruebas locales: 55 aprobadas (13 específicas Firebase con dobles). Incluyen recorrido
Crear cuenta → política → autorización → evidencia → confirmación por enlace →
volver a acceso, fallo de evidencia con eliminación compensatoria, respuesta perdida
y duplicados sin reescribir evidencia. Análisis estático sin diagnósticos.

Siete pruebas de reglas preparadas para alta atómica, timestamp/política/campos
inválidos, escritura parcial, inmutabilidad, visitante/otra identidad, listados y
persistencia de cuestionario. No ejecutadas: Firebase CLI no puede descargar el JAR
oficial cloud-firestore-emulator-v1.22.0.jar. No se infiere validación de reglas.
Dependencias Node fijadas y lockfile; comandos reproducibles en firebase/README.md.

Publicación de reglas, creación/configuración de base default y pruebas con Firebase
real siguen pendientes. El archivo google-services.json solo configura cliente,
no da permisos administrativos. No se habilitan reglas públicas para evitar este
bloqueo. No hay aceptación final, APK, dispositivos ni piloto completados.

## Corrección tras reporte de registro no disponible

Causa concreta en código: el arranque sin dart-define usaba un repositorio
Unavailable porque la configuración solo existía en archivos locales ignorados.
Ahora los identificadores públicos Android recibidos se incluyen en el código,
con override completo opcional. Inicio Firebase limitado a 15 s para evitar bloqueo
indefinido de arranque. Nombre MainActivity explícito acorde al paquete Kotlin.

Se implementa reconciliación de cuenta existente sin evidencia exclusivamente tras
aceptación en Crear cuenta y prueba de contraseña. No modifica autorizaciones
anteriores ni elimina identidades existentes. Esto corrige un segundo callejón
sin salida posible durante la migración. No habilita acceso sin correo verificado
y sin evidencia servida por Firestore.

No se demuestra conexión hospedada, reglas publicadas o APK desde estos cambios.
La publicación de reglas y base Firestore sigue siendo un requisito independiente.

Revalidación tras corregir arranque y reconciliación: 58/58 pruebas locales;
análisis estático sin diagnósticos. Integración hospedada aún no acreditada.

El usuario confirmó posteriormente que la base Firestore ya existe y publicó las
reglas. Se registra como confirmación del usuario, sin sustituir pruebas hospedadas
ni afirmar que el contenido desplegado se verificó desde este entorno.

## Validación manual comunicada por el usuario

El usuario confirmó: «ya pude iniciar sesion y crear una cuenta». Se registra como
resultado satisfactorio comunicado para esos dos recorridos. No se presume método
de ejecución, dispositivo/Android, verificación de correo probada por separado,
contenido de evidencia Firestore inspeccionado ni recuperación validada.
No equivale a aceptación de todos los criterios del spec001 ni a aprobación del002.

## Recuperación confirmada por el usuario

El usuario indicó: «la recuperacion de contraseña funciona». Se registra como
recorrido satisfactorio comunicado de recuperación por enlace. No se presume
prueba separada de enlaces vencidos/usados, límites, política de contraseña,
dispositivos o inspección de permisos/evidencia. No cierra por sí sola el spec001.

## Verificación adicional solicitada

Resultados actualizados en verification-review.md: 69 pruebas locales aprobadas,
análisis sin diagnósticos, cuatro pantallas Firebase con checks automatizados de
accesibilidad y dos escenarios texto200%/teclado. Se reprodujo y corrigió rechazo
por mayúsculas en confirmación/reenvío. Seguridad y evidencia revisadas en código
y dobles; reglas/emulador y APK continúan bloqueados por descargas.

## Casos negativos confirmados manualmente por el usuario

Tras enumerar las comprobaciones, el usuario confirmó «si, todo esto funciona»:
contraseña incorrecta rechazada; correo sin verificar sin acceso privado; visitante
solo accede a Tips; retroceso después de cerrar sesión sin acceso privado; enlace
de recuperación vencido o ya utilizado no permite cambiar contraseña.
Se registran como pruebas satisfactorias comunicadas por el usuario. No se inventan
dispositivo/OS, tiempos, capturas o inspección independiente. No demuestra inspección
de evidencia Firestore, conservación/eliminación, piloto ni rendimiento completo.
