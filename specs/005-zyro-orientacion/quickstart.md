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
4. Prueba las cinco preguntas principales y confirma que todas muestran orientación útil. Después prueba una pregunta desconocida. Incluye variantes como «Quiero asegurar mi cuenta» o «Me hackearon mi cuenta».
5. En «Explora preguntas por categoría», revisa las diez preguntas de cada una de las cinco categorías, selecciona una y pulsa «Preguntar a Zyro»; confirma que muestra orientación útil.
6. Escribe una frase con una contraseña ficticia y confirma el aviso de datos sensibles.
7. Sal de Zyro, vuelve y confirma que la conversación desapareció.
8. Activa modo avión y repite una consulta.
9. Abre el teclado y confirma que el campo y el botón de envío siguen utilizables.
10. Repite 20 envíos y confirma respuesta visible en menos de un segundo, sin pausas.

