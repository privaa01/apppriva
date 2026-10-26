# Modelo de datos y estados — F01

**Estado:** diseño preliminar condicionado a cierre de investigación y aprobación del
[plan](plan.md). No es una migración ni evidencia de almacenamiento desplegado.

## Entidades propuestas

| Entidad | Datos mínimos | Responsable técnico / relación | Validación y límites |
| --- | --- | --- | --- |
| Identidad Auth | ID estable, correo, estado de confirmación, credencial protegida y metadatos de seguridad gestionados por Auth | Supabase Auth; una identidad por cuenta según reglas verificadas del proveedor | Correo válido y único según proveedor, contraseña conforme a política aprobada; sin teléfono. |
| Perfil | ID de usuario y nombre para saludo | Tabla de aplicación; relación uno a uno con identidad Auth | Solo identidad propia puede leer/actualizar; nombre no determina permisos; no se cambia correo por editar perfil. |
| Evidencia de autorización | ID, usuario, versión de política, finalidades autorizadas, acción y fecha de servidor | Tabla propia vinculada a la identidad | No inventar consentimiento por abrir app; evitar IP/dispositivo por defecto; evidencia inmutable para cliente. |
| Solicitud/código de recuperación | Identidad de correo y token de propósito recovery, vencimiento/uso controlados por Auth | Gestionados por proveedor; no duplicar en tabla propia | No almacenar ni registrar código en app, logs o analítica. |
| Sesión local | Tokens y estado de flujo | Solo almacenamiento nativo protegido para sesión si se aprueba persistencia | Nunca contraseña; borrar al cerrar; recuperación no se convierte en permiso global por estado visual. |

No existe tabla de teléfono, respuestas, resultados, puntuación, historial de cuestionario
ni conversaciones de IA en F01. No copiar todo el objeto del proveedor a logs.
La evidencia de autorización y el perfil no deben depender de metadatos editables
por el usuario para conceder permisos. La política real de registro/consentimiento debe
validarse también del lado del servicio; una casilla de UI no prueba enforcement.

## Acceso a datos

- RLS por usuario autenticado para perfil; visitante no lee perfiles. No usar service key
  en cliente. Los recursos de Tips serán públicos por un contrato de F04, no por abrir
  tablas de cuenta.
- Las modificaciones de la evidencia de autorización no se conceden libremente al
  cliente; evaluar una operación controlada de registro y su vínculo verificable con
  la versión de política aprobada antes de fijar migración.
- Validar que usuario no verificado y sesión emitida en recuperación no eludan las
  reglas aprobadas; ese segundo punto es investigación pendiente, no garantía de RLS.
- F02 definirá eliminación; este diseño debe permitirla sin imponer retención infinita
  ni borrar evidencia sujeta a obligación antes de revisar el fundamento.

## Estados y transiciones

| Origen | Evento | Destino | Efecto permitido |
| --- | --- | --- | --- |
| Visitante | Enviar registro válido con autorización aplicable | Verificación pendiente | No abrir contenido protegido; Tips accesible. |
| Verificación pendiente | Confirmación válida y sesión normal válida | Autenticado | Acceso al alcance aprobado; datos propios. |
| Visitante | Acceso de cuenta verificada correcto | Autenticado | Acceso normal. |
| Visitante | Acceso inválido o cuenta no confirmada | Visitante / pendiente | Mensaje seguro; no acceso protegido. |
| Visitante | Solicitar recuperación | Código solicitado | Mensaje que no revela existencia de cuenta. |
| Código solicitado | Código correcto de recovery | Recuperación restringida | Cambiar contraseña; no redirigir a Inicio por listener genérico. |
| Código solicitado | Código incorrecto/vencido/usado | Mismo flujo con error | Sin cambio de credenciales; límites aprobados. |
| Recuperación restringida | Cambio confirmado | Visitante | Terminar sesión de recuperación y pedir acceso normal. |
| Autenticado | Cierre de sesión / sesión inválida | Visitante | Limpiar tokens y revocar acceso local; descarte de cuestionario integrado por F02/F06/F07. |

La restricción de recuperación en esta tabla es un requisito del diseño, no una
capacidad de servidor ya demostrada. Si no se puede imponer con Supabase, revisar
el diseño y su aprobación antes de avanzar, sin presentar guardas de UI como solución.

## Conservación — PD-05

| Categoría | Finalidad | Cierre necesario antes de datos reales |
| --- | --- | --- |
| Nombre/correo | Saludo, identificación y recuperación confirmados | Evento/plazo, responsable, región y borrado aprobados. |
| Identidad/credenciales | Autenticación | Ciclo de cuenta, revocación y eliminación en Auth revisados. |
| Evidencia de autorización | Acreditar autorización aplicable | Fundamento, plazo y atención de derechos definidos con revisión competente. |
| Registros Auth/SMTP y respaldos | Seguridad y entrega | Inventario del proveedor, minimización, retención, borrado y acuerdos revisados. |
| Tokens locales | Mantener sesión si se aprueba | Duración técnica, almacenamiento y borrado definidos; no confundir con plazos legales. |

Ningún plazo legal queda inventado. Una configuración temporal de pruebas con cuentas
sintéticas no aprueba la operación con datos de usuarios reales.
