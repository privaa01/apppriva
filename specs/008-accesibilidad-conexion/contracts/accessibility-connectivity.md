# Contracts — F08

## C-08.1 TextScalePreferences

```dart
abstract interface class TextScalePreferences {
  Future<TextScalePreset> load();
  Future<void> save(TextScalePreset preset);
}
```

- `load` devuelve Normal si no existe un valor reconocido.
- `save` reemplaza una única clave local y no recibe información de cuenta.
- Ningún método accede a red.

## C-08.2 TextScaleController

```dart
TextScalePreset get preset;
double get factor;
bool get saving;
Future<void> select(TextScalePreset preset);
```

- Notifica inmediatamente el nuevo factor.
- Seleccionar el valor actual no duplica escritura.
- Los errores de almacenamiento no exponen detalles internos.

## C-08.3 Selector en Perfil

- Encabezado: “Tamaño del texto”.
- Ayuda: “Elige el tamaño que te resulte más cómodo.”
- Opciones: Pequeño, Normal, Grande y Muy grande; una sola seleccionada.
- Cada opción anuncia etiqueta y estado seleccionado con TalkBack.
- El cambio no requiere guardar el nombre ni iniciar otra sesión.

## C-08.4 ConnectivityController

```dart
bool get available;
bool get retrying;
Future<void> initialize();
Future<void> retry(Future<void> Function() operation);
```

- `retry` no ejecuta sin señal disponible ni mientras otro reintento está activo.
- La recuperación de señal solo notifica; nunca llama a `operation` por sí misma.
- No guarda argumentos, cuerpos o resultados de la operación.

## C-08.5 Aviso de operación remota

- Mensaje sin red: “No hay conexión. Revisa Internet y vuelve a intentarlo.”
- Acción: “Reintentar”, deshabilitada sin señal o durante la ejecución.
- Estado durante ejecución: “Intentando de nuevo…”.
- Error posterior: mensaje funcional del módulo, sin credenciales ni detalles internos.
- El aviso usa región viva y texto/ícono; no depende solo del color.

## C-08.6 Exclusiones obligatorias

- Abrir y navegar Tips no consulta `ConnectivityController`.
- Consultar Zyro local no consulta `ConnectivityController`.
- F06 conserva su pausa temporal y no persiste respuestas/resultados.
- No existe reenvío automático, cola diferida ni sincronización de la escala.
