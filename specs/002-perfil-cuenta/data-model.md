# Modelo de datos — F02

Estado: propuesta del plan; no migración aplicada. Sin colecciones nuevas.

## Perfil existente

Ruta `profiles/{uid}` del001. `uid` corresponde a identidad Auth; no editable.
Único campo almacenado gestionado por F02: `name` (string, nombre de saludo).
Normalizar extremos con trim, rechazar vacío/solo espacios y permitir caracteres
legítimos. No asignar máximo arbitrario, nombres de ejemplo o datos de otra cuenta.

Consulta: del servidor, con autorización de cuenta propia. Actualización: transacción
del documento existente que escribe solo name. No usar alta, set completo, upsert,
Auth.updateDisplayName o escritura en autorización. Si el perfil no existe, mostrar
error/acción de reintento; no fabricar un registro desde metadatos editables.

La regla de actualización comprueba identidad propia, email_verified, método password,
evidencia válida, nombre válido y cambios exclusivos de name. No habilita create,
update o delete en evidencia ni colecciones de otros módulos.

## Identidad y datos transitorios

`ProfileDetails`: uid, name confirmado y email de FirebaseAuth.currentUser.
Email no se almacena de nuevo en Firestore ni se modifica en F02. Rechazar identidad
incompleta antes de presentar éxito. El DTO y borrador solo viven en memoria.

No cambian los datos/claims de identidad por editar el nombre. Para el saludo fuera
de P12 se sincroniza únicamente displayName de la sesión local si coincide el UID
vigente; nunca se crea sesión ni se alteran verificación/método por ese callback.

## Estado de interacción

| Estado | Datos permitidos / transición |
| --- | --- |
| Sin acceso | Sin perfil ni borrador; entrada pública de F01. |
| Cargando | UID y generación capturados, sin datos de ejemplo. |
| Consulta | Último ProfileDetails confirmado y acciones. |
| Edición | Confirmado + borrador nombre; correo solo lectura. |
| Guardando | Operación única ligada a UID/generación; sin falso éxito optimista. |
| Error / desconocido | Confirmado anterior y borrador si sigue la misma identidad; reconciliar antes de reintentar. |
| Cerrado / invalidado | Borrar confirmado/borrador, incrementar generación e ignorar respuestas tardías. |

Cancelar antes de enviar vuelve a Consulta sin escritura. Después de enviar no se
promete cancelación remota: deshabilitar cancelación mientras se resuelve; ante
espera prolongada informar y permitir salida sin restaurar datos ni afirmar rollback.
Cambiar de identidad nunca traslada datos/borrador/errores personales a otra sesión.

## Contacto de eliminación

Constante pública `priva202611@gmail.com`. Borrador de correo con asunto/cuerpo
genéricos; no contener UID, nombre, correo de cuenta, tokens o cuestionario.
Resultados locales: redactor abierto o fallback; ninguno significa enviado/recibido.
Copiar almacena solo destinatario público en portapapeles tras pulsación expresa.
Sin entidad de expediente, fecha de recepción, plazo o estado de borrado en app.

## Conservación y evidencia

F01 `authorization_evidence/{uid}` intacta: versión, finalidades, acción y fecha de
aceptación no se alteran al editar perfil. La evidencia de pruebas compara documentos
sintéticos antes/después, sin guardar credenciales ni contenidos del cuestionario.
La solicitud al equipo se gestiona fuera de F02; no se inventa calendario ni se
aplican eliminaciones automáticamente desde el dispositivo.
