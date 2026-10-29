# Resultados locales F02

103 pruebas locales satisfactorias:69 de regresión F01 y34 de F02.
Flutter test --no-pub; análisis oficial Dart sin diagnósticos. Resultados obtenidos
en Flutter tester, sin representar llamadas reales a Firebase o plugins Android.

Repositorio: consulta derivada de Auth, evidencia/identidad, nombre vacío, cambio
de identidad en lectura/transacción y ausencia de fallback al displayName de Auth.
Controlador: guardar/cancelar, doble envío, error/timeout/reconciliación, cierre y
respuesta tardía; sincronización del nombre no concede permisos.
Pantalla/rutas: datos propios, correo de lectura, edición, historial eliminado al
cerrar, visitante denegado, borrador descartado al cubrir Perfil y recarga al volver.
Contacto: URI fija/genérica escapada, apertura/copia explícitas y fallback en falso,
error o timeout; sin envío automático ni eliminación.

TDD: pruebas positivas de repositorio y controlador fallaron funcionalmente antes
de implementarlos; los tests de pantalla fallaron contra la pantalla provisional.
Se corrigió target táctil de dirección seleccionable en diálogo: texto informativo
no interactivo más botón Copiar correo≥48dp. No se ignoraron lints o guidelines.

Pruebas de integración reales preparadas en integration_test/profile_account_test.dart
con cuenta sintética verificada explícita; no ejecutadas aquí. Pruebas de reglas
preparadas en firebase/tests/profile.test.mjs; no ejecutadas por bloqueo del emulador.
