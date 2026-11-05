# F04 — Guía de validación

## Cambio de validación — contenido local (2026-11-05)

La fuente vigente es `mobile/assets/content/tips-1.0.0.json`. Validar igualdad con
`contenido-editorial.md`, cuatro IDs y rechazo de asset/ruta inválidos. Ejecutar
catálogo, cuatro detalles, atrás y ejemplos con red disponible y en modo avión; el
resultado debe ser idéntico. Firebase/Firestore no es prerrequisito de F04 y no se
publican documentos ni reglas de Tips. Las secciones remotas posteriores son
historial del plan sustituido, no una puerta de cierre.

**Estado:** módulo F04 implementado localmente. Resultados locales y pendientes se
registran en validation/; los comandos Android y las validaciones humanas siguen
pendientes, sin atribuirlos a las pruebas locales ni al baseline anterior.

## 1. Prerrequisitos

Usar checkout `/workspace/apppriva`, rama `work`, sin worktrees nuevos. El plan fue aprobado el2026-11-05; el contraste de fuentes quedó completado; conservar sus referencias y los textos
aprobados durante la ejecución. Instalar
baseline Flutter3.47.8/Dart3.13.7 y SDK Android mediante fuentes oficiales y
comprobaciones de integridad; preservar pins/lockfile. Necesita Node y Java21
para reglas; no requiere credenciales de producción para pruebas locales.

Si existe `/workspace/.tools/priva-toolchain.sh`, leerlo y activarlo; no asumir que
está presente. Configurar cachés escribibles sin cambiar HOME. Verificar versiones:

```bash
cd /workspace/apppriva/mobile
flutter --version
flutter doctor -v
flutter devices
flutter pub get --enforce-lockfile
```

Una discrepancia de versión/lockfile es diagnóstico, no permiso para actualizar.
No ejecutar formatter sobre todo el repo ni arreglar archivos ajenos para preparar.

## 2. Análisis y suites existentes

```bash
cd /workspace/apppriva/mobile
flutter analyze --fatal-infos
flutter test --no-pub
flutter build apk --debug
```

Registrar salida final, número real de tests y versión del build. Deben incluirse
las pruebas F04 que se creen durante implementación y las regresiones F01–F03;
un build o una suite previa sin F04 no acredita la funcionalidad. No fijar aquí
un recuento inventado. Si falla, conservar clasificación entorno/defecto y reprueba.

## 3. Repositorio local y regresión Firebase

Tips ya no usa Firestore ni necesita reglas propias. El repositorio vigente es
`BundledTipsRepository`, que lee `assets/content/tips-1.0.0.json` con validación
completa y caché solo en memoria. Comprobar con dobles: catálogo completo y cada
detalle; asset ausente/incompleto/inválido y ruta desconocida→unavailable; una sola
decodificación; cuatro generaciones de carga solapadas y respuesta antigua ignorada;
reintento conserva destino y dispose no publica. Cubrir una PageRoute
limpia/invalida, volver a la ruta retenida recarga y un diálogo no borra contenido.
Verificar también que Auth inválido o un fallo de Firebase no convierte Tips en privado.

La suite Firebase de cuenta/perfil/demo se conserva como regresión y puede ejecutarse
aparte; ya no contiene pruebas de Tips:

```bash
cd /workspace/apppriva/firebase
npm_config_cache=/tmp/priva-npm-cache npm ci
CI=true FIREBASE_EMULATORS_PATH=/workspace/.cache/priva/firebase-emulators XDG_CONFIG_HOME=/workspace/.cache/priva/config XDG_CACHE_HOME=/workspace/.cache/priva/cache npm_config_cache=/tmp/priva-npm-cache npm test
```

No habilitar reglas públicas globales ni simular despliegues de producción.

## 4. Escenarios funcionales — C-TIPS-01–05

Repetir con visitante, cuenta no verificada y cuenta sintética válida:

1. Abrir `/tips`:4 categorías, nombres/orden aprobados, cada «Ver más» abre su detalle.
2. Abrir directamente cada ruta de detalle de la tabla en data-model; atrás vuelve
   a catálogo.20 pulsaciones repetidas no duplican rutas. Ruta desconocida no muestra
   contenido privado ni el primer tip como sustituto.
3. Comparar todos los textos con editorial1.0.0, incluyendo A1–A5. Contraseña oculta
   inicialmente; revelar/ocultar no modifica explicación. «Ver ejemplo» muestra
   explicación una vez y permanece dentro de Priva en las cuatro categorías.
4. Comprobar publicación/perfil genéricos ficticios y dirección `.example` sin acción.
   No inputs, apertura externa, subida, permisos ni inspección de una cuenta real.
5. Forzar asset ausente, incompleto o inválido y timeout con dobles: mensajes de
   C-TIPS-03, reintento y retorno correctos, sin detalles técnicos. Repetir con modo
   avión para confirmar que la falta de red no impide leer Tips.
6. Volver a iniciar sesión/cerrar/cambiar UID; conservar guardas privadas. Perfil
   guardando bloquea salida voluntaria. Regresión de descarte temporal y restauración
   de sesión de F03, sin afirmar integración real de F06/F07.
