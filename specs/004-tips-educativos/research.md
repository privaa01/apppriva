# F04 — Investigación de diseño

**Fecha:** 2026-11-04. **Estado:** decisiones técnicas propuestas; contraste
editorial externo parcial. No es evidencia de ejecución de producto.

## R1 — Integración con navegación existente

**Decisión:** conservar Navigator/NavigationController, catálogo cerrado y
AccountScaffold. Inyectar TipsRepository por PrivaApp→AccountRouter; resolver
pantallas reales después de las guardas y conservar builders de pruebas.
**Motivo:** las cinco rutas públicas y el padre de detalles directos ya existen.
Solo falta contenido y `destinationAvailable`; evita una segunda pila y regresiones.
**Alternativas:** router nuevo/índice de pestaña independiente, rechazados por
complejidad y discrepancia de sección visible.
**Evidencia:** `destination_catalog.dart`, `account_router.dart`, `priva_app.dart`,
`navigation_controller.dart` y `account_scaffold.dart`, inspeccionados en checkout.
Investigación de integración revisada por agente de lectura según speckit-plan.

## R2 — Origen del contenido e internet

**Decisión:** cuatro documentos Firestore con versión y esquema cerrados; get
explícito al servidor, sin listeners ni caché persistente. Main ya desactiva
persistencia Firestore. Repositorio no depende del estado AccountController.
**Motivo:** respeta internet obligatorio, permite error/reintento reales, reutiliza
SDK/proyecto existente y no inventa un proveedor. Cuatro documentos no requieren
índices, consultas de colección o CMS.
**Alternativas:** contenido Dart/JSON embebido puro funciona offline y contradice
la condición del spec; sondear un tercero para habilitarlo añade tráfico artificial;
HTTPS Hosting necesita un servicio/publicación adicionales. No elegir esas opciones
sin cambiar y aprobar el requisito correspondiente.
**Consecuencia:** ampliar reglas y publicar únicamente contenido público revisado;
no inferir autorización de despliegue a partir de aprobar arquitectura. El plan
explicita esa dependencia para revisión, sin tocar servicios en esta etapa.

## R3 — Validación, recuperación y concurrencia

**Decisión:** esquema1, versión `tips-1.0.0`, IDs conocidos y campos completos;
rechazar ausencias, tipos/categoría/versiones incorrectos como unavailable. Error
transitorio y timeout como error; permission-denied de ID conocido como unavailable
sin inferir si la causa es reglas, borrador o versión; ambos ofrecen reintento/retorno. Contador de
generación ignora operaciones tardías; dispose no publica resultados.
**Motivo:** CA-04.3/6 y casos límite requieren recuperar el mismo destino sin inventar
contenido ni aceptar un detalle equivocado. Catálogo falla como unidad si falta
una categoría; no muestra una entrega incompleta como catálogo válido.
**Ciclo de rutas retenidas:** RouteAware invalida y limpia al cubrir una PageRoute,
y recarga en didPopNext; diálogos no limpian. No asumir que push desmonta la vista.
**Alternativas:** fallback al primer documento/último contenido, rechazados por
mezclar categorías; stream global permanente, innecesario para lectura educativa.

## R4 — Wireframes y recursos

**Decisión:** conservar paneles y composición de PDF páginas4/6/8/9/10; el texto
aportado y A1–A5 prevalecen. Reutilizar el asset Zyro inspeccionado solo en P02.
Ver ejemplo expande explicación inline; máscara de contraseña independiente.
**Motivo:** solicitud explícita del responsable; diseños no justifican acciones
externas, permisos ni datos reales. Ampliar alturas/scroll a200% conserva acceso.
**Alternativas:** renderizar capturas/alturas rígidas, descartadas por legibilidad;
crear variantes de personaje o nuevas pantallas, fuera de alcance.
**Límite:** asset existente tiene fondo blanco/gris; no afirmar exactitud visual
antes de comparar capturas del build. Falta contraste final de colores renderizados.

## R5 — Fuentes y redacción

**Decisión:** textos aprobados versión1.0.0; distinguir aprobación del responsable
de comprobación externa. NIST consultado desde repositorio oficial y revisión
fijada en [fuentes-editoriales.md](fuentes-editoriales.md).
**Motivo:** la longitud y predictibilidad importan; composición no es garantía ni
regla universal. A1/A5 conservan este límite sin alterar política de acceso Priva.
**Alternativas:** atribuir revisión a fuentes no descargadas o copiar afirmaciones
del PDF, rechazadas. CISA/RFC Editor están bloqueados por403: no dar por cerrado
CA-04.10. Falta revisar fuentes de publicación social, suplantación y HTTPS.

## R6 — Accesibilidad, rendimiento y comprensión

**Decisión:** matriz API24/API36, dos geometrías,100%/200%;48dp; contraste4.5:1/3:1;
feedback1s/resolución15s con20 muestras;5 participantes, éxito conjunto de seis
comprobaciones en≥4/5. Sin identidades, respuestas individuales ni grabaciones.
**Motivo:** concreta SC-04.4/5 y reutiliza criterios del plan F03 sin heredar sus
excepciones ni dar por hechas sus pruebas. No sustituir TalkBack/participantes por
unit tests o agentes. El plan y protocolo siguen pendientes de aprobación.

## Revisión posterior

Decisiones técnicas documentadas, sin marcadores de elección técnica sin resolver.
No hay excepción constitucional solicitada. Existe un bloqueo de verificación
editorial externa, no una elección técnica que pueda resolverse por suposición.
No se cierra el plan ni se avanza a tareas hasta resolverlo y obtener aprobación.
