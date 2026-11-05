# F04 — Guía de validación propuesta

**Estado:** guía de comandos/escenarios futuros; módulo F04 aún no implementado.
No presenta los siguientes comandos como ejecutados ni resultados como aprobados.

## 1. Prerrequisitos

Usar checkout `/workspace/apppriva`, rama `work`, sin worktrees nuevos. El plan fue aprobado el2026-11-05; completar las fuentes editoriales antes
de abrir la ejecución de las tareas de implementación. Instalar
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

## 3. Reglas y repositorio

```bash
cd /workspace/apppriva/firebase
npm_config_cache=/tmp/priva-npm-cache npm ci
CI=true FIREBASE_EMULATORS_PATH=/workspace/.cache/priva/firebase-emulators XDG_CONFIG_HOME=/workspace/.cache/priva/config XDG_CACHE_HOME=/workspace/.cache/priva/cache npm_config_cache=/tmp/priva-npm-cache npm test
```

El runner existente inicia/detiene Firestore en127.0.0.1:8085 para `demo-priva`.
La suite futura `tests/tips.test.mjs` debe ejecutarse realmente junto a cuenta/perfil/
demo. Comprobar get público de4 IDs aprobados, ausente conocido, denegación de
ID arbitrario/draft/versión inválida, list y toda escritura cliente. Las reglas
actuales aún no permiten Tips: la prueba positiva no puede pasar antes del cambio.
No habilitar reglas públicas globales ni simular publicación de producción.

Repository/widget con dobles: catálogo completo y cada detalle; error,timeout,
faltante,tipo/campo/versión erróneos; cuatro generaciones de carga solapadas y
respuesta antigua ignorada; reintento conserva destino y dispose no publica.
Probar permission-denied→unavailable sin revelar causa; cubrir una PageRoute
limpia/invalida, volver a la ruta retenida recarga y un diálogo no borra contenido.
Comprobar server-only sin fallback y que Auth inválido no convierte Tips en privado.

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
5. Forzar fallo de red, ausencia, documento incompleto y timeout con dobles/emulador:
   mensajes de C-TIPS-03, reintento y retorno correctos, sin detalles del proveedor.
6. Volver a iniciar sesión/cerrar/cambiar UID; conservar guardas privadas. Perfil
   guardando bloquea salida voluntaria. Regresión de descarte temporal y restauración
   de sesión de F03, sin afirmar integración real de F06/F07.
7. Inspeccionar configuración/código/tráfico sintético: sin escritura de visitas,
   categorías leídas, credenciales o cuestionario; persistencia Firestore desactivada.

## 5. Android e inspección visual — C-TIPS-05/06

Runners que se crearán en implementación, no disponibles todavía:

```bash
cd /workspace/apppriva/mobile
flutter test integration_test/tips_test.dart -d DEVICE_ID
flutter test integration_test/tips_performance_test.dart -d DEVICE_ID
```

Los runners usarán repositorio/cuentas sintéticos del harness y no necesitarán
escribir contenido ni personas en el proyecto alojado. La comprobación real contra
Firestore se realiza por separado tras una publicación explícitamente autorizada.
Un runner con dobles no prueba la configuración remota.

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
ocultar un fallo ni equiparar configurar timeout con haberlo medido. En fallo red
controlado debe llegar mensaje≤15s. Tiempo humano de lectura no se incluye.

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

## 7. Publicación y cierre futuros

Antes de publicar: fuentes completas, payload versionado comparado con editorial,
reglas locales y regresión aprobadas; comprobar acceso administrativo autorizado
sin pedir secretos por chat. En esta etapa no se ejecuta deploy ni se crean recursos.
Publicar solo los4 documentos y reglas revisadas por el canal que autorice el
responsable, preservando el resto del proyecto. Verificar luego get público real,
escritura cliente denegada y comportamiento en Android con datos sintéticos.

Consolidar trazabilidad RF/HU/CA→tareas→pruebas→resultados; separar local, Android,
TalkBack, comprensión y remoto. No heredar excepciones F03. Registrar fallos,
pendientes y aceptación explícita de entrega; commit y sincronización al cerrar etapa.
