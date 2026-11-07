# Revisión de privacidad y seguridad — F06

**Fecha:** 2026-11-06.

Las respuestas viven exclusivamente en `QuestionnaireController` mediante
objetos Dart no serializables. No hay llamadas a Firestore, Functions, Zyro,
analítica, logs, archivos, preferencias ni almacenamiento seguro desde F06.
El asset contiene solo contenido editorial estático.

El intento y el snapshot se eliminan al salir de forma confirmada, cambiar o
cerrar sesión, enviar la app a segundo plano y destruir el controlador. Las
reglas Firestore mantienen denegada la escritura de cuestionarios. Los mensajes
de error no imprimen preguntas, selecciones ni excepciones.
