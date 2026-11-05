# F04 — Investigación de diseño

## Decisión posterior R10 — contenido empaquetado

**Decisión:** incluir la versión editorial 1.0.0 en la APK mediante un asset JSON
validado y un repositorio local. **Motivo:** el responsable confirmó que el contenido
es fijo y prioriza «Ver más → información», disponibilidad offline y ausencia de
administración remota. **Alternativa descartada:** Firestore para Tips, porque añade
despliegue, reglas y fallos de red sin aportar valor al requisito confirmado.
Firebase continúa para funciones ajenas a F04.

**Fecha de diseño:** 2026-11-04. **Aprobación técnica:**2026-11-05.
**Estado:** decisiones técnicas aprobadas; contraste
editorial externo completado2026-11-05 mediante las alternativas primarias registradas. No es evidencia de ejecución de producto.

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

## R2 — Origen del contenido e internet (superado por R10)

> **Histórico:** esta decisión describía la distribución Firestore del diseño
> inicial. R10 la sustituye por contenido empaquetado en la APK; se conserva solo
> como registro.

**Decisión original:** cuatro documentos Firestore con versión y esquema cerrados; get
explícito al servidor, sin listeners ni caché persistente. Main ya desactiva
persistencia Firestore. Repositorio no depende del estado AccountController.
**Motivo original:** respetaba el requisito de conexión del spec inicial, permitía
error/reintento reales y reutilizaba el SDK existente. Cuatro documentos no requerían
índices, consultas de colección o CMS.
**Alternativas consideradas entonces:** contenido Dart/JSON embebido puro funcionaba
offline pero se descartó porque el requisito inicial exigía conexión; sondear un
tercero añadía tráfico artificial; HTTPS Hosting necesitaba un servicio adicional.
**Consecuencia histórica:** ampliar reglas y publicar contenido revisado. Ese trabajo
nunca se desplegó y quedó cancelado por el cambio aprobado del2026-11-05.

## R3 — Validación, recuperación y concurrencia

**Decisión:** esquema1, versión `tips-1.0.0`, IDs conocidos y campos completos;
rechazar ausencias, tipos/categoría/versiones incorrectos como unavailable. Error
transitorio y timeout como error; asset ausente/incompleto/inválido de una categoría
conocida como unavailable sin inferir la causa; ambos ofrecen reintento/retorno.
El contador de generación ignora operaciones tardías; dispose no publica resultados.
**Motivo:** CA-04.3/6 y casos límite requieren recuperar el mismo destino sin inventar
contenido ni aceptar un detalle equivocado. Catálogo falla como unidad si falta
una categoría; no muestra una entrega incompleta como catálogo válido.
**Ciclo de rutas retenidas:** RouteAware invalida y limpia al cubrir una PageRoute,
y recarga en didPopNext; diálogos no limpian. No asumir que push desmonta la vista.
**Alternativas:** fallback a otra categoría/último contenido, rechazados por
mezclar categorías; recarga permanente en segundo plano, innecesaria para lectura educativa.

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
de comprobación externa. NIST, FTC, RFC Editor y Google fueron consultados y la
revisión quedó fijada en [fuentes-editoriales.md](fuentes-editoriales.md).
**Motivo:** la longitud y predictibilidad importan; composición no es garantía ni
regla universal. A1/A5 conservan este límite sin alterar política de acceso Priva.
**Alternativas:** atribuir revisión a fuentes no descargadas o copiar afirmaciones
del PDF, rechazadas. CISA sigue sin lectura por403, pero las alternativas primarias
previstas cubren sus consejos. CA-04.10 queda cubierto por ese contraste; no se
declara cumplimiento jurídico ni prueba de interfaz.

## R6 — Accesibilidad, rendimiento y comprensión

**Decisión:** matriz API24/API36, dos geometrías,100%/200%;48dp; contraste4.5:1/3:1;
feedback1s/resolución15s con20 muestras;5 participantes, éxito conjunto de seis
comprobaciones en≥4/5. Sin identidades, respuestas individuales ni grabaciones.
**Motivo:** concreta SC-04.4/5 y reutiliza criterios del plan F03 sin heredar sus
excepciones ni dar por hechas sus pruebas. No sustituir TalkBack/participantes por
unit tests o agentes. El plan y protocolo fueron aprobados el2026-11-05; las pruebas siguen pendientes.

## Revisión posterior

Decisiones técnicas documentadas, sin marcadores de elección técnica sin resolver.
No hay excepción constitucional solicitada. En ese momento existía un bloqueo de
verificación editorial externa, no una elección técnica que pudiera resolverse por
suposición. La aprobación técnica quedó registrada el2026-11-05. No se cerró el
prerrequisito editorial ni se inició implementación hasta resolverlo. El desglose
preliminar de tareas permitió preparar el trabajo sin considerar superada esa puerta.


## Actualización de ejecución — 2026-11-05

El cierre del registro de fuentes resuelve el bloqueo editorial descrito en R5 y
la revisión posterior anterior, sin alterar texto ni alcance. Flutter oficial
3.47.8/Dart3.13.7 instalados desde etiqueta737ba8f885; pub get con lockfile exigido y
análisis oficial satisfactorio. Herramientas Android23.0 verificadas contra el
checksum del XML oficial; la preparación Android/baseline quedó registrada en
`validation/baseline.md` y `validation/environment.md`.
