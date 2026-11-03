# Guía de validación F03 — ejecución futura

**Estado**: propuesta; usar después de aprobar plan, tareas e implementación.
Los archivos de prueba F03 mencionados abajo todavía no existen. Ningún comando
ni escenario de esta guía se declara ejecutado. [Contratos](contracts/inicio-navegacion.md)
y [modelo](data-model.md) definen el comportamiento; no duplicar controladores aquí.

## 1. Preparar entorno y baseline

En la raíz del repositorio, comprobar rama/commit y cambios locales antes de operar.
No descartar trabajo del usuario ni actualizar Flutter/dependencias silenciosamente.
Preparar Flutter3.47.8/Dart3.13.7 y SDK Android compatible con API24/API36, licencias,
Java y acceso de descarga. Mantener caches/configuración en directorios escribibles.
El entorno actual no tiene Flutter/Dart en PATH ni `/workspace/.tools`; preparar
herramientas será requisito de implementación. Nunca etiquetar un fallo de instalación
como prueba de comportamiento ni eludir validación TLS.

```bash
cd /workspace/apppriva
git status --short --branch
flutter --version
flutter doctor -v
flutter devices
cd mobile
flutter pub get
flutter test
flutter analyze --fatal-infos
```

Verificar que `pubspec.lock` no cambie versiones sin justificación. Si el analizador
nativo necesita una ruta de configuración escribible, configurarla primero; el
script `mobile/tool/analyze.sh` requiere Docker y SDK/caches montados, no los instala.
Los103 resultados antiguos son baseline histórico, no una nueva ejecución. Registrar
comandos reales, versiones, exit codes, recuentos y defectos/repruebas en
`specs/003-inicio-navegacion/validation/` al ejecutar.

Usar repositorios dobles para unit/widget y cuentas sintéticas ya autorizadas para
integración Firebase de F01/F02. No guardar contraseñas, claves administrativas o
configuración local en Git. La configuración cliente Android pública existente no
es una credencial de administrador. No crear usuarios, enviar emails ni desplegar
reglas solo para validar navegación. F03 no cambia reglas Firebase.

## 2. Ejecutar contratos y regresión tras implementar

```bash
cd /workspace/apppriva/mobile
flutter test test/features/navigation/
flutter test
flutter analyze --fatal-infos
flutter build apk --debug
flutter test integration_test/navigation_test.dart -d <ANDROID_DEVICE_ID>
flutter test integration_test/navigation_performance_test.dart -d <ANDROID_DEVICE_ID>
```

Sustituir el marcador por dispositivo Android real de `flutter devices`; no copiarlo
como identificador literal. Los tests de integración deben admitir dobles sintéticos
para fronteras F06/F07, con modo de pruebas claramente identificado. Los flujos
Firebase se ejecutan con harness de cuentas sintéticas autorizado y configuración
local ignorada, sin inventar --dart-defines que el runner no consuma.

Registrar SHA256/ruta/versionCode del APK y commit compilado, Android/API, modelo o
AVD, tamaño en dp, escala de texto y fuente de cada resultado. Un APK anterior o
un build preparado no acredita este commit. No publicar un APK debug como release.

## 3. Recorridos funcionales

1. Visitante desde P11: cinco controles visibles, ninguno falsamente seleccionado;
   abrir Tips y cuatro detalles, volver al catálogo. Contenido editorial F04 todavía
   no entregado debe identificarse como pendiente, no darse por aprobado.
2. Intentar los cinco destinos privados y cada ruta directa como visitante/cuenta
   no habilitada: no se construye contenido privado y se ofrece acceso o Tips.
3. Sesión sintética habilitada: P01 con tres tarjetas; cada una coincide con menú;
   cabecera Inicio/Perfil correcta. Preservar alta, confirmación y recuperación F01.
4. Veinte reselecciones, A→B→A, detalles directos, back en raíz y destino desconocido:
   sin duplicados/bucles, estado activo coincide y la raíz puede salir normalmente.
5. Invalidar sesión y emitir UID B mientras se mantiene una concesión de A:
   desaparecen datos, historial privado e intención antigua; no se concede B por stream.
6. Perfil: cancelar, guardar, navegar durante saving, timeout unknown, salir/reentrar,
   cerrar y retroceder. Respetar F02 y no afirmar cancelación remota de una escritura.
7. Puerto temporal sintético: revisar pregunta anterior; salida desde primera o
   cambio de sección con Cancelar/Salir; ninguna selección en memoria se pierde al
   cancelar ni se conserva tras confirmar. No crear preguntas reales ni puntaje.
8. Resultado sintético: al abandonar se descarta; ruta a resultado sin estado ofrece
   entrada válida. El historial no recupera un intento completado con respuestas.
9. Diálogo pendiente + pérdida de sesión/segundo plano: invalidar/cerrar; una respuesta
   tardía no navega. hidden/paused/detached repetidos descartan idempotentemente.
10. Home, recientes, notificaciones y reinicio en Android: regreso sin estado temporal
    descartado; cuenta no se cierra solo por segundo plano. Distinguir pruebas del
    doble sintético de integración real futura de F06/F07.

