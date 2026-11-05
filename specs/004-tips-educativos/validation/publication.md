# F04 — publicación cancelada por cambio aprobado

El 2026-11-05, después de autorizar inicialmente un despliegue acotado, el responsable
aclaró que los Tips deben ser textos fijos dentro de la app y aprobó explícitamente
«Sí, deja los Tips dentro de la app». Esa decisión revoca la necesidad operativa de
publicar contenido o reglas de Tips. No se escribió nada en Firebase durante los
intentos de acceso y no se instalarán herramientas administrativas para F04.

La evidencia siguiente describe el intento anterior y se conserva como historial;
no representa un pendiente de la arquitectura vigente.

El 2026-11-05, el responsable autorizó explícitamente: «publicar únicamente
las reglas revisadas y los cuatro documentos educativos en priva-785cb».
La autorización no incluye otros documentos, colecciones, reglas ajenas ni recursos.

No se ha escrito contenido ni desplegado reglas en priva-785cb. Payload:
firebase/content/tips-1.0.0.json. Reglas revisadas y probadas localmente. Helper
firebase/tool/publish_tips.mjs: --validate sin red; --check solo lectura autenticada;
--apply crea faltantes en un commit atómico, con respaldo externo/precondiciones,
y se niega a sobrescribir documentos distintos. No modifica reglas u otras colecciones.

Solo se ejecutaron --validate y tests locales. No se verificó acceso administrativo
 a Firestore. Variables ADC/OIC existen, pero el manifiesto de identidades v1 tiene
connections vacío; no se asumió identidad, proyecto ni autorización de esos valores.
No se leyeron archivos de credenciales ni se imprimieron sus contenidos.

Comprobación posterior a la autorización: esta instancia Windows no dispone de
Firebase CLI, gcloud, ADC ni archivos locales de sesión detectables. El controlador
del navegador agotó el tiempo dos veces antes de abrir Firebase Console; por ello no
se pudo inspeccionar ni respaldar el estado remoto y no se intentó publicar. No se
solicitaron ni mostraron secretos.

Para continuar no se requiere ninguna acción de publicación: el contenido vive en
la APK y las reglas de Tips se eliminaron. El procedimiento administrativo descrito
arriba queda como historial y no debe ejecutarse para F04. No solicitar
tokens/cuentas de servicio por chat ni ampliar accesos.
