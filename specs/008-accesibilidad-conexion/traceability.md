# Trazabilidad y evidencia — F08

**Fecha de ejecución automática:** 2026-11-09  
**Estado:** implementación automática y aceptación física satisfactorias.

**Aprobación del responsable:** el 2026-11-09 confirmó «sí, todas las pruebas
correctas, apruebo» después de validar los recorridos F08 en el dispositivo.

**Cierre autorizado:** el responsable solicitó cerrar F08, crear el commit y
sincronizarlo con el repositorio remoto el 2026-11-09.

| Requisito | Criterio | Implementación/prueba | Resultado |
| --- | --- | --- | --- |
| RF-16 | CA-08.1 | `TextScaleController`, selector de Perfil y pruebas de escala/persistencia | Aprobado automáticamente |
| RNF-02 | CA-08.1 | Suite previa de texto hasta 200 % más prueba global F08 a 150 % | Aprobado automáticamente |
| RNF-03/04 | CA-08.2 | Suite de accesibilidad, etiquetas, objetivos y contraste existente | Aprobado automáticamente |
| RF-17 | CA-08.3 | `ConnectivityController`, aviso y exclusión de doble reintento | Aprobado automática y físicamente |
| RF-17.b | CA-08.3 | Tips/Zyro conservan repositorios locales; suite completa sin regresiones | Aprobado automática y físicamente |
| Privacidad III | — | Búsqueda de escrituras persistentes y pruebas de F06 | Solo se añadió `priva.text_scale`; no se añadieron respuestas/resultados |

## Ejecuciones

- `flutter analyze`: **0 diagnósticos**.
- `flutter test --no-pub`: **241/241 pruebas satisfactorias** en la suite final.
- Pruebas nuevas F08: controlador, aviso accesible y alcance local satisfactorios.
- `git diff --check`: **sin errores de espacios**.
- APK: no generado en esta máquina porque no hay Android SDK configurado; Flutter
  está disponible en `C:\Users\User\guardar\flutter`.

## Evidencia manual ejecutada

El responsable confirmó el 2026-11-09 la ejecución en Motorola G22, Android 12:

1. Probar Pequeño, Normal, Grande y Muy grande desde Perfil.
2. Cerrar sesión y cerrar la app; confirmar que conserva el tamaño.
3. Activar modo avión; confirmar que Tips y Zyro siguen funcionando.
4. Intentar una operación remota, comprobar el aviso, recuperar Internet y reintentar
   una sola vez, incluido un doble toque rápido.
5. Recorrer con TalkBack y confirmar que no hay texto cortado ni controles ocultos.

Resultado comunicado: los tamaños funcionan y se conservan; modo avión, Tips, Zyro,
aviso, recuperación, doble reintento y recorrido restante funcionan correctamente,
sin errores informados.

Confirmación adicional del responsable el 2026-11-09:

- El aviso aparece al perder Internet y TalkBack lee todo el contenido.
- Se muestra “Intentando de nuevo…” y el doble toque no repite la operación.
- Tips y Zyro funcionan en modo avión.
- El cuestionario se pausa correctamente y aplica el descarte previsto.
- Las operaciones comprobadas no presentaron pausas, duplicados ni errores.

Esta aceptación física cubre Motorola G22 con Android 12. La matriz separada API24/API36
y ambas resoluciones fue confirmada posteriormente por el responsable como ejecutada
y satisfactoria, sin defectos informados.

## Matriz y rendimiento confirmados

El responsable confirmó el 2026-11-09 que probó satisfactoriamente:

- Android API24 y API36 con las resoluciones 320×720 y 412×915.
- Los tamaños 90 %, 100 %, 125 % y 150 %.
- Cambio de escala dentro del presupuesto aprobado.
- Aviso de desconexión dentro del presupuesto aprobado.
- Recorridos fluidos con el objetivo de rendimiento aprobado.

No se informaron pausas, recortes, duplicados ni errores durante estas comprobaciones.
