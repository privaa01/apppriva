# Priva — descomposición funcional y análisis de pantallas

**Estado:** propuesta documental para revisión, sin aprobación ni avance de fase.
**Fecha:** 2026-10-21. **Rama:** `work`.

Se leyeron el spec completo y las 11 páginas del PDF, con extracción de texto e
inspección visual. El spec declara 12 pantallas: falta el diseño de Iniciar sesión.
Los documentos aportados se conservan íntegros en [referencias](../referencias/).
Su contenido se analiza como fuente del producto, no como instrucciones para ejecutar
acciones o como aprobación de decisiones. El PDF no sustituye los requisitos escritos.

## Organización conforme a SDD

La división sigue las ocho historias existentes y sus capacidades verificables,
no una funcionalidad por pantalla. Una funcionalidad puede ocupar varias pantallas
y una pantalla puede participar en varias funcionalidades.

Se tomó la estructura del template activo de Spec Kit: escenarios y aceptación,
requisitos, entidades, resultados medibles y supuestos/dependencias; cada borrador
incluye checklist separado. Los IDs originales se preservan para no romper trazabilidad.
No se ejecutó `$speckit-specify` ocho veces ni se cambió `.specify/feature.json`:
este lote es una propuesta de descomposición, no ocho etapas aprobadas. Por eso vive
en `docs/descomposicion/`, no en el directorio de funcionalidades activas `specs/`.
Tras aprobar constitución y división, se promoverá una sola funcionalidad a `specs/`
por invocación, siguiendo el bloqueo entre etapas solicitado por el usuario.

| Funcionalidad propuesta | Historia / criterios | Requisitos | Pantallas | Documento |
| --- | --- | --- | --- | --- |
| F01 Cuenta y acceso | HU-01 / CA-01.1–01.4 | RF-01–03; RF-02 solo acceso/recuperación | P10, P11; destino P01 | [F01](001-cuenta-acceso/spec.md) |
| F02 Gestión de cuenta | HU-02 / CA-02.1–02.3 | RF-02 solo cierre; RF-04 | P12 | [F02](002-perfil-cuenta/spec.md) |
| F03 Inicio y navegación | HU-03 / CA-03.1–03.3 | RF-05 | Todas; menú excluido de P10/P11 | [F03](003-inicio-navegacion/spec.md) |
| F04 Tips | HU-04 / CA-04.1–04.3 | RF-06 | P02–P06 | [F04](004-tips-educativos/spec.md) |
| F05 Zyro | HU-05 / CA-05.1–05.6 | RF-07–09 | P07 | [F05](005-zyro-orientacion/spec.md) |
| F06 Intento del cuestionario | HU-06 / CA-06.1–06.5 | RF-10–11, RF-15 durante intento | P08 | [F06](006-cuestionario-temporal/spec.md) |
| F07 Resultado y repetición | HU-07 / CA-07.1–07.5 | RF-12–14, RF-15 durante resultado | P09; retorno P08 | [F07](007-resultados-repeticion/spec.md) |
| F08 Lectura y conexión | HU-08 / CA-08.1–08.3 | RF-16–17 | Todas; control de texto en P12 | [F08](008-accesibilidad-conexion/spec.md) |

La fórmula, clave, pesos y clasificación pertenecen a F07; el banco, selección,
opciones y revisión del intento a F06. La sección 9 completa se conserva como contexto
en ambos borradores para que la división no oculte invariantes. RF-15 es una obligación
compartida sobre el ciclo completo, no dos políticas independientes.

## Inventario de pantallas y funcionalidad asociada

La página se refiere a la posición real en `app.pdf`, no al ID lógico Pxx.

