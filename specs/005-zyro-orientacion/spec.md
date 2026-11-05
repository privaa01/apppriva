# Feature Specification: F05 — Orientación confiable mediante Zyro

**Feature Branch**: `work` (selección por directorio)
**Created**: 2026-10-21. **Updated**: 2026-11-05
**Status**: Approved — especificación aprobada; autoriza plan, no tareas ni implementación
**SPECIFY_FEATURE_DIRECTORY**: `specs/005-zyro-orientacion`
**Input**: «continua con el spec 005»
**Fuentes**: [spec original §§5, 8, 11–18](../../docs/referencias/PRIVA_MOBILE_SPEC.md),
[wireframe P07, PDF5](../../docs/referencias/app.pdf),
[mapa de pantallas](../../docs/descomposicion/README.md) y
[constitución v1.1.0](../../.specify/memory/constitution.md).

## User Scenarios & Testing *(mandatory)*

### HU-05 — Consultar a Zyro (RF-07 a RF-09) (Priority: P1 propuesta)

Como persona con una cuenta habilitada, quiero consultar a Zyro sobre privacidad y
seguridad y recibir orientación sencilla que reconozca sus límites.

**Why this priority**: Zyro es la función de orientación de Priva y P07 ya está
conectada a la navegación protegida. La prioridad necesita aprobación con el spec.

**Independent Test**: iniciar sesión, abrir P07, revisar identidad/aviso, enviar
consultas sintéticas admitidas, no verificadas, dañinas y con datos sensibles;
forzar error y reintento. Verificar teclado, texto 200%, TalkBack, acceso y descarte
de conversación sin implementar cuestionario o resultados.

**Acceptance Scenarios**:

- **CA-05.1:** P07 muestra identidad de Zyro, función educativa, aviso de no compartir
  contraseñas/códigos/datos sensibles, campo de mensaje y control Enviar inequívoco.
- **CA-05.2:** Una consulta admitida recibe lenguaje sencillo, pasos breves cuando
  corresponde y una indicación clara de que la orientación no garantiza protección.
- **CA-05.3:** Una plataforma o ruta sin guía vigente produce un límite explícito;
  Zyro no inventa nombres de menús, URLs, consecuencias o pasos.
- **CA-05.4:** Una petición para vulnerar sistemas, acceder a cuentas ajenas, obtener
  datos privados o realizar daño se rechaza y ofrece una alternativa segura dentro
  del alcance. Asesoría jurídica/profesional individual se remite a un canal adecuado.
- **CA-05.5:** Carga, falta de conexión, demora y fallo muestran estados comprensibles.
  Reintentar la misma consulta no duplica el mensaje del usuario ni envía dos
  solicitudes simultáneas; una respuesta tardía no reemplaza una conversación nueva.
- **CA-05.6:** Con teclado abierto, texto al 200% y TalkBack se pueden leer los
  mensajes, editar la consulta, activar Enviar/Reintentar y cerrar el teclado sin
  ocultar el campo ni la acción principal.
- **CA-05.7:** Zyro nunca pide credenciales, códigos, documentos, datos financieros
  ni acceso a una cuenta. Si el mensaje parece contenerlos, detiene la orientación,
  muestra una advertencia y no los repite en la respuesta.
- **CA-05.8:** Zyro no abre enlaces, inspecciona perfiles, inicia sesión, elimina o
  desactiva cuentas, presenta denuncias ni cambia configuraciones. Las instrucciones
  se leen dentro de Priva y toda acción externa queda a cargo de la persona.
- **CA-05.9:** Una guía para eliminar/desactivar identifica plataforma, tipo de acción,
  fecha de revisión y alcance; distingue eliminar de desactivar y sus consecuencias
  verificadas. Una guía vencida o incompleta se trata como no disponible.
- **CA-05.10:** Sin sesión no se muestra P07; con sesión válida se permite. Cerrar
  sesión revoca acceso y elimina el estado temporal de conversación de Priva.
- **CA-05.11:** Los mensajes no se usan para personalizar Tips, cuestionario o perfil,
  no se envían al cuestionario y no aparecen en analítica o registros técnicos.
- **CA-05.12:** P07 conserva Inicio/Perfil y menú inferior, marca Chat IA como sección
  activa y permite salir conforme a F03 sin liberar otras funciones pendientes.

### Edge Cases

- Mensaje vacío, solo espacios o demasiado largo: no se envía y se explica cómo
  corregirlo sin perder silenciosamente lo escrito.
- Doble toque en Enviar durante carga: una sola consulta activa.
- Se abandona P07 o se cierra sesión con una solicitud pendiente: se invalida; su
  respuesta tardía no reaparece ni abre acceso.
