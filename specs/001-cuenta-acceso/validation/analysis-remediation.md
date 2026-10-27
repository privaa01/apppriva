# Correcciones y repetición del análisis 001

**Fecha:** 2026-10-27.
**Autorización:** el usuario respondió «si» a la propuesta de corregir los cinco
hallazgos y repetir el análisis. Autoriza edición documental; no ejecución de tareas.

## Hallazgos originales y corrección propuesta

| ID | Hallazgo | Corrección documentada | Estado |
| --- | --- | --- | --- |
| C1 | No existían criterios de severidad del plan exigidos por la constitución | Cuatro niveles con criterios y bloqueo de todo CA/umbral incumplido; umbrales de contraste concretos en plan/T037 | Corregido documentalmente; criterios nuevos pendientes de ratificación. |
| U1 | Registro de autorización sin mecanismo transaccional para alta sin sesión | Trigger de alta en el mismo Postgres: perfil/evidencia en transacción Auth, política publicada validada, NEW.id y fecha servidor, rollback y unicidad | Diseño precisado en plan/modelo/contrato y T018/T020/T021/T031; implementación y pruebas no ejecutadas. |
| G1 | Presupuestos 1/15 s sin tarea de medición | T045 con reloj monotónico, veinte repeticiones, red/dispositivo y evidencia; antes de T043/T044 | Cobertura agregada conservando IDs anteriores. |
| A1 | Aviso de correo no verificado podía revelar existencia de cuenta | CA-01.11/contrato usan aviso idéntico para inexistente, contraseña incorrecta y no verificado; pruebas previstas | Ambigüedad corregida; validación HTTP real pendiente de implementación. |
| I1 | Declaraciones vigentes de aprobación contradictorias | Se distinguen base aprobada, correcciones pendientes y tareas generadas/no ejecutadas | Estados y registro histórico preservados sin asumir aprobación nueva. |

## Repetición de controles documentales

Inventario estable: cinco RF (tres propios y dos compartidos), nueve RNF y cinco SC.
SC-001 se cuenta por el protocolo de validación previo a entrega, no como resultado
logrado ni KPI pospublicación. Los controles compartidos se prueban en su frontera;
no se implementa el contenido de otros módulos en F01.

| Control | Antes | Después | Evidencia documental |
| --- | --- | --- | --- |
| RF-01/02/03 | Cobertura con ambigüedades | Cubiertos con precisiones U1/A1 | T014–T033, spec/contrato revisados. |
| RF-05/17 | Cubiertos | Cubiertos | T017/T029/T030/T034. |
| RNF-01–08 | Cubiertos nominalmente | Cubiertos; criterios de calidad explícitos | T005–T013/T036–T042; criterios del plan. |
| RNF-09 | Sin medición específica | Cubierto | T045 y sus dependencias de consolidación. |
| SC-001–SC-005 | Cubiertos nominalmente | Cubiertos nominalmente | T031–T045, protocolo y trazabilidad. |

- Cobertura documental nominal: **19/19 = 100 %**, frente a 18/19 en el análisis inicial.
- **45 tareas**: IDs T001–T044 preservados, T045 añadido; todas sin ejecutar.
- **22 tareas HU-01**, 13 de setup/fundamentos y 10 transversales/cierre.
- Cinco hallazgos originales corregidos en propuesta; no se detectan nuevos hallazgos
  críticos/altos documentales dentro de esta revisión. Esto no certifica seguridad del código.
- Sin cambios a la constitución, código de app, migraciones desplegadas ni sonda previa.
- Enlaces, IDs, rutas de entregables y dependencias revisados; T045 debe completarse
  antes de T043/T044 aunque su ID sea posterior para conservar referencias estables.

## Límites y puerta de aprobación

Las 21 comprobaciones del proveedor conservan su alcance original. No se volvieron a
correr ni se amplían por editar documentos: no validan trigger, rendimiento, contraste
ni cambios de UI aún inexistentes. La implementación debe ejecutar las pruebas nuevas.
Las dependencias reales de dispositivos, macOS, SMTP, responsable y conservación
siguen vigentes; no se inventa evidencia para cerrar esas puertas.

El usuario ratificó explícitamente las correcciones del spec/plan y aprobó las 45
tareas el 2026-10-27 mediante «lo apruebo», en respuesta a la solicitud relativa al
commit a7b99a4. La aprobación no se deduce de la autorización previa para editar.
No se ejecutaron tareas ni se amplía la evidencia de pruebas por registrar aprobación.