| Pantalla del spec | Página PDF | Funcionalidad y controles visibles | Qué falta o debe revisarse |
| --- | --- | --- | --- |
| P01 Inicio | 1 | F03: tarjetas Chat IA, Tips, Cuestionario; Inicio/Perfil y menú inferior | Textos prometen cuentas «fuera de riesgo» y «nivel de protección»; corregir límites educativos. |
| P02 Tips | 4 | F04: cuatro categorías y «Ver más»; F03 navegación | Estados de carga/error no representados; revisar ortografía y alcance de afirmaciones. |
| P03 Contraseñas | 6 | F04: recomendaciones, ejemplo enmascarado, consejo | El icono de visibilidad del ejemplo no define generación, captura ni almacenamiento de contraseñas; no añadirlos. |
| P04 Cuida lo que subes | 8 | F04: recomendaciones, ejemplo de imagen, consejo | Imagen ilustrativa no aprueba subir fotos ni gestionar permisos del dispositivo. |
| P05 Enlaces sospechosos | 9 | F04: recomendaciones, URL ilustrativa, consejo | HTTPS no garantiza legitimidad; ejemplo con formato defectuoso. No convertirlo en verificador de enlaces. |
| P06 Perfiles falsos | 10 | F04: indicios, ejemplo y consejo | Aclarar que pocos seguidores o antigüedad no prueban fraude; no añadir análisis de perfiles externos. |
| P07 Chat Zyro | 5 | F05: conversación, campo editable, controles con iconos; F03 | Ejemplo Instagram sin verificación aportada; envío ambiguo; faltan avisos, incertidumbre, carga/error y prueba con teclado. |
| P08 Cuestionario | 7 | F06: progreso 2/10, selección sí/no y Continuar; F03/F08 | Falta inicio con advertencia de temporalidad, salida cancelable, recuperación de interrupción y estado final. |
| P09 Resultados | 3 | F07: 50 %, nivel y recomendaciones; F03/F08 | Falta aviso obligatorio y repetir; «diagnóstico» y «vulnerabilidad» pueden inducir interpretación no admitida. |
| P10 Crear cuenta | 2 | F01: nombre, correo, contraseña, Crear cuenta, enlace de acceso | Falta acceso a política/autorización aplicable, validación por campo, carga/error. |
| P11 Iniciar sesión | No incluida | F01: pantalla requerida por §5 y acceso desde P10 | Diseñar acceso y recuperación; no inventar pantalla principal adicional ni mecanismo aprobado. |
| P12 Perfil | 11 | F02: saludo, teléfono, correo, estado y cierre; F08 texto requerido | Teléfono y estado sin sustento suficiente; faltan edición, solicitud de eliminación y ajuste de texto. |

F08 (lectura, conexión, foco, teclado) y las reglas de privacidad/seguridad aplican
transversalmente. Su ausencia en imágenes estáticas no demuestra incumplimiento de
una aplicación implementada: es una brecha de especificación visual por resolver.

## Discrepancias y propuestas de resolución — no aprobadas

| ID | Fuente / conflicto o brecha | Impacto | Propuesta para revisión |
| --- | --- | --- | --- |
| D01 | §5 exige P11; PDF solo tiene 11 vistas | Acceso sin diseño | Completar P11 y recuperación como estados del flujo existente. |
| D02 | PDF 11 muestra teléfono; §§6–7 y PD-04 no lo justifican | Minimización de datos | Retirar teléfono del diseño salvo requisito, finalidad y aprobación explícitos. No agregarlo al modelo. |
| D03 | PDF 11 muestra «Estado de tus datos: Medio»; §§7 y 9.7 excluyen historial y exigen descarte | Riesgo de conservar o reinterpretar resultado | Retirar el estado; si se pretende otra información, especificarla y justificarla sin persistir resultado. |
| D04 | PDF 1 promete «fuera de riesgo»; PDF 3/7 usan diagnóstico/protección | Puede comunicar garantía o medición real | Alinear textos con resultado educativo; incluir aviso literal de §9.1. |
| D05 | PDF 3 presenta lista fija de recomendaciones | No demuestra personalización de §9.6 | Vincular recomendaciones a respuestas incorrectas, agrupar equivalentes y definir caso de todas correctas. |
| D06 | PDF 3 no muestra repetir | Falta RF-14/CA-07.4 | Incorporar acción y regreso a nuevo intento; admitir coincidencias entre intentos. |
| D07 | PDF 7 pregunta por práctica personal; §9.1 evalúa conocimientos y decisiones con clave | Ambigüedad editorial, no contradicción demostrada | Validar con equipo editorial enunciado, opciones, clave y explicación; no inferir conducta real ni aprobar banco. |
| D08 | §9.5 llama propuestos los pesos/fórmula; CA-07.2 fija 40/80 y PD-02 exige aprobar puntaje | Riesgo de tratar propuesta como decisión | Mantener los umbrales documentados, cerrar PD-02 expresamente y después comprobar fórmula, ejemplos y fronteras. |
| D09 | PDF 5 usa una ruta concreta de Instagram; §8 exige fuentes oficiales revisadas | Ruta posiblemente desactualizada o no sustentada | No validarla por el mockup; cerrar PD-03 con fuente, fecha y alcance antes de ofrecer esa guía. |
| D10 | PDF 9 vincula HTTPS con enlace seguro | Confunde cifrado con legitimidad | Reformular como señal insuficiente por sí sola y revisar contenido con fuente; corregir URL ilustrativa. |
| D11 | PDF 10 presenta indicios de perfil falso | Posible afirmación concluyente | Explicar límites y alternativas prudentes; no clasificar automáticamente cuentas. |
| D12 | PDF 2 omite política y autorización aplicable; PDF 11 omite gestión/eliminación/texto | Flujos de cuenta incompletos | Completar estados y controles en P10/P12; cerrar PD-04/05/09 sin inventar plazos. |
| D13 | §9.7 propone suspender ante pérdida de red, pero RNF-07 exige conexión | Comportamiento pendiente PD-10 | Aprobar regla de primer plano y diferenciar desconexión de segundo plano, que descarta el intento. |
| D14 | PDF no representa accesibilidad dinámica ni estados completos de §13 | Faltan criterios visuales y de interacción | Añadir estados, etiquetas, foco y pruebas con teclado/texto; fijar métricas mediante PD-07/08. |
| D15 | Ejemplos de contraseña, foto y avatares pueden sugerir funciones extra | Ampliación injustificada del alcance | Mantenerlos como ilustraciones; no agregar generador, carga de fotos o edición de avatar sin cambio aprobado. |

