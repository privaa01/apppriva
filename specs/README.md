# Priva — especificaciones por funcionalidad

## Alcance de plataforma vigente — 2026-10-28

Decisión explícita del usuario: «solo preparala para android». Esta entrega se
prepara únicamente para Android (mínimo API24 del plan); iOS, VoiceOver y Xcode
quedan fuera del alcance actual. Las menciones anteriores a ambas plataformas
son históricas. Se mantienen todos los requisitos funcionales, de privacidad y
seguridad aplicables a Android. No implica aprobación de otros specs ni entrega.

**Estado:** F01 cuenta con conformidad funcional comunicada por el usuario,
69 pruebas locales satisfactorias y limitaciones de evidencia técnica conservadas;
pruebas de reglas aplazadas explícitamente. El usuario autorizó avanzar a F02 el
2026-10-29. F02 revisado y aclarado, pendiente de aprobación de su spec antes del
plan. F03–F08 siguen en borrador. No se declara ejecución de mediciones no realizadas.
**Actualización:** 2026-10-29.

Cada carpeta contiene `spec.md` y `checklists/requirements.md`, conforme a la estructura
de Spec Kit. Los documentos se trasladaron desde `docs/descomposicion/` para mantener
una única versión de cada spec activo. No se crearon ramas por funcionalidad.

| ID | Spec | Alcance y pantallas | RF / HU |
| --- | --- | --- | --- |
| F01 | [Cuenta y acceso](001-cuenta-acceso/spec.md) | Registro P10, acceso P11 y recuperación | RF-01–03 / HU-01 |
| F02 | [Perfil y gestión de cuenta](002-perfil-cuenta/spec.md) | Perfil P12, cierre y eliminación; sin teléfono | RF-02,04 / HU-02 |
| F03 | [Inicio y navegación](003-inicio-navegacion/spec.md) | Navegación, sesión, retroceso y restricciones | RF-05 / HU-03 |
| F04 | [Tips educativos](004-tips-educativos/spec.md) | Catálogo P02 y detalles P03–P06; acceso público | RF-06 / HU-04 |
| F05 | [Zyro](005-zyro-orientacion/spec.md) | Chat P07 y orientación verificada | RF-07–09 / HU-05 |
| F06 | [Cuestionario temporal](006-cuestionario-temporal/spec.md) | P08, banco, selección, respuestas y descarte | RF-10–11,15 / HU-06 |
| F07 | [Resultados y repetición](007-resultados-repeticion/spec.md) | P09, cálculo, recomendaciones y nueva selección | RF-12–15 / HU-07 |
| F08 | [Accesibilidad y conexión](008-accesibilidad-conexion/spec.md) | Texto, foco, teclado, compatibilidad y recuperación de red | RF-16–17 / HU-08 |

RF-02 se divide entre acceso/recuperación (F01) y cierre (F02). RF-15 une la
temporalidad del intento (F06) y del resultado (F07). F08 es transversal y no debe
posponerse hasta después de implementar las demás funcionalidades. Los números son
identificadores, no prioridades ni una aprobación del orden de implementación.

## Decisiones que se mantienen

- Sin sesión se consulta Tips y sus cuatro categorías; registro, acceso y recuperación
  permanecen disponibles como flujos de entrada.
- Con sesión se habilita toda la app dentro del alcance y las precondiciones de cada
  función. Perfil permite gestionar únicamente la cuenta propia.
- Se conserva la navegación del wireframe de acceso, sin conceder contenido protegido
  por el hecho de mostrar sus controles.
- Priva no pide teléfono. No se presupone recuperación por SMS.
- Cuestionario y resultados son temporales, sin persistencia ni envío de respuestas a IA.
- Fórmula propuesta, proveedores, retención del chat y demás PD conservan su estado
  pendiente. Esta separación no selecciona tecnologías ni aprueba reglas propuestas.

## Cómo trabajar con Spec Kit

La funcionalidad inicialmente seleccionada en `.specify/feature.json` es F01,
solo para que los comandos localicen su directorio. Esto no aprueba su spec.
Para trabajar otra funcionalidad, indicar explícitamente su directorio, por ejemplo
`SPECIFY_FEATURE_DIRECTORY=specs/004-tips-educativos`, en la sesión que ejecute los
scripts de Spec Kit. No se debe inferir el directorio a partir de la rama `work`.

1. Revisar y ratificar la [constitución](../.specify/memory/constitution.md).
2. Elegir una funcionalidad y revisar su `spec.md` y checklist. Usar
   `$speckit-clarify` para resolver las ambigüedades del spec seleccionado.
3. Obtener aprobación explícita del spec y de las decisiones necesarias de la etapa.
   Un checklist o un commit no sustituyen esa aprobación.
4. Después de aprobar, usar `$speckit-plan`; revisar y aprobar el plan antes de tareas
   e implementación. No avanzar al siguiente spec o etapa con bloqueos pendientes.
5. Hacer commit y sincronizar los cambios de cada etapa, manteniendo trazabilidad
   RF/RNF → HU/CA → tareas → pruebas y resultados.

No es necesario volver a ejecutar `$speckit-specify` para volver a crear estos mismos
archivos. Si cambia el alcance, actualizar el spec correspondiente conservando sus IDs
y su historial; no generar una funcionalidad duplicada.

## Fuentes y revisión

- [Spec original, conservado sin modificaciones](../docs/referencias/PRIVA_MOBILE_SPEC.md).
- [Wireframes originales](../docs/referencias/app.pdf).
- [Revisión y decisiones de las pantallas nuevas](../docs/referencias/ACTUALIZACION_PANTALLAS_2026-10-26.md).
- [Mapa completo de pantallas, discrepancias y pendientes](../docs/descomposicion/README.md).

Los extractos compartidos conservados dentro de los specs aportan contexto, no
asignan toda una sección a una sola funcionalidad. Los requisitos de la tabla de
este índice delimitan cada capacidad; los controles de privacidad y seguridad son
transversales. Los archivos originales son antecedentes: las decisiones explícitas
posteriores registradas en los specs prevalecen en los puntos modificados.