- El proveedor responde con credenciales, enlaces accionables, certeza de fraude o
  pasos fuera del catálogo: validar y sustituir por un límite seguro, no mostrarlos.
- Consulta ambigua: pedir una aclaración mínima sin solicitar información sensible.
- Consulta de cuenta comprometida: ofrecer medidas iniciales generales y canales
  oficiales; no prometer recuperar la cuenta ni investigar el incidente.
- El teclado cambia tamaño/orientación: conservar campo y Enviar visibles mediante
  desplazamiento/foco; no crear una segunda pantalla.

## Requirements *(mandatory)*

### Functional Requirements

- **RF-07:** permitir consultas de privacidad y seguridad en los temas admitidos:
  contraseñas/2FA, privacidad y permisos, exposición, mensajes/enlaces/perfiles,
  cuenta posiblemente comprometida y conceptos generales de datos personales.
- **RF-08:** ofrecer dentro de P07 instrucciones revisadas para eliminar o desactivar
  cuentas del catálogo inicial aprobado.
- **RF-09:** manejar fuera de alcance, daño, incertidumbre, contenido no verificado,
  conectividad, demora y errores sin inventar ni duplicar orientación.
- **RF-07.a:** presentar identidad, alcance y aviso de datos antes del primer envío.
- **RF-07.b:** conservar orden conversacional comprensible y distinguir visual y
  semánticamente mensajes de la persona, Zyro, estados y errores.
- **RF-07.c:** limitar longitud/frecuencia antes del envío y bloquear solicitudes
  concurrentes; los valores exactos se fijarán en el plan.
- **RF-08.a:** cada guía publicada debe tener plataforma, acción, pasos, consecuencias,
  fuente oficial, versión/plataforma aplicable, fecha y responsable de revisión.
- **RF-08.b:** mostrar pasos dentro de Priva como texto; referencias son evidencia
  editorial y no enlaces obligatorios para completar la orientación.
- **RF-09.a:** aplicar límites antes y después de obtener respuesta, con respuestas
  seguras para credenciales, daño, asesoría individual y certeza no sustentada.
- **RF-09.b:** permitir reintento recuperable e impedir respuestas tardías o duplicadas.
- **RF-09.c:** no incorporar acciones externas, navegación web automática, archivos,
  cámara, micrófono, ubicación, contactos o lectura de otras aplicaciones.

### Pantalla y estados

| Pantalla / estado | Funcionalidad verificable |
| --- | --- |
| P07 inicial | Zyro, mensaje de presentación, aviso de datos, conversación vacía, campo y Enviar |
| P07 conversación | mensajes diferenciados, respuesta sencilla y pasos cuando corresponda |
| P07 carga | envío bloqueado, progreso anunciado y salida posible |
| P07 límite | incertidumbre, guía no disponible, fuera de alcance, daño o dato sensible |
| P07 error | mensaje sencillo y Reintentar sin duplicar |
| P07 teclado/texto 200% | campo y Enviar visibles, lectura/foco ordenados |

El wireframe PDF5 aporta composición, Zyro, conversación, campo y menú. Su ejemplo
de Instagram no prueba que la ruta esté vigente; «intagram/instragram» y el icono
ambiguo se corrigen. El control se rotula Enviar. No se agrega otra pantalla.

### Decisiones confirmadas — 2026-11-05

1. **Catálogo inicial:** Instagram, Facebook y Google. El plan debe investigar para
   cada plataforma las acciones de eliminar/desactivar que su fuente oficial realmente
   ofrezca. No se inventará una equivalencia: si Google u otra plataforma no ofrece
   una acción con ese nombre, Zyro lo explicará y solo mostrará la guía verificada.
2. **Ciclo de conversación:** temporal durante la sesión activa. Se conserva al
   navegar dentro de Priva y regresar a P07 mientras continúan la misma cuenta y el
   mismo proceso de la app. Se descarta al cerrar sesión, cambiar de cuenta, terminar
   el proceso o eliminar la cuenta. No se restaura tras reiniciar, no se guarda en
   archivos/base de datos y no existe historial permanente.
3. **Modelo híbrido:** guías fijas verificadas para eliminar/desactivar cuentas del
   catálogo e IA limitada para temas generales admitidos. La IA no puede alterar
   pasos de una guía, suplir una guía ausente ni ampliar el catálogo.

Estas decisiones fueron seleccionadas por el responsable como «1.C, 2.B, 3.A».
La selección del proveedor, arquitectura, ubicación, conservación del proveedor y
procedimiento de borrado pertenecen al plan posterior, pero deberán demostrar los
límites aprobados aquí antes de implementar. No se afirma que ningún proveedor
retenga cero datos.

### Out of Scope

