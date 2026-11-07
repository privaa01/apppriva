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
- [x] T009 Añadir las cinco consultas rápidas.
- [x] T010 Mantener la conversación exclusivamente en memoria.
- [x] T011 Integrar `/chat` con la guarda de sesión y `AccountScaffold`.
- [x] T012 Habilitar Zyro en Inicio y navegación inferior.
- [x] T013 Actualizar textos de navegación de «Chat IA» a «Asistente Zyro».

## 3. Pruebas automatizadas

- [x] T014 Probar respuestas de todos los temas admitidos y la distinción entre cuenta comprometida y petición dañina.
- [x] T015 Probar datos sensibles, peticiones dañinas y temas sin verificar.
- [x] T016 Probar acceso protegido, presentación y envío en P07.
- [x] T017 Ejecutar `dart analyze` sin diagnósticos (2026-11-06).
- [x] T018 Ejecutar la suite Flutter completa: 196/196 satisfactorias (2026-11-06), con la versión local definitiva.

## 4. Validación Android y cierre

- [ ] T019 Revisar visualmente P07 en Motorola G22 con Android 12.
- [ ] T020 Verificar TalkBack: orden, etiquetas y acciones comprensibles.
- [ ] T021 Confirmar campo y envío visibles/utilizables con el teclado abierto.
- [ ] T022 Confirmar modo avión y ausencia de historial al volver a P07.
- [ ] T023 Medir 20 respuestas locales, todas con feedback menor a 1 s.
- [ ] T024 Ejecutar los casos CA-05.1 a CA-05.6 y registrar evidencia.
- [ ] T025 Actualizar esta lista, el checklist y el estado final del spec.
- [ ] T026 Obtener aprobación final del responsable.

## 5. Ampliación con el banco de 500 preguntas

- [x] T027 Incorporar y auditar estructuralmente el banco editorial de 500 preguntas.
- [ ] T028 Resolver el duplicado y mapear 499 preguntas únicas a 38 respuestas/intenciones.
- [ ] T029 Registrar fuente oficial, fecha y plataforma aplicable para cada guía que lo requiera.
- [ ] T030 Aprobar editorialmente e integrar las guías verificadas al catálogo local.
- [ ] T031 Añadir pruebas automatizadas para todas las intenciones y variantes aprobadas.

