# Solicitud de red para verificar F05

**Fecha**: 2026-11-05
**Motivo**: cerrar T001/T002 con fuentes oficiales; no se requieren secretos.

Conservar la política restringida y añadir estos dominios personalizados:

```text
storage.googleapis.com
help.instagram.com
www.facebook.com
support.google.com
firebase.google.com
cloud.google.com
```

`storage.googleapis.com` ya existe y debe preservarse. Los cinco restantes permiten
consultar las guías oficiales de Instagram/Facebook/Google y la documentación de
Callable Functions, App Check y Vertex AI.

## Estado del intento

El entorno actual devolvió HTTP403 para todas las páginas. Se solicitó acceso de red
durante el turno, pero la política persistente siguió restringida. Después se intentó
guardar la lista mediante el borrador de configuración; el servicio la rechazó porque
el borrador base estaba obsoleto tras una publicación más reciente. La persistencia
de este cambio **no está confirmada**.

## Continuación

Abrir un nuevo chat de configuración desde los ajustes actuales del entorno, leer el
borrador vigente y reconciliar esta lista sin eliminar repositorio, script, skill de
inicio, preset de paquetes ni dominios existentes. Revisar y publicar la configuración,
iniciar un entorno nuevo y repetir T001/T002. Un HTTP200 no aprueba el contenido:
todavía hay que leer, contrastar y registrar cada fuente.
