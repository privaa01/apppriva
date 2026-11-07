# Quickstart de validación — F07

## Precondiciones

- Spec, catálogo, plan y tareas aprobados.
- F06 cerrado y asset 2.0.0 vigente.
- Flutter/JDK/Android del proyecto disponibles.
- Solo cuentas y respuestas sintéticas.

## Validación técnica

Desde `mobile/`: ejecutar análisis, pruebas completas y build APK mediante los mismos
scripts fijados por el proyecto. Desde `firebase/functions` y `firebase/`, ejecutar
sus suites para descartar regresiones. Registrar versiones, recuentos y fallos.

## Escenario funcional

1. Iniciar sesión sintética y completar diez respuestas conocidas.
2. Comparar suma/promedio con el oráculo; probar 19/19,5/20 y 59/59,5/60.
3. Confirmar nivel textual y tres módulos en el orden esperado, incluidos empates.
4. Verificar aviso y acciones literales del catálogo; ninguna selección visible.
5. Pulsar Repetir dos veces rápidamente: solo un intento, resultado anterior ausente.
6. Salir, background y logout: `/results` queda inaccesible y no se restaura.

## Privacidad y accesibilidad

Inspeccionar storage, Firestore, tráfico, logs y APK con datos ficticios: cero
respuestas/resultados persistidos o enviados. Ejecutar 320×720/412×915, texto
100/200 %, API 24/API 36 y TalkBack. La comprensión humana conserva solo conteos
agregados y no respuestas individuales.
