# Trazabilidad F05 — Zyro

**Corte:** 2026-11-05. Los resultados locales no sustituyen despliegue, dispositivo
físico, revisión de datos hospedados ni validación con participantes.

| Requisito / criterio | Implementación | Pruebas / tareas | Estado |
| --- | --- | --- | --- |
| RF-07, CA-05.1/2 | P07, modelos, controlador, router híbrido | T014–T017,T019–T022,T030–T031 | Local aprobado |
| RF-07.a/b/c, CA-05.5/6/12 | aviso, estados, semántica, foco, límites y navegación | T015,T017–T018,T021,T030–T035 | Local aprobado; TalkBack físico pendiente T041 |
| RF-08.a/b, CA-05.3/8 | catálogo cerrado, texto interno y revisión | T001,T008,T016,T023,T026,T031 | Local aprobado para las12 guías aportadas |
| RF-08, CA-05.9 | eliminar/desactivar con consecuencias verificadas | `guide-catalogue.md` | Pendiente: el PDF nuevo no contiene estas acciones; no se inventaron |
| RF-09.a, CA-05.4/7 | filtros previos/posteriores y límites seguros | T016,T024,T026 | Local aprobado |
| RF-09.b, CA-05.5 | una activa, retry mismo UUID, timeout y respuesta tardía | T015,T021,T035 | Local aprobado |
| RF-09.c, CA-05.8/11 | sin acciones externas ni persistencia de conversación | T020,T024–T026,T034 | Código local aprobado; auditoría hospedada pendiente T038 |
| CA-05.10 | guarda de sesión y descarte por UID/logout | T018,T028,T032,T034 | Local aprobado |
| SC-05.1/2 | matriz de política y catálogo vigente | T014–T018,T023–T028 | Automatización local aprobada |
| SC-05.3 |20 ciclos y tiempos | T039 | Pendiente |
| SC-05.4 | matriz Android y TalkBack | T040–T041 | Pendiente |
| SC-05.5 | cinco participantes40–65 | T042 | Pendiente |
| SC-05.6 | auditoría de datos y proveedor | T002–T003,T038 | Decisiones aprobadas; inspección hospedada pendiente |

## Evidencia técnica

- Flutter:199/199; Zyro móvil:19/19; análisis:0 diagnósticos.
- Functions:17/17; reglas Firestore:18/18.
- APK debug construido; hash y límites en `technical-results.md`.
- Despliegue rechazado por falta de autenticación Firebase; evidencia en
  `environment.md`.
