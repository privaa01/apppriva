# Quickstart de validación — F06

## Prerrequisitos

- Plan y tareas aprobados antes de implementar.
- Flutter/JDK/Android y asset generado desde el banco aprobado.
- Solo cuentas/respuestas sintéticas; no conservar respuestas individuales.

## Automatización prevista

```bash
cd mobile
flutter pub get
flutter analyze
flutter test
flutter test integration_test/questionnaire_test.dart -d <android-device>
flutter build apk --debug
```

Validar reglas existentes para demostrar que no se abrió una colección. Inspeccionar
APK, almacenamiento, tráfico y logs: pueden contener el banco fijo, nunca selecciones.

## Recorrido independiente

1. Visitante/no verificado no cargan P08; sesión válida sí.
2. Leer aviso, comenzar y confirmar diez IDs, cinco módulos y exactamente dos por módulo.
3. Verificar tres opciones, selección única, bloqueo sin respuesta, reemplazo,
   progreso y revisión hacia atrás.
4. Comparar IDs/porcentajes antes y después de mezclar; no revelar porcentajes en P08.
5. Simular pérdida/recuperación: pausa y mismo orden.
6. Cancelar salida; luego confirmar salida, background, logout y reinicio: volver al
   aviso sin respuestas restauradas.
7. Completar diez: snapshot RAM y `/results`; F06 no calcula ni presenta resultado.

Ejecutar API24/API36 ×320×720/412×915 ×texto 100/200%, teclado/atrás/background/red.
TalkBack físico debe distinguir progreso, selección, acciones y estados. Cinco
personas40–65 realizan tareas; conservar solo conteos/defectos agregados.
