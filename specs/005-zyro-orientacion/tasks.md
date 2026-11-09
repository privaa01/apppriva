# Tasks: F05 — Asistente Zyro local

## 1. Especificación y diseño

- [x] T001 Aprobar el alcance local, sin historial ni proveedor externo.
- [x] T002 Actualizar criterios, privacidad y métricas en `spec.md`.
- [x] T003 Documentar decisiones y alternativas en `research.md`.
- [x] T004 Definir modelo efímero y contrato local.
- [x] T005 Definir el protocolo de validación en `quickstart.md`.

## 2. Implementación base

- [x] T006 Crear el catálogo y clasificador local de respuestas verificadas, incluida la protección general de cuentas y variantes habituales de cada tema.
- [x] T007 Implementar límites para datos sensibles, daño y temas desconocidos.
- [x] T008 Construir P07 con identidad Zyro, aviso, mensajes y envío.
- [x] T009 Mostrar cinco preguntas principales que siempre devuelven orientación útil.
- [x] T010 Mantener la conversación exclusivamente en memoria.
- [x] T011 Integrar `/chat` con la guarda de sesión y `AccountScaffold`.
- [x] T012 Habilitar Zyro en Inicio y navegación inferior.
- [x] T013 Actualizar textos de navegación de «Chat IA» a «Asistente Zyro».

## 3. Pruebas automatizadas

- [x] T014 Probar respuestas de todos los temas admitidos y la distinción entre cuenta comprometida y petición dañina.
- [x] T015 Probar datos sensibles, peticiones dañinas y temas sin verificar.
- [x] T016 Probar acceso protegido, presentación y envío en P07.
- [x] T017 Ejecutar `dart analyze` sin diagnósticos (2026-11-06).
- [x] T018 Ejecutar la suite Flutter completa: 231/231 satisfactorias (2026-11-09), con la versión local, su menú por categorías y coincidencia flexible.

## 4. Validación Android y cierre

- [x] T019 Revisar visualmente P07 en Motorola G22 con Android 12 (aprobado por el responsable, 2026-11-09).
- [x] T020 Verificar TalkBack: orden, etiquetas y acciones comprensibles (aprobado por el responsable, 2026-11-09).
- [x] T021 Confirmar campo y envío visibles/utilizables con el teclado abierto (aprobado por el responsable, 2026-11-09).
- [x] T022 Confirmar modo avión y ausencia de historial al volver a P07 (aprobado por el responsable, 2026-11-09).
- [x] T023 Medir 20 respuestas locales, todas con feedback menor a 1 s (prueba automatizada, 2026-11-09).
- [x] T024 Ejecutar los casos CA-05.1 a CA-05.6 y registrar evidencia (automatizada y manual, 2026-11-09).
- [x] T025 Actualizar esta lista, el checklist y el estado final del spec (2026-11-09).
- [x] T026 Obtener aprobación final del responsable (confirmación explícita, 2026-11-09).

## 5. Banco editorial

- [x] T027 Incorporar y auditar estructuralmente el banco editorial de 500 preguntas. Su ampliación completa queda fuera del MVP y se conserva en `backlog.md`.

## 6. Menú inicial de preguntas verificadas

- [x] T032 Mostrar selector de categoría y pregunta con 50 consultas que reciben orientación local (10 por categoría).
- [x] T033 Bloquear el envío del selector hasta elegir una pregunta válida.
- [x] T034 Probar que todas las preguntas del menú reciben orientación y que el recorrido funciona en P07.

## Phase 7: Convergence

- [x] T035 Probar consulta desconocida seguida de consulta admitida y confirmar un solo mensaje de usuario y una sola respuesta por envío, según CA-05.5 (2026-11-09).
- [x] T036 Probar P07 en 320×720 y 412×915, texto 100/200 %, controles etiquetados y campo/envío utilizables con teclado simulado, según CA-05.6 y Constitución V (2026-11-09).
- [x] T037 Medir 20 respuestas locales y registrar que todas ofrecen feedback en menos de 1 s, según Success Criteria y T023 (2026-11-09).

## 8. Coincidencia flexible de consultas

- [x] T038 Ampliar CA-05.2 para aceptar frases suficientemente parecidas a las preguntas verificadas sin usar red ni IA generativa.
- [x] T039 Implementar selección local de la pregunta más cercana con umbral seguro, después de los controles de datos sensibles y daño.
- [x] T040 Probar paráfrasis admitidas, errores menores, consultas ambiguas y temas fuera de alcance.