Revisar almacenamiento/rutas/logs/tráfico con estado sintético: cero respuestas,
resultados o derivados persistidos; cero envíos a IA. Nunca capturar datos reales
del cuestionario en la evidencia. PD-10 sigue fuera del alcance de estos escenarios.

## 4. Matriz Android y accesibilidad

Cuatro configuraciones propuestas: API24/320×720, API24/412×915,
API36/320×720 y API36/412×915 dp. Probar texto100%/200% en cada una; registrar
imagen Android exacta y geometría real, no una etiqueta genérica «actual». Añadir
al menos un Android físico con modelo/API para retroceso, TalkBack y ciclo de vida.
No afirmar que un AVD demuestra todos los dispositivos. Si el SDK fijado no admite
API36, documentar y resolver la matriz antes de implementar el trabajo afectado.

- Cinco controles accesibles, un anuncio de etiqueta/selección por control; iconos
  decorativos no producen duplicados. Tips detalle→Tips y Resultado→Cuestionario.
- Señal de selección además del color; contraste4.5:1 normal/3:1 grande y componentes.
- Objetivos≥48dp y texto200% sin recorte/solapamiento ni acciones fuera de alcance.
- Orden de lectura y foco en destino/diálogo comprensibles; cancelación retorna a
  origen. Alertas de acceso/error perceptibles y lenguaje sencillo para40–65años.

Registrar defectos y repruebas. La confirmación TalkBack del001/002 no certifica F03.

## 5. Presupuestos de respuesta

Por configuración Android, medir20 repeticiones de cada acción: tarjeta/menú a
sección nueva, retorno a destino existente, acceso denegado, selección activa y
resolución después de confirmar salida sintética. Usar Stopwatch/reloj monotónico
con dos medidas: pulsación→primer feedback≤1s y pulsación→vista/aviso recuperable≤15s.
Para diálogo excluir espera humana; medir desde decisión hasta efecto. En selección
activa, no crear animación artificial: el estado visible estable acredita feedback.

Incluir red disponible y fallo/espera de carga Perfil simulados; registrar perfil de
red. No atribuir a F03 tiempo de entrega de correo ni respuesta de IA todavía ausente.
Registrar todos los tiempos sanitizados, máximo y número de incumplimientos, con
nombre de escenario sin datos personales. El test falla ante presupuesto excedido;
no declarar el máximo satisfecho solo por media o por configurar un timeout.

## 6. Protocolo de usabilidad — SC-03.5

Propuesta para aprobar con este plan:5 participantes de40–65años, con ambos tramos
40–52 y53–65 y experiencia digital baja incluida. Muestra formativa, sin afirmación
de representatividad estadística. Mismo build y enunciados; obtener conformidad de
participación. No grabar voz/video ni pedir nombre, correo, fecha de nacimiento o
respuestas; usar cuentas sintéticas preparadas por el facilitador.

Cada participante realiza estas6 tareas, sin pistas sobre dónde pulsar:

1. Desde acceso, encontrar Tips sin crear cuenta y regresar al acceso.
2. Desde catálogo Tips, abrir el detalle Contraseñas y volver al catálogo.
3. Con sesión sintética ya preparada en Inicio, encontrar Chat IA y volver a Inicio.
4. Desde Inicio, encontrar Perfil y volver a Inicio, sin editar datos.
5. Desde Inicio, encontrar Cuestionario y volver a Inicio, sin responder preguntas.
6. Desde Perfil, encontrar Tips y volver a Perfil mediante la navegación disponible.

Los marcadores honestos de F04/F05/F06 permiten evaluar encontrar/retornar, no el
contenido de esos módulos. Si la tarea requiere contenido aún no disponible, no
cambiarla silenciosamente: revisar y aprobar el protocolo antes de ejecutarla.

Éxito = destino/retorno correctos sin ayuda; se permite repetir el enunciado neutro,
pero indicar un control cuenta como ayuda y fracaso. Abandono o ayuda se contabilizan
como fracaso. Un fallo externo de instalación/dispositivo invalida la oportunidad:
registrar causa genérica y repetirla, sin excluir selectivamente resultados malos.

Denominador fijo30 oportunidades válidas; meta≥21/30 (70%). Registrar observaciones
temporales con IDs P1–P5 no vinculados a identidades y duración de tarea; consolidar
solo conteos por tarea y total, defectos sin identificación y versión de build. Borrar
notas individuales tras consolidar; no subirlas al repositorio. Es una regla de
minimización del estudio propuesto, no un plazo legal. No incluir contenido de cuenta.
Si no hay participantes, registrar pendiente y no inventar resultados ni sustituir
la medición por una simulación de agentes.

## 7. Cierre de etapa futura

Consolidar RF-05.a–g→HU-03→CA/SC→tarea→prueba→resultado, incluyendo CA-ACC.
Separar ejecución automática, Android real, doble sintético, reporte de usuario,
fallo/bloqueo y pendiente. Resolver todos los CA y defectos bloqueantes antes de
solicitar aceptación; no suponer excepciones de F02 aplicables a F03. Repetir las
fronteras reales de F06/F07 cuando se integren, sin declarar esos módulos terminados.
Hacer commit/push y solicitar aceptación de F03 antes de avanzar a otro spec.
