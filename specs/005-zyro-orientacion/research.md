# Research: F05 — Asistente Zyro local

## Decisiones

### Respuestas locales deterministas

Se elige un catálogo empacado en Dart porque el usuario no necesita contenido
actualizable ni conversación generativa. Reduce superficie de datos, funciona en
modo avión y permite verificar exactamente cada respuesta.

Alternativas descartadas: Firestore añade red y publicación sin beneficio para este
alcance; una API generativa introduce transmisión, coste, latencia e incertidumbre.

### Conversación efímera

Los mensajes pertenecen al estado de `ZyroScreen` y se destruyen al salir. No se usa
repositorio, almacenamiento local, Firebase, telemetría ni logs propios.

### Guías de plataformas

No se inventan pasos. Hasta revisar fuentes oficiales, Zyro explica que carece de una
guía verificada y ofrece orientación general dentro de la aplicación.

### Interfaz

Se conserva la apariencia de chat del wireframe, se reutiliza la identidad visual de
Zyro y se ofrecen cinco consultas rápidas para que el alcance sea comprensible.

## Temas admitidos

- Contraseñas y verificación en dos pasos.
- Protección general de cuentas y hábitos de seguridad.
- Enlaces y mensajes sospechosos.
- Privacidad y exposición en redes sociales.
- Perfiles falsos y señales de suplantación.
- Primeras medidas ante una cuenta comprometida.
- Diferencia general entre eliminar y desactivar, sin pasos de plataforma no verificados.

El clasificador reconoce variantes habituales de cada tema (por ejemplo, «proteger
mi cuenta», «me hackearon» o «perfil falso»). Las guías con pasos concretos de una
plataforma siguen bloqueadas hasta revisar sus fuentes oficiales.