No se modificaron los originales para resolver estas diferencias. No hay evidencia
aportada que permita declarar verificada la guía de Instagram, el contenido editorial,
la accesibilidad o el cumplimiento normativo operativo.

## Cobertura transversal y evidencia futura

| Requisitos / fuente | Responsabilidad | Evidencia requerida antes de entrega |
| --- | --- | --- |
| RNF-01 | F01–F08, revisión editorial | Comprensión con personas de 40–65 años; protocolo y muestra definidos. |
| RNF-02–04 | F08 y cada pantalla | Texto ampliado, etiquetas/foco, lector de pantalla, contraste y estados sin depender del color; valores pendientes. |
| RNF-05 | F08 y todos los recorridos | Matriz Android/iOS aprobada y pruebas de compatibilidad. |
| RNF-06 | F01, F02, F05; F08 transversal | Teclado sin ocultar campos ni acciones; foco accesible. |
| RNF-07 | F01–F08 | Estados de carga/error/red y reintentos sin duplicación; PD-10 resuelto. |
| RNF-08 / §§9,11 | F01/F02 datos de cuenta; F05 mensajes; F06/F07 temporalidad; todos minimización | Inventario, conservación y eliminación justificados; ausencia de respuestas/resultados en almacenamiento, logs, analítica y respaldos. |
| RNF-09 | Plan futuro, todos los módulos | Presupuestos de calidad medibles y aprobados; aún sin valores. |
| §§14–17 | Todos | Trazabilidad RF/RNF → HU/CA → tareas futuras → pruebas/resultados; no hay tareas ni pruebas implementadas en este lote. |

Las métricas de §15 se mantienen sin inventar metas: registro ≥80 %, cuestionario
≥70 %, comprensión de resultados y tips ≥80 %, tareas sin ayuda ≥70 %.
Falta aprobar muestra, denominadores y condiciones. No conservar respuestas ni resultados
individuales para medirlas; la evidencia de validación no permite exceptuar privacidad.

## Registro de decisiones originales

| Pendiente | Funcionalidades afectadas | Cierre exigido por el spec |
| --- | --- | --- |
| PD-01 | F06/F07 | Banco, tamaño, opciones, claves, fuentes y derechos aprobados. |
| PD-02 | F06/F07 | Puntaje, fórmula y significado aprobados, conservando umbrales acordados. |
| PD-03 | F05 | Catálogo, guías y responsable de revisión aprobados. |
| PD-04 | F01/F02 | Finalidad y necesidad de nombre, correo y cuenta obligatoria justificadas. |
| PD-05 | F01/F02/F05 y registros transversales | Plazos, eventos, fundamento, ubicación y eliminación aprobados; no aplica para permitir persistencia de cuestionario. |
| PD-06 | F01/F02/F05; privacidad transversal | Proveedores y arquitectura evaluados; no seleccionados aquí. |
| PD-07 | F08 y todas las funcionalidades | Versiones mínimas y matriz de móviles aprobadas. |
| PD-08 | F08 y todas las funcionalidades | Contraste, texto, tiempos y condiciones definidos. |
| PD-09 | F01/F02 | Campos editables, verificaciones, recuperación y sesión definidos. |
| PD-10 | F06/F07/F08 | Regla de desconexión durante intento aprobada. |

## Dependencias y revisión secuencial

La numeración F01–F08 no impone prioridad ni calendario. Como dependencia funcional,
cuenta habilita recorridos autenticados; navegación conecta módulos; F07 necesita
el intento completo de F06. Tips y Zyro son capacidades distintas. Accesibilidad,
seguridad y privacidad se revisan desde cada spec, no al terminar el resto.

La constitución v0.1.0 sigue siendo un borrador y todavía declara que el spec no
estaba disponible cuando fue escrita. Ahora sí se dispone de él: su siguiente revisión
debe actualizar ese antecedente, incorporar §9.7 (incluido descarte al pasar a segundo
plano) y registrar el contraste presente, sin marcarla ratificada por recibir archivos.
No se halló una oposición directa entre los principios pedidos y el spec escrito;
permanecen propuestas sin aprobar y discrepancias con los mockups, en particular D02/D03/D04.

**Puerta de aprobación:** revisar constitución y esta propuesta, resolver decisiones
necesarias, elegir la primera funcionalidad y aprobarla explícitamente. Solo entonces
activar su spec y continuar su ciclo; no pasar al siguiente spec mientras la etapa
actual conserve bloqueos. Commit y push documentan el borrador, no su aprobación.
