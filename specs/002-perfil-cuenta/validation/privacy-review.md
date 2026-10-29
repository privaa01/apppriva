# Privacidad F02 — revisión parcial

Código inspeccionado: solo name se actualiza en perfiles existentes; email se obtiene
de identidad y no se duplica. No se escribe evidencia desde edición ni se modifica
Auth.displayName. Controlador/borrador solo memoria, limpiados al salir/cerrar/cambiar
identidad; resultados ajenos/tardíos descartados. Sin historial, teléfono, fotos,
analítica, credenciales o cuestionario nuevos.

Contacto transmite solo destino/asunto/cuerpo genéricos; copia dirección pública
bajo acción expresa. No crea expediente, envía correo automáticamente ni elimina
cuenta. Mensajes de error sanitizados y sin cuerpos Firebase.

Pendientes reglas/servicio y correo/portapapeles nativos; no se cierra T032, dependiente
de T028/T029. La solicitud remite al procedimiento del equipo sin inventar plazos,
aprobar contratos o dar por implementada supresión real.
