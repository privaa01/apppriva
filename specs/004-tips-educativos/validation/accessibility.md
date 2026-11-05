# F04 — accesibilidad local y pendientes nativos

Fecha2026-11-05.20 escenarios widget: catálogo+4 detalles×320×720/412×915dp×
texto100%/200%. Densidad de prueba3, fuentes Roboto/MaterialIcons oficiales cargadas.
Satisfactorios: sin recortes/errores de layout;48dp, nombres específicos de acciones,
expansión legible y guías de contraste normal4.5:1/grande3:1. Sin formularios nuevos.

La prueba detectó bajo contraste rasterizado de rótulos finos en412dp con fuente
real; se reforzó tamaño/peso de navegación de Tips y se mantuvo la geometría previa
 en otras pantallas. No se redujeron umbrales ni se deshabilitaron aserciones.
La suite completa posterior fue satisfactoria en el baseline previo a la migración
al asset. Las capturas son sintéticas, no pruebas en un móvil físico ni TalkBack.

Pendiente: TalkBack, foco/lectura real y navegación nativa en al menos un Android
físico. No hay dispositivo Android conectado; no hay aceptación automática de estas
pruebas por sus resultados semánticos. Las excepciones F03 no se heredan.

**Prueba física reportada,2026-11-05:** el responsable activó TalkBack en un Motorola
G22 con Android12 y reportó funcionamiento correcto del recorrido, lectura, foco,
acciones, expansión y navegación, sin pausas ni errores. No se guardaron datos de
cuenta ni grabaciones. T029 se considera satisfecha mediante aceptación manual.
