# Quickstart and Acceptance — F08

## Preparación

```powershell
cd mobile
flutter pub get
flutter analyze
flutter test
```

Usar únicamente cuentas y datos sintéticos. Para la matriz manual, ejecutar Android
API 24 y API 36 en 320×720 y 412×915 dp.

## A-08.1 Tamaño persistente

1. Entrar a Perfil y seleccionar cada una de las cuatro opciones.
2. Confirmar que el cambio alcanza navegación, Tips, Zyro, cuestionario y Perfil.
3. En 150 %, recorrer y volver atrás sin recortes, solapamientos ni acciones ocultas.
4. Cerrar sesión y cerrar completamente la app.
5. Abrirla otra vez y confirmar que conserva la selección.
6. Con TalkBack, verificar etiqueta, selección y orden de foco.

## A-08.2 Pérdida y recuperación de red

1. Iniciar una operación remota con datos sintéticos.
2. Activar modo avión antes de enviarla.
3. Confirmar aviso comprensible y ausencia de envío/registro nuevo.
4. Desactivar modo avión y esperar a que “Reintentar” se habilite.
5. Pulsarlo dos veces rápidamente.
6. Confirmar una sola operación y un único resultado.

## A-08.3 Contenido local

1. Activar modo avión.
2. Abrir las cuatro categorías de Tips y sus ejemplos.
3. Abrir Zyro y consultar preguntas incluidas en el catálogo.
4. Confirmar que ambos funcionan y no muestran un bloqueo de conexión.
5. Confirmar que el cuestionario aplica la pausa F06 y no restaura respuestas tras
   pasar la app a segundo plano.

## A-08.4 Contraste y rendimiento

- Medir colores visibles: ≥4.5:1 texto normal; ≥3:1 texto grande y controles.
- Verificar cambio de escala ≤300 ms y aviso de conectividad ≤2 s desde el evento.
- Revisar el recorrido con el perfilador de Flutter: sin bloqueos perceptibles y con
  objetivo de 60 fps.

## Evidencia de cierre

Registrar versión/dispositivo, resolución, resultado por CA-08.1–3, defectos y
repruebas. Añadir la trazabilidad requisito → tarea → prueba → resultado, confirmar
commit y sincronización, y obtener aceptación explícita del responsable.
