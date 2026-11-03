# Contratos F03 — interfaz de usuario y fronteras internas

**Estado**: propuestos para aprobar con el plan. No API de servidor nueva.
Referencias: [spec](../spec.md), [modelo](../data-model.md).

## C1 — Resolver destino y comprobar acceso

| Rutas canónicas | Sección activa | Visitante/no habilitado | Sesión habilitada |
| --- | --- | --- | --- |
| /signin, /signup, /confirm, /recovery | Ninguna | Flujos de entrada F01 con sus propias precondiciones | Mantener flujos existentes; no conceder otra identidad por visitarlos |
| /tips | Tips | Permitido | Permitido |
| /tips/passwords, /tips/sharing, /tips/links, /tips/profiles | Tips | Permitido | Permitido |
| /home | Inicio | Requiere acceso | P01 |
| /profile | Perfil | Requiere acceso | Perfil propio F02 |
| /chat | Chat IA | Requiere acceso | Destino F05, no simular contenido no entregado |
| /questionnaire | Cuestionario | Requiere acceso | Entrada F06, no simular cuestionario real |
| /results | Cuestionario | Requiere acceso | Solo si existe resultado temporal vigente de esa sesión |
| Cualquier otra ruta | Ninguna | Estado seguro / volver al acceso o Tips | Estado seguro / volver a Inicio o Tips |

**Entrada:** path de navegación y estado vigente. **Salida:** destino reconocido,
acceso requerido, precondición incumplida o desconocido. `available` distingue módulo
entregado de marcador honesto; una sesión no transforma un marcador en funcionalidad.
Un builder inyectado solo se invoca después de validar catálogo, acceso y resultado.
No aceptar UID de parámetros, query o argumento. Ninguna entrada arbitraria crea
rutas permitidas por autenticación. No registrar path bruto desconocido.

**Cobertura:** RF-05.a/b/e/g, CA-03.1/03.4/03.5/03.6/03.9, CA-ACC-01–05.

## C2 — Navegación e historial

**Entrada:** destino o back, fuente tarjeta/cabecera/menú/sistema y contexto vigente.
La fuente sirve para test, no se transmite ni persiste. La vista real determina
selección; seleccionar ruta activa no cambia pila. Destino existente usa retorno
a su entrada, nuevo usa push. Las acciones de salida se validan antes de retirar
rutas, incluso si se vuelve a una entrada ya existente.

- Tarjeta y menú de cada herramienta comparten una intención y un destino.
- Detalle Tips abre/vuelve a su catálogo lógico; si se entra directamente se crea
  ese padre sin introducir otro catálogo duplicado. Pila raíz sin padre permite salir.
- Ruta desconocida, resultado ausente y módulo pendiente tienen mensaje sencillo
  y acción válida; no muestran datos de ejemplo como reales ni estado de éxito falso.
- Login exitoso y cierre F01/F02 conservan su cambio de pila; el observer refleja
  esos cambios sin volver a emitirlos indefinidamente.
- Pérdida/cambio de sesión oculta privado antes de pintar la siguiente vista y limpia
  historial privado en transición segura fuera de build. Nunca se conserva una
  ruta sensible como mecanismo para restaurar el contexto de la cuenta anterior.
- Doble pulsación mientras se decide una salida no crea diálogos ni pushes duplicados.
  Al resolver se comparan UID, permiso y generaciones de navegación/recorrido.

**Cobertura:** RF-05.b/c/e, CA-03.2/03.3/03.4/03.6/03.9, SC-03.1/03.2.

## C3 — Guard de salida del Perfil

**Entrada:** intención voluntaria de dejar Perfil, estado actual de F02.
**Salida:** allow o blockSaving con aviso. Aplicar a back, cabecera, menú y retorno
a una ruta existente. Perfil unknown puede salir; el resultado de una transacción
no se presume cancelado. Invalidar/cerrar sesión no queda bloqueado por saving.

Mantener RouteObserver PageRoute de F02: cubrir por otra página desactiva y limpia
borrador; regresar reactiva/consulta; un diálogo no se trata como cambio de página.
No reutilizar el guard temporal del cuestionario para borrar o cancelar datos remotos.

**Cobertura:** RF-05.b/c, CA-03.3/03.6 y contrato vigente F02.

## C4 — Recorrido temporal y salida voluntaria

El puerto expone fase idle/attempt/result, `canGoToPreviousQuestion`, generación,
`previousQuestion()` y `discard(reason)`. `reason` es un enum de evento, sin contenido
personal. Ningún método entrega respuestas/resultados ni escribe almacenamiento.
Puerto vacío en producción F03; doble sintético en pruebas. La fase result solo puede
ser ofrecida por un adaptador válido del módulo, nunca mediante ruta o flag de usuario.

