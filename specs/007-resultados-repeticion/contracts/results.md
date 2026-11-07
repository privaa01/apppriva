# Contratos F07 — resultados y repetición

## C-Q07-01 — Entrada completa

El cálculo acepta solo `CompletedAttempt` de diez preguntas con selección válida.
Ausencia, parcialidad, option ID ajeno o módulo sin dos preguntas falla cerrado y no
produce porcentaje.

## C-Q07-02 — Cálculo

`calculate(attempt)` suma los diez porcentajes enteros. Clasifica por suma: `<200`
bajo, `200..<600` medio, `>=600` alto. La presentación divide entre diez y usa una
décima solo cuando corresponde. No redondea antes de clasificar.

## C-Q07-03 — Módulos

Suma dos valores por módulo, ordena descendente y desempata por: passwords, access,
networks, phishing, devices. Devuelve exactamente los tres primeros.

## C-Q07-04 — Catálogo

Carga local atómica de versión aprobada: cinco topics exactos y tres acciones por
topic. Un error no genera acciones alternativas, no imprime contenido y permite
reintentar.

## C-Q07-05 — Acceso y temporalidad

`/results` exige sesión válida y `JourneyPhase.result`. Resultado, selecciones y
derivados nunca cruzan a almacenamiento, red, IA, analítica o logs. Salida,
background, logout, cambio UID y dispose descartan todo.

## C-Q07-06 — Repetición

Una activación descarta el resultado y crea como máximo un intento F06. Navega a P08;
pueden coincidir preguntas. Doble toque y eventos tardíos no crean otro intento ni
restauran el anterior.

## C-Q07-07 — P09 accesible

Muestra porcentaje, nivel textual, explicación, aviso literal, tres módulos con tres
acciones y Repetir. No depende solo de color. Soporta texto 100/200 %, 320×720 y
412×915, controles ≥48 dp, foco lógico y TalkBack.
