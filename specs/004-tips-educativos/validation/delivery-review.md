# F04 — cierre aceptado

## Aceptación final — 2026-11-05

El responsable indicó explícitamente «apruebalo» y «acepto y finaliza». F04 queda
cerrada con36/36 tareas registradas. Esta aceptación no aprueba F05–F08.

Resultado vigente: contenido fijo dentro de la app mediante
`BundledTipsRepository`, sin Firestore para Tips; textos, pantallas, «Ver más», atrás,
ejemplos y offline preservados. Análisis0 diagnósticos y180/180 pruebas satisfactorias.
Validación manual en Motorola G22/Android12: TalkBack y modo avión satisfactorios,
20 repeticiones sin pausas/errores y comprensión5/5 con6/6 sin ayuda, edades40–60.

Limitaciones conocidas y aceptadas: no se generó APK posterior a la migración por
decisión del responsable y no se ejecutaron API24/API36; la cobertura Android real
se limita a Android12. No se inventan hashes, tiempos individuales ni resultados de
versiones no probadas.

## Historial anterior

## Historial de preparación — contenido incluido en la app

Tips se migró a contenido fijo incluido en la APK por decisión explícita del
2026-11-05. La publicación Firebase deja de ser un pendiente y no existe colección
ni reglas de Tips en la arquitectura vigente. Antes del cierre deben repetirse
análisis/suite/build y la matriz Android offline; continúan TalkBack, rendimiento,
comprensión con5 participantes y aceptación final.

2026-11-05. Se implementó el plan aprobado: catálogo público de cuatro categorías,
textos1.0.0+A1–A5, detalles y Ver ejemplo inline, máscara separada, errores/reintento,
recarga de rutas retenidas y permisos privados intactos. El contenido se lee desde
`mobile/assets/content/tips-1.0.0.json` mediante `BundledTipsRepository`, sin red,
sesión ni Firestore. Las reglas de cuenta/perfil/demo permanecen intactas.

Evidencia local histórica:182/182 Flutter, análisis0,24/24 reglas/preflight,20
escenarios widget de tamaños/texto/accesibilidad y APK debug compilado. Esos números
son baseline anterior a la migración al asset y no acreditan el cambio vigente;
T025 debe reejecutarse en un entorno con Flutter. El contenido editorial se comparó
literalmente en el baseline, las fuentes primarias están revisadas y existen capturas
sintéticas. SDK/JDK y cachés se prepararon fuera del repo.

Registro histórico anterior al cierre: **28/36 tareas estaban completas.** Pendían:
revalidación Flutter/build (T025), matriz Android (T027), comparación visual (T028),
TalkBack (T029), rendimiento nativo (T030), comprensión con5 participantes (T031),
smoke offline en Android real (T035) y aceptación final (T036).

Ese estado fue sustituido por la aceptación final registrada al inicio. No hay
despliegue de Tips en Firebase ni autorización para otras operaciones.