Acceso o recuperación directa de cuentas, ejecución de eliminación/desactivación,
análisis de URLs/perfiles/archivos, navegación externa automática, asesoría legal o
forense individual, garantías de seguridad, moderación de contenido de terceros,
voz, adjuntos, historial/favoritos no aprobados, entrenamiento con mensajes de Priva,
uso de respuestas del cuestionario y funciones de F06–F08 aún no entregadas.

### Key Entities

- **Mensaje temporal:** rol, texto validado, orden y estado; nunca credencial.
- **Respuesta de Zyro:** orientación o límite, con estado de generación y trazabilidad
  interna de reglas aplicadas; no implica una acción externa.
- **Guía verificada:** plataforma, acción eliminar/desactivar, pasos, consecuencias,
  fuente oficial, fecha, versión aplicable, responsable y estado vigente/no disponible.
- **Conversación activa:** secuencia temporal y solicitud pendiente vinculada solo
  en memoria a la sesión/cuenta actual; no se restaura tras terminar el proceso.
- **Revisión editorial:** evidencia del catálogo; no historial de consultas.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-05.1:** el100% de escenarios admitido/no verificado/fuera de alcance/dañino/
  dato sensible produce el tipo de respuesta aprobado; cero pasos inventados,
  solicitudes de credenciales, acciones externas o garantías.
- **SC-05.2:** el100% de guías entregadas pertenece al catálogo aprobado y tiene
  fuente oficial, fecha, versión/plataforma y responsable; guías vencidas/incompletas
  producen límite, no instrucciones.
- **SC-05.3:** en20 ciclos de envío, doble toque, error y reintento hay una solicitud
  activa y un mensaje de usuario por intento; cero respuestas tardías visibles tras
  abandonar, cerrar sesión o iniciar conversación nueva.
- **SC-05.4:** en la matriz Android del plan, P07 inicial/conversación/carga/límite/
  error funciona a texto100% y200%; TalkBack distingue autor, estado, campo, Enviar
  y Reintentar, con objetivos táctiles y contraste aprobados.
- **SC-05.5:** al menos80% de cinco participantes de40–65 años completa sin ayuda:
  identificar el alcance, enviar una consulta, reconocer que no debe compartir
  credenciales, comprender un límite y diferenciar orientación de acción ejecutada.
  Solo se conservan conteos agregados, nunca mensajes o respuestas individuales.
- **SC-05.6:** la revisión de datos demuestra cero mensajes en analítica, logs,
  cuestionario o perfil y documenta para cada sistema/proveedor finalidad, campos,
  ubicación, conservación, eliminación y acceso antes de aprobar implementación.

## Assumptions

- Android únicamente, mínimo API24 vigente; público de40–65 años.
- P07 requiere cuenta habilitada y conexión; Tips continúa siendo el único contenido
  público. Se reutilizan sesión/navegación F01–F04.
- La imagen Zyro existente puede usarse en P07 conforme al wireframe; no se añade a
  otras pantallas por esta funcionalidad.
- Las fuentes y textos de guías se investigan y presentan como artefacto del plan;
  el mockup no constituye aprobación editorial.
- Los tiempos, límites de longitud/frecuencia, proveedor, matriz Android y protocolo
  detallado se fijan en el plan después de aprobar este spec.

## Conflictos, privacidad y trazabilidad

| Brecha | Resolución del spec |
| --- | --- |
| PDF5 da pasos Instagram sin fuente | Tratar como ejemplo; aprobar catálogo y contrastar fuente antes de entrega |
| PDF5 no muestra aviso, carga, límite o error | Añadir estados en P07 sin crear otra pantalla |
| Icono de envío ambiguo | Rotular semántica y visualmente «Enviar» |
| «Chat IA» puede sugerir ejecución | Explicar que orienta y no actúa en cuentas |
| Retención/proveedor pendientes | Resolver ciclo de Priva ahora y proveedor/ubicación/conservación en plan |
| Spec original menciona Android/iOS | Aplicar enmienda constitucional Android únicamente |

| Requisito | Criterios | Evidencia prevista |
| --- | --- | --- |
| RF-07 / 07.a–c | CA-05.1/2/6/7/10/12 | P07, acceso, teclado, semántica y validación |
| RF-08 / 08.a–b | CA-05.3/8/9 | catálogo y registro editorial con fuentes |
| RF-09 / 09.a–c | CA-05.4/5/7/8/11 | matriz de límites, errores, concurrencia y privacidad |
| SC-05.1–6 | HU-05 | automatización, Android, revisión editorial/datos y protocolo humano |

La especificación incorpora las tres decisiones del responsable y supera su revisión
documental. El 2026-11-05 el responsable la aprobó explícitamente con «apruebo».
Esta aprobación autoriza preparar el plan, no tareas, proveedor ni implementación.
