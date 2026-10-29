# Contratos de comportamiento — Perfil y cuenta

Estado: propuesta de diseño pendiente de aprobación del plan.
Referencias: [spec](../spec.md), [modelo](../data-model.md).
No son APIs desplegadas ni código de implementación.

## C1 — Consultar Perfil (CA-02.1/02.4/02.5/02.8/02.9)

Entrada: ruta `/profile` con sesión normal vigente del001. El controlador captura
UID/generación; el repositorio deriva identidad de Auth y exige verificación,
password y evidencia válida. Leer perfil del servidor y email desde identidad.

Salida: datos propios confirmados o estado recuperable. Nunca valores de ejemplo,
contraseña, teléfono, puntuación o historial. Ante ausencia de sesión, la guarda
muestra acceso sin contenido privado. Datos ajenos/ruta manipulada denegados en
reglas además de UI. Si cambia UID durante espera, descartar respuesta y limpiar.

## C2 — Editar nombre (CA-02.6/02.7/02.8/02.9)

- Solo name en la UI; correo de lectura. Borrador ligado a UID en memoria.
- Guardar valida trim/no vacío y vuelve a comprobar autorización. Transacción lee
  perfil existente y actualiza solo name; no sobrescribe campos o evidencia.
- Éxito requiere respuesta de servidor y contexto vigente. Mostrar nombre confirmado
  y sincronizar saludo de esa sesión sin conceder permisos nuevos.
- Cancelar antes de guardar: cero escrituras, vuelve al valor confirmado.
- Fallo/offline: mantener confirmado y borrador recuperable para esa identidad.
- Doble pulsación: una sola operación activa. Timeout: no afirmar guardado ni
  cancelación; reconciliar servidor después de resolución antes de nuevo guardado.
- Salida/cierre/cambio UID: resultado tardío no repuebla pantalla ni crea sesión.
- La transacción ya enviada puede completar; nunca prometer rollback por salir.

**Contrato de reglas:** actualización solo del perfil propio verificado/password,
evidencia válida existente, claves afectadas solo name y nombre válido. Denegar
correo, UID, teléfono/campos extra, borrado, acceso ajeno y cualquier modificación
de evidencia. Mantener reglas de alta F01 sin cambios funcionales.

## C3 — Cerrar sesión (CA-02.2/02.10/02.11/02.12)

Acción explícita Cerrar sesión; reutilizar AccountController.signOut. Primero limpiar
acceso local/perfil/borrador, invalidar generaciones y sustituir historial privado
por acceso. Después esperar cierre de Auth. Aun con error de red no restaurar
contenido. Tips sigue público; otros destinos exigen acceso. No afirmar revocación
de todas las sesiones o borrado de datos. No crear datos de cuestionario para probar.

## C4 — Solicitud por correo (CA-02.3/02.13–02.17)

Informar equipo de Priva, canal público y necesidad de enviar la solicitud desde
correo de cuenta. Abrir URI mailto bajo pulsación con asunto/cuerpo genéricos
escapados. No enviar correo, crear expediente, borrar cuenta o modificar evidencia.

| Resultado del sistema | Respuesta permitida |
| --- | --- |
| Redactor abierto | Instrucción de completar/enviar en app de correo; no «solicitud enviada». |
| Usuario cancela | Datos/sesión sin eliminar; no afirmar recepción o borrado. |
| launchUrl false/excepción | Canal visible y acción Copiar correo. |
| Copia solicitada y exitosa | Confirmación accesible de dirección copiada. |
| Fallo al copiar | Mostrar dirección e informar para copiar/escribir manualmente. |

No adjuntar UID, nombre, correo de cuenta, credenciales, diagnósticos o cuestionario.
El soporte verifica identidad proporcionalmente y resuelve alcance/conservación;
F02 no define plazos ni implementa ese procedimiento fuera de app.

## C5 — Accesibilidad (CA-02.18/02.19)

Texto200%, pantalla pequeña/grande y teclado no impiden las acciones. Etiquetas para
campos/botones, orden de foco comprensible y anuncio de carga/error/éxito. Contraste
normal≥4.5:1, grande/componentes≥3:1; objetivos Android≥48dp. Verificar automáticos y
TalkBack real, sin presentar dobles como validación de plataforma o lectores.

## Cobertura para implementación

| Contrato | Tipos de pruebas requeridos |
| --- | --- |
| C1 | Consulta real DTO, vacío/error, 2UIDs, visitante/no verificado y cambio identidad. |
| C2 | Validación/cancelación/éxito/offline/doble envío/tardía; reglas directas y evidencia antes/después. |
| C3 | Error remoto, retroceso, rutas y limpieza de datos tras cierre. |
| C4 | URI/escape, apertura false/excepción, copia, cancelación sin eliminar y plataforma real. |
| C5 | Widgets, texto/teclado, contraste/targets y matriz/TalkBack documentados. |

Todas las pruebas del001 deben permanecer satisfactorias; F02 no habilita datos o
funcionalidades de otros módulos para cumplir estos contratos.

## Estado de aprobación actualizado

Este artefacto quedó incluido en el plan aprobado explícitamente por el usuario
el2026-10-29 sobre1d01d98. Sus advertencias de diseño pendiente describen el estado
previo; no existe implementación ni validación de F02 por esa aprobación.
