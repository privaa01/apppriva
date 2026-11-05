# F04 — revisión de entrega local, sin cierre final

## Estado vigente — contenido incluido en la APK

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

No es entrega aceptada ni F04 terminada. **28/36 tareas completas.** Pendientes:
revalidación Flutter/build (T025), matriz Android (T027), comparación visual (T028),
TalkBack (T029), rendimiento nativo (T030), comprensión con5 participantes (T031),
smoke offline en Android real (T035) y aceptación final (T036).

Para continuar: ejecutar analyze, suite completa y build APK en un entorno con
Flutter; validar después el APK en Android con modo avión y sin sesión; completar
TalkBack, rendimiento y comprensión; y registrar la aceptación explícita. No hay
despliegue de Tips en Firebase ni se presupone autorización para otras operaciones.
