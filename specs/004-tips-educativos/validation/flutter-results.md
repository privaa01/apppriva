# Flutter F04 — resultados locales

## Revalidación pendiente por contenido empaquetado

El 2026-11-05 se sustituyó `FirestoreTipsRepository` por `BundledTipsRepository` y
se añadió el asset aprobado. Esta instancia Windows no dispone de Flutter/Dart, por
lo que los resultados siguientes son baseline anterior y no acreditan la migración.
T025 queda reabierta hasta ejecutar analyze, suite completa y build APK.

Fecha2026-11-05. **Resultados históricos previos a la migración al asset.**
Flutter3.47.8/Dart3.13.7, checkout basado en31ee98f más la implementación F04 con
`FirestoreTipsRepository`. No son resultados en un teléfono ni acreditan
`BundledTipsRepository`.

- Baseline antes de cambios:135/135 satisfactorias y análisis0 diagnósticos.
- Regresión completa tras integrar:182/182 satisfactorias,0 fallidas,0 omitidas;
 47 pruebas nuevas de modelo/repositorio/estado/pantallas/accesibilidad.
- Análisis oficial `flutter analyze --fatal-infos`:0 diagnósticos,3.3s.
- Comprobación del adaptador Firestore (histórico):7/7 pruebas de repositorio,
  incluida la comprobación explícita de Source.server, integradas en el total182.
  Ese adaptador ya no existe en producción.

Se ejecutaron fallos de contrato previstos antes del modelo, de la pantalla antes
 del router y de las reglas antes del permiso público. Los fallos iniciales reales
no se presentan como resultados satisfactorios: se corrigieron compilación/semántica,
residuos del harness de capturas y contraste con fuentes reales. La regresión que
contaba dos rótulos «Tips» se actualizó a comprobar el encabezado real del catálogo,
preservando los asserts de cancelación/descarte. Un cambio de legibilidad se acotó
 a Tips para preservar geometrías de acceso/perfil con teclado.

Logs de la ejecución completa: `/tmp/priva-f04-tests-commit.log`; fuentes
reales cargadas desde caché oficial para revisar contraste/capturas. Los errores de
permisos de Firebase en tests negativos son comportamiento esperado, no fallos.

Comprobación SDK del adaptador anterior (histórico): no se heredaban clases selladas
de Firestore ni se desactivaban avisos del analizador. El test observaba colección,
IDs y Source.server. Queda sustituida por las pruebas del asset y
`BundledTipsRepository` que deben reejecutarse en T025.
