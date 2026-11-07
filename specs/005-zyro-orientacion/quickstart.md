# Quickstart de validación: F05

## Automatizada

Desde `mobile`:

```powershell
dart analyze
flutter test --no-pub
```

## Visual en Android

1. Conecta el Motorola G22 con depuración USB y abre el proyecto `mobile`.
2. Ejecuta `flutter devices` y luego `flutter run`.
3. Inicia sesión, abre **Zyro** en la barra inferior y revisa texto, imagen y tamaños.
4. Prueba las cinco consultas rápidas y una pregunta desconocida. Incluye «¿Cómo protejo mi cuenta?» y variantes como «Quiero asegurar mi cuenta» o «Me hackearon mi cuenta».
5. Escribe una frase con una contraseña ficticia y confirma el aviso de datos sensibles.
6. Sal de Zyro, vuelve y confirma que la conversación desapareció.
7. Activa modo avión y repite una consulta.
8. Abre el teclado y confirma que el campo y el botón de envío siguen utilizables.
9. Repite 20 envíos y confirma respuesta visible en menos de un segundo, sin pausas.

