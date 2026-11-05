# F04 — publicación pendiente

No se ha escrito contenido ni desplegado reglas en priva-785cb. Payload:
firebase/content/tips-1.0.0.json. Reglas revisadas y probadas localmente. Helper
firebase/tool/publish_tips.mjs: --validate sin red; --check solo lectura autenticada;
--apply crea faltantes en un commit atómico, con respaldo externo/precondiciones,
y se niega a sobrescribir documentos distintos. No modifica reglas u otras colecciones.

Solo se ejecutaron --validate y tests locales. No se verificó acceso administrativo
 a Firestore. Variables ADC/OIC existen, pero el manifiesto de identidades v1 tiene
connections vacío; no se asumió identidad, proyecto ni autorización de esos valores.
No se leyeron archivos de credenciales ni se imprimieron sus contenidos.

Para continuar: responsable debe autorizar el despliegue acotado y usar una sesión
administrativa segura ya autorizada. Comparar/respaldar reglas vigentes antes de
publicar; conservar cualquier cambio ajeno posterior. README Firebase detalla pasos.
No solicitar tokens/cuentas de servicio por chat. No se amplió acceso a Internet.