7. Inspeccionar configuración/código: sin escritura de visitas, categorías leídas,
   credenciales ni cuestionario; Tips no abre conexiones ni usa Firestore.

## 5. Android e inspección visual — C-TIPS-05/06

Runners preparados y analizados; ejecución Android pendiente de dispositivo:

```bash
cd /workspace/apppriva/mobile
flutter test integration_test/tips_test.dart -d DEVICE_ID
flutter test integration_test/tips_performance_test.dart -d DEVICE_ID
```

Los runners usan repositorio/cuentas sintéticos del harness y no escriben contenido
ni personas en el proyecto alojado. Tips se lee del asset incluido en el APK; no hay
comprobación contra Firestore ni publicación autorizada. Un runner con dobles no
sustituye la ejecución en un dispositivo real ni el modo avión.

Matriz:API24/API36 ×320×720/412×915dp ×texto100%/200%; registrar modelo/OS/tamaño
real, build y ajustes. Al menos un físico con TalkBack. Verificar catálogo,
cuatro detalles, explicación expandida, máscara, error/carga/reintento y navegación.

- Comparar capturas sintéticas con PDF4/6/8/9/10: jerarquía, paneles, colores,
  posición del personaje solo P02 y navegación. No exigir marco negro del teléfono.
- Sin clipping ni acciones ocultas a200%;48×48dp; contraste normal4.5:1, grande3:1,
  controles3:1. Corregir texto blanco sobre verde claro si incumple.
- TalkBack: encabezados, orden/foco, nombre de categoría en cada acción, selección
  Tips, expansión percibida y contenido añadido legible. Iconos decorativos no
  duplican etiquetas. No describir pruebas semánticas como TalkBack ejecutado.
- Atrás del sistema vuelve a catálogo sin loops; segundo plano/reinicio no restaura
  visitas ni exige cerrar sesión por leer Tips.

Rendimiento:20 repeticiones por configuración de catálogo/detalle/reintento/revelado.
Reloj monotónico, medir pulsación→feedback≤1s y→contenido/error≤15s; registrar todas
las duraciones sanitizadas, máximo y número de incumplimientos. No promediar para
ocultar un fallo ni equiparar configurar timeout con haberlo medido. En fallo de
lectura controlado debe llegar mensaje≤15s. Tiempo humano de lectura no se incluye.

## 6. Comprensión — SC-04.5

Propuesta:5 participantes de40–65años, con ambos tramos40–52/53–65 incluidos y
experiencia digital baja presente. Conformidad de participación; sin nombre, correo,
edad exacta, grabación, contraseña o datos de cuentas. Mismo build, contenido y
preguntas; facilitador no da pistas. Evaluación formativa, sin inferencia poblacional.

Después de consultar cada categoría, pedir en palabras propias:

1. ¿Qué harías para elegir contraseñas para dos cuentas distintas?
2. ¿Qué revisarías antes de publicar información sobre tus vacaciones?
3. ¿Qué harías al recibir un premio inesperado que te pide actuar rápidamente?
4. ¿Qué harías si un perfil desconocido te pide dinero?
5. ¿Qué te dice HTTPS y qué no demuestra?
6. ¿Tener pocas publicaciones demuestra que un perfil es falso? ¿Cómo lo verificarías?

Rúbrica binaria:1=claves diferentes/largas sin reutilizar ejemplo;2=limitar audiencia/
datos o publicar al regresar;3=detenerse/no dar datos y verificar por canal oficial;
4=no enviar dinero/datos y verificar identidad por otro medio;5=cifrado sin garantía
de legitimidad;6=no prueba de falsedad y verificar por canal conocido. No exigir
palabras idénticas. Aclarar enunciado de forma neutra permitido; pistas/ayuda o abandono
cuentan como fallo. Error externo de dispositivo invalida la oportunidad completa
para esa persona y se repite sin seleccionar solo preguntas fallidas.

Éxito individual=6/6 comprobaciones correctas sin ayuda. Denominador fijo5 participantes
con oportunidades válidas; meta≥4/5. Mantener solo contadores agregados por pregunta,
participantes exitosos/total y defectos genéricos. No guardar ni subir respuestas
individuales, seudónimos vinculables o contenido de cuentas; no instrumentar la app
para capturar respuestas. Si faltan participantes, registrar pendiente y no usar
agentes como sustituto.

## 7. Cierre futuro

No hay publicación de contenido ni reglas de Tips. Antes de cerrar: revalidar
análisis/suite/build tras la migración al asset, comparar el contenido empaquetado
con editorial1.0.0, ejecutar el smoke offline en Android real, completar TalkBack,
rendimiento y comprensión, y registrar los resultados con sus límites.

Consolidar trazabilidad RF/HU/CA→tareas→pruebas→resultados; separar local, Android,
TalkBack y comprensión humana. No heredar excepciones F03. Registrar fallos,
pendientes y aceptación explícita de entrega; commit y sincronización al cerrar etapa.
