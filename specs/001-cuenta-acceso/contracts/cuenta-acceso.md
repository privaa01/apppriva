# Contratos de interacción y autenticación — F01

**Estado:** diseño incluido en el plan aprobado el 2026-10-27; no API pública nueva ni código. Los métodos pertenecen
al SDK oficial; se confirmarán firmas contra las versiones fijadas antes de implementar.

## Contrato del adaptador de cuenta

| Operación conceptual | Entrada | Resultado visible / estado | SDK o integración propuesta | CA |
| --- | --- | --- | --- | --- |
| Registrar | Nombre, correo, contraseña y autorización aplicable | Confirmación pendiente; no conceder sesión por recibir objeto user | `signUp`; Confirm email activo; trigger transaccional de alta valida política y registra evidencia o revierte toda el alta | 01.1/01.2/01.5/01.6/01.8 |
| Confirmar correo | Datos del mecanismo de confirmación aprobado | Correo confirmado; habilitar solo sesión normal válida | Propuesta OTP de alta con plantilla apropiada, distinto de recovery | 01.2/01.11 |
| Iniciar sesión | Correo y contraseña | Acceso normal solo si identidad verificada; error seguro si falla | `signInWithPassword` y comprobación de estado | 01.3/01.7/01.11 |
| Solicitar recuperación | Correo | Mensaje uniforme; código a correo autorizado, sin teléfono | `resetPasswordForEmail`; template Reset password con `{{ .Token }}` | 01.4/01.9/01.10 |
| Verificar código recovery | Correo, código y contexto de recuperación | Autorización de cambio restringida, no ruta a Inicio | `verifyOTP` con `OtpType.recovery` | 01.9/01.12 |
| Cambiar contraseña | Nueva contraseña y recuperación válida | Cambio confirmado; terminar sesión temporal y volver a acceso | `updateUser`, seguido de cierre explícito de sesión | 01.13 |
| Consultar estado | Estado de Auth y contexto del flujo | Visitante / pendiente / normal / recuperación restringida | Adaptador de eventos de Auth; no equiparar todo evento signed-in a acceso normal | ACC-02/03 |

**Condiciones críticas:** no usar `signInWithOtp` para sustituir recuperación; no crear
usuarios al solicitar códigos; no registrar tokens/contraseñas/códigos. Reenvíos y
reintentos no duplican cuenta. No conceder privilegios basándose en nombre o metadatos
editables. Los límites de intentos deben poder imponerse fuera de la UI.

## Contrato de autorización

| Recurso | Sin sesión | Correo sin verificar | Sesión normal válida | Sesión de recuperación |
| --- | --- | --- | --- | --- |
| Tips y cuatro detalles | Permitido | Permitido | Permitido | Permitido |
| Registro/acceso/recuperación | Disponible como entrada | Disponible según estado | Sin ampliar privilegios | Solo flujo necesario para completar recuperación |
| Inicio/Perfil/Zyro/Cuestionario/Resultados | Requiere sesión | Requiere verificación y sesión | Permitido según precondiciones y cuenta propia | No conceder acceso completo como efecto lateral del código |
| Cambio de contraseña por recuperación | No | No sin desafío válido | No sustituye al flujo de recuperación | Solo con validación del propósito y requisitos de seguridad |

La aplicación conserva el menú de P11. Pulsar un destino protegido sin cumplir
condiciones informa que debe iniciar sesión, sin abrirlo. Rutas directas y retroceso
respetan la misma política. La autorización de servidor debe probarse con llamadas
que eludan el cliente; exigir `password` en el `amr` firmado y usuario propio; la sesión recovery por código
observada contiene `otp`. La sonda valida localmente la condición SQL; aún debe probarse
el despliegue RLS real. No se garantiza esa propiedad con un estado en Flutter.

## Errores y observabilidad

- Validación local identifica campos sin comunicar existencia de cuentas.
- Correo existente/inexistente, recuperación y acceso fallido no exponen datos ajenos.
  No mostrar códigos técnicos crudos; el texto no debe afirmar envío real si no está
  comprobado, pero tampoco enumerar cuentas.
- Cada operación tiene estado enviando y recuperación ante fallo; deshabilitar doble
  envío y reconciliar resultados desconocidos sin reintentos ciegos.
- Solo eventos mínimos de operación y resultado técnico sanitizado. Nada de correo,
  nombre, cuerpo de Auth, código o tokens en telemetría por defecto. Aplicar PD-05.

## Contrato de pantallas

P10 conserva formulario y acceso a política; P11 conserva correo, contraseña, botón,
cabecera y menú según wireframe. Verificación y recuperación se representan como
estados/subvistas del flujo, sin añadir una pantalla principal por inferencia.
No teléfono, login social, SMS ni funciones fuera de F01. Teclado, foco y lectura
ampliada se validan como parte de cada estado, no solo con una captura estática.

## Límites y revisión del 2026-10-27

Se mantienen 12 caracteres de contraseña, código de 600 segundos y reenvío mínimo de
60 segundos. El usuario retiró explícitamente el máximo exacto de cinco fallos y
eligió límites nativos del proveedor; un rate limit por IP no es un bloqueo por código.
La configuración alojada debe revisarse y probarse antes de entrega. No se registran
códigos ni tokens en la evidencia persistida.

## Precisiones para ratificación — U1 y A1

El alta recibe nombre y declaración explícita de autorización/versión; no recibe
ID de titular ni fecha autoritativa del cliente. El servidor comprueba política
publicada y crea perfil/evidencia en la misma transacción que auth.users. Fallo o
versión inválida revierte el alta. Sin permiso de cliente para reescribir evidencia
ni RPC pública del trigger; reintentos no duplican ni autorizan una versión nueva.

El acceso fallido muestra el mismo aviso público para correo inexistente, contraseña
incorrecta y correo no verificado: «No pudimos iniciar sesión. Revisa tus datos o
verifica el correo con el que te registraste». Los errores por formato no consultan
existencia. La implementación prueba mensajes y respuestas sin pasar errores crudos
ni datos de cuentas. No se afirma aquí que el proveedor hospedado ya cumpla esa propiedad.

## Adaptación Firebase — 2026-10-28

Solicitud explícita del usuario: revisar, adaptar y validar. [Estado parcial y
evidencia](../validation/firebase-results.md). Firebase sustituye al proveedor en el arranque;
el diseño Supabase anterior queda como antecedente. Registro, evidencia y códigos
siguen pendientes de diseño validado; no se cambia el comportamiento aprobado.
