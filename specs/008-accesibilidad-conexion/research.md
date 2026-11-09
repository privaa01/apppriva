# Research — F08

## R-01: Persistencia de la escala

**Decisión**: usar `shared_preferences` mediante una interfaz propia y declarar el
paquete como dependencia directa.

**Razón**: la preferencia es pequeña, local y no sensible. El paquete ya forma parte
del grafo de dependencias, pero una importación de producción exige declararlo
directamente. La interfaz permite pruebas en memoria y evita mezclarla con la cuenta.

**Alternativas descartadas**: `flutter_secure_storage` añade cifrado innecesario y
posibles fallos de plataforma; archivo manual aumenta complejidad; Firestore violaría
la decisión de no asociar ni sincronizar.

## R-02: Aplicación global del tamaño

**Decisión**: un `TextScaleController` en la raíz reconstruye el contenido de
`MaterialApp.builder` con `MediaQuery.copyWith(textScaler: TextScaler.linear(valor))`.

**Razón**: alcanza todas las pantallas sin duplicar configuración y permite cambiar
inmediatamente. Los cuatro valores se modelan como enum cerrado.

**Alternativas descartadas**: cambiar cada `TextStyle` sería incompleto; delegar solo
al tamaño del sistema no cumple las cuatro opciones dentro de Perfil.

## R-03: Señal de conectividad

**Decisión**: reutilizar `connectivity_plus` en un controlador compartido. La señal
`none` bloquea una nueva operación remota; cualquier fallo real del repositorio se
presenta igualmente como recuperable.

**Razón**: evita una dependencia adicional y comparte la estrategia ya usada en F06.
La documentación del paquete advierte que una interfaz disponible no garantiza
Internet; por eso no se interpreta como prueba de acceso.

**Alternativas descartadas**: hacer ping a un tercero filtra metadatos y no representa
Firebase; una cola offline contradice RF-17.a/b; reenvío automático puede duplicar.

## R-04: Reintento seguro

**Decisión**: el aviso recibe un callback de la operación remota y conserva estado
`idle/running`. Solo un toque inicia una ejecución; no se dispara al recuperar red.

**Razón**: satisface el control de doble toque sin inventar idempotencia del servidor.

## R-05: Alcance sin conexión

**Decisión**: Tips y Zyro local continúan operables. El cuestionario conserva su regla
F06: pérdida de red en primer plano pausa en RAM; segundo plano descarta. Cuenta y
Perfil muestran recuperación en sus operaciones remotas.

**Razón**: corresponde a la decisión explícita y evita llamar “modo offline” a contenido
que ya está incluido en la app.

## R-06: Contraste y matriz

**Decisión**: validar los colores existentes y cualquier color nuevo contra 4.5:1 para
texto normal y 3:1 para texto grande/controles; probar API 24/API 36 en 320×720 y
412×915 dp, además de TalkBack.

**Razón**: son los umbrales y dispositivos aprobados en el spec. No se cambia la paleta
si ya cumple; los estados no dependerán exclusivamente del color.
