# Privacidad y seguridad — F07

La revisión estática y las pruebas confirman que el resultado usa únicamente el
`CompletedAttempt` temporal de F06 y el catálogo incluido en el APK. El cálculo es
puro y el controlador conserva en RAM el total, nivel y tres prioridades.

- No existe serialización de `ResultAssessment` ni escritura en archivos, logs,
  preferencias, analítica, Firestore o Functions.
- No existe solicitud de red en el módulo de resultados.
- Repetir invalida primero el resultado y crea una generación nueva.
- Salir, pasar a segundo plano, cerrar sesión, cambiar de usuario y `dispose`
  eliminan el intento y el resultado mediante el ciclo de vida compartido.
- Visitantes, cuentas no verificadas y rutas sin snapshot no pueden abrir P09.
- Las 17 pruebas de reglas conservan la denegación de persistencia del cuestionario.
- El texto es orientativo, reconoce el límite y no promete protección.

La inspección del código buscó APIs de Firebase, almacenamiento, HTTP y logging en
el módulo; no encontró ninguna ruta de salida para respuestas o resultados.
