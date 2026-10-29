# Contacto para eliminación F02

URI mailto a priva202611@gmail.com, asunto/cuerpo genéricos con escape porcentual.
Pruebas locales verifican apertura solo tras llamada explícita, sin canLaunchUrl
como bloqueo, fallback false/excepción/timeout y copia exclusiva del correo público.
No se transmite nombre, UID, correo de cuenta, contraseña, código o cuestionario.

El diálogo nunca informa solicitud enviada/recibida ni cuenta eliminada. El envío
lo decide la persona en su app de correo. No se enviaron mensajes reales en pruebas.
Un timeout no cancela una acción nativa ya solicitada: no afirmar cancelación remota.

Apertura/cancelación con/sin cliente real en API24/actual pendientes; los dobles
no certifican resolución del intent Android, entrega de correo o funcionamiento
del portapapeles en hardware.
