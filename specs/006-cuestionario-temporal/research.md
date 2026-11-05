# Investigación y decisiones — F06

## Banco y distribución

**Decisión:** JSON local versionado dentro de la APK.  
**Razón:** contenido fijo aprobado, cero backend y revisión exacta de claves/fuentes.  
**Alternativas:** Firestore/CMS añaden red y riesgo; IA está prohibida para preguntas.

## Selección y mezcla

**Decisión:** una pregunta de cada tema más una segunda de tres temas distintos;
Fisher–Yates con fuente aleatoria inyectable.  
**Razón:** cobertura, diez IDs únicos y pruebas reproducibles sin historial.  
**Alternativas:** muestreo libre no garantiza cobertura; excluir preguntas vistas
exigiría persistencia prohibida.

## Estado temporal

**Decisión:** `QuestionnaireController` implementa `TemporaryJourney` de F03 y
conserva objetos Dart no serializables.  
**Razón:** F03 ya centraliza salida, lifecycle, sesión y acceso a resultados.  
**Alternativas:** estado de ruta se pierde al revisar; storage/backend violan alcance.

## Conectividad

**Decisión:** `connectivity_plus 7.3.2` detrás de un puerto, sin sondeo remoto;
`none` pausa. La versión se resolvió con `flutter pub add --dry-run`.  
**Razón:** cumple la decisión sin enviar respuestas ni añadir endpoints.  
**Alternativas:** continuar offline contradice la decisión; sondeo crea tráfico.

**Límite:** una interfaz disponible no garantiza internet real. F08 puede sustituir
el adaptador sin cambiar F06; la matriz debe registrar esta limitación.

## Frontera con F07

**Decisión:** F06 produce `CompletedAttempt` en RAM y `JourneyPhase.result`; no calcula
porcentaje, nivel o recomendaciones.  
**Razón:** RF-12–14 y PD-02 pertenecen a F07. Pasar respuestas por argumentos de ruta
aumentaría exposición y duplicaría reglas no aprobadas.
