# Research — F07

## Aritmética y fronteras

**Decision:** conservar la suma entera de los diez porcentajes y clasificar contra
200 y 600; dividir entre diez solo para presentar.
**Rationale:** cada entrada es entera y el promedio avanza en décimas. Comparar la
suma evita errores binarios cerca de 20 y 60 y reproduce exactamente la regla aprobada.
**Alternatives considered:** `double` para toda la lógica (fronteras menos claras),
redondear antes de clasificar (cambia resultados) y decimal externo (dependencia
innecesaria).

## Prioridad de módulos

**Decision:** sumar las dos respuestas de cada módulo, ordenar descendente y romper
empates con el orden estable aprobado.
**Rationale:** F06 selecciona exactamente dos preguntas por módulo, por lo que suma
y promedio producen el mismo orden; la suma mantiene cálculo entero.
**Alternatives considered:** mayor respuesta individual (no aprobada), orden aleatorio
(empates inconsistentes) y mostrar cinco módulos (rechazado por alcance).

## Integración con F06/F03

**Decision:** consumir `CompletedAttempt` desde el controlador existente y mantenerlo
como única fuente temporal; no usar argumentos de ruta ni copiar respuestas.
**Rationale:** `NavigationController` ya protege `/results` mediante
`JourneyPhase.result` y descarta al salir/background/logout.
**Alternatives considered:** nuevo store global, serialización de ruta o backend;
todos amplían superficie y contradicen la prohibición de persistencia.

## Recomendaciones

**Decision:** asset JSON local, versionado y validado atómicamente, con cinco módulos
y tres acciones aprobadas por módulo.
**Rationale:** separa contenido editorial de lógica, permite igualdad contra el
catálogo aprobado y no requiere red.
**Alternatives considered:** textos generados por IA (prohibidos), recomendaciones
por pregunta inexistentes en el PDF y constantes dispersas en widgets.

## Repetición

**Decision:** invalidar primero el snapshot y luego crear un intento mediante el
controlador F06, bloqueando doble toque con generación/estado pending.
**Rationale:** nunca hay dos resultados vigentes ni restauración del anterior.
**Alternatives considered:** conservar resultado hasta confirmar carga (viola descarte
al abandonar) y crear controlador paralelo (duplica estado).