| Acción | idle | attempt | result |
| --- | --- | --- | --- |
| Seleccionar misma vista | No-op | No-op, no reiniciar | No-op |
| Back | Historial o salida Android | Pregunta anterior si existe; si no, confirmar salida | Descartar y volver a destino permitido, sin revivir intento |
| Seleccionar otro destino | C2 | Advertir: «Si sales, se descartarán tus respuestas. ¿Quieres salir?», Cancelar/Salir | Descartar antes de navegar |
| Invalidación de acceso | Limpiar privado | Descartar sin diálogo | Descartar sin diálogo |

El diálogo solo conserva la intención, nunca respuestas. Cancelar con contexto
vigente conserva vista y estado. Salir ejecuta descarte sincrónico antes del cambio.
Una respuesta tardía con generación/UID diferente no hace nada. Se invalida y cierra
el aviso si la app abandona primer plano o pierde sesión. Al retroceder desde
resultado no volver a un cuestionario completado con selecciones anteriores; la
entrada posterior comienza sin estado del intento anterior.

**Cobertura:** RF-05.d/g, CA-03.7/03.8, CA-ACC-03/04, SC-03.3.

## C5 — Ciclo de vida

Un observador raíz recibe eventos Flutter. `inactive` oculta contenido sensible;
`hidden`, `paused`, `detached` y dispose ejecutan descarte idempotente e invalidan
intención pendiente. `resumed` no restaura estado eliminado. No cerrar la sesión
por este evento ni llamar a Firebase para conservar respuestas. Si el proceso muere
sin notificación, nueva instancia con puerto idle y sin restauración.

La red en primer plano no se traduce a un evento de descarte/pausa: PD-10 se decide
con F06. Las pruebas verifican Home, recientes, notificación y relanzado; simular
un evento no certifica haber probado Android real ni haber integrado F06/F07.

**Cobertura:** RF-05.d/g, CA-03.6/03.8, principio III, SC-03.3.

## C6 — Presentación, semántica y medición

Cabecera Inicio/Perfil y menú Tips/Chat IA/Cuestionario, visibles en P11 según diseño;
ninguno seleccionado en P11. P01 selecciona Inicio, P12 Perfil; detalles y resultados
heredan su sección. Anunciar etiqueta y selección una sola vez. Forma/borde/peso
señala selección además del color. Objetivos≥48dp; contraste4.5:1 normal y3:1
grande/componentes; texto200% sin ocultar acciones a320dp. Mantener textos P01
aprobados, sin garantías ni nuevas ilustraciones inferidas.

Medir con reloj monotónico desde pulsación hasta feedback y vista/aviso, no desde
el inicio de un futuro irrelevante. Excluir espera humana al confirmar, registrando
por separado respuesta de la app tras decidir. Registrar solo métricas agregadas
y etiquetas de escenarios, sin rutas con parámetros o contenido temporal.

**Cobertura:** RF-05.a/e/f, CA-03.1/03.2/03.4/03.9/03.10, SC-03.4/03.5.

## Trazabilidad de aceptación prevista

| CA | Contrato | Prueba prevista / evidencia |
| --- | --- | --- |
| CA-03.1 | C1/C6 | P01/P11 y cinco controles; P10 sin extensión del menú |
| CA-03.2 | C2/C6 | Selección visual y semántica tras push/pop/replace |
| CA-03.3 | C2/C3 | Detalle→catálogo,20 reselecciones, A→B→A, raíz sale, Perfil saving |
| CA-03.4 | C1/C2/C6 | Tres tarjetas con texto aprobado y destinos equivalentes |
| CA-03.5 | C1/C2 | Matriz visitante/no habilitado; mensaje y Tips público |
| CA-03.6 | C1/C2/C3/C5 | Invalidación y UID A→B; limpieza de vista/pila y regresión F01/F02 |
| CA-03.7 | C4 | Doble sintético: revisión, salida cancelada/confirmada; integración posterior F06 |
| CA-03.8 | C4/C5 | Resultado, eventos y relanzado sin restauración; integración posterior F06/F07 |
| CA-03.9 | C1/C2 | Desconocido y resultados sin precondición, cero builders indebidos |
| CA-03.10 | C6 | Guidelines, matriz texto/objetivos/contraste y TalkBack nativo |
| CA-ACC-01–05 | C1/C2/C4 | Todos los destinos/estados, acceso directo, retroceso y sesión invalidada |
| SC-03.1–03.5 | C1–C6 | Matriz de acceso, historial, descarte, accesibilidad y protocolo21/30 |

Al ejecutar, cada prueba tendrá nombre estable y resultado satisfactorio/fallido/
pendiente/bloqueado/reportado por usuario. Esta tabla describe cobertura prevista,
no evidencia obtenida. Los contratos sintéticos se etiquetan como tales y no cierran
la integración real ni la aceptación funcional de F04–F07.
