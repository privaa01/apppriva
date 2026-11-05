# Firestore F04 — emulador (histórico)

> **Histórico:** este resultado corresponde al diseño Firestore sustituido el
> 2026-11-05. Las3 pruebas de reglas Tips y4 de preflight se eliminaron junto con
> `firebase/tests/tips.test.mjs`, `tips-publication.test.mjs` y
> `firebase/tool/publish_tips.mjs`. Solo la regresión de cuenta/perfil/demo sigue
> vigente; no hay reglas ni documentos de Tips.

Fecha2026-11-05. `npm test` desde firebase/, proyecto demo-priva, Firestore
emulator1.22.0 en127.0.0.1:8085; Node24.22.1, Java21.0.12.1 del entorno.

Resultado final:24 pruebas ejecutadas,24 satisfactorias,0 fallidas,0 canceladas,
0 omitidas,0 todo. Script y runner finalizaron con código0; emulador apagado por
el runner. Incluye17 de regresión,3 de reglas Tips y4 de preflight de publicación.

Las pruebas nuevas verifican lectura de cuatro documentos aprobados como visitante
 y cuenta sintética, ausencia conocida, denegación de versiones/borradores/IDs no
permitidos, listados y escrituras; se mantuvieron cuenta/perfil/demo/suppression.
El preflight rechaza cambios de esquema/contenido no publicable antes de OAuth.
Su prueba no llama servicios externos ni demuestra autorización administrativa.

La primera ejecución con reglas anteriores falló como se esperaba en lectura pública
 y ausencia; tras permiso get limitado pasaron todas. No se publicaron reglas ni
contenido en priva-785cb. Logs finales: `/tmp/priva-f04-rules-publisher-verified.log`.

Los cuatro tests del helper sí se ejecutaron con nombres individuales en este
runner: validación, modo sin escrituras, commit atómico y rechazo de conflictos.
Las llamadas HTTP de esos tests son dobles; no hubo publicación ni acceso OAuth real.
