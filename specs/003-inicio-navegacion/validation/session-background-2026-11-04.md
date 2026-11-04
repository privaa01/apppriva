# Sesión al pasar a segundo plano — 2026-11-04

El usuario reportó cierre de sesión al pasar a segundo plano y pidió mantenerla.
El comportamiento requerido ya consta en CA-03.8 y constitución III: descartar
cuestionario/resultado no implica cerrar la sesión de cuenta. Se corrige la
implementación, sin aprobar persistencia del cuestionario o un plazo nuevo de sesión.

## Hallazgos y solución

FirebaseAccountRepository conservaba su concesión solo en memoria. Una nueva
instancia después de recrear Android no reconstruía la sesión que el SDK nativo
ya conserva. Además, cualquier excepción de la comprobación de evidencia en un
evento de token revocaba la concesión, incluyendo indisponibilidad temporal de red.

Se añadió la capacidad opcional SessionRestoration al repositorio Firebase. Espera
el estado inicial de Auth y comprueba correo verificado, proveedor password, token,
evidencia leída del servidor y perfil; compara UID antes de conceder acceso. El
controlador utiliza el flujo protegido contra timeout/operaciones tardías y la
navegación lleva a Inicio solo tras esa concesión validada. Los eventos del SDK
siguen sin conceder permisos por sí mismos; los anteriores a una concesión se ignoran.

Un error de red tipado unavailable/deadline-exceeded/network-request-failed puede
conservar solamente una concesión previa, con el mismo UID y correo verificado.
No crea sesión ni sustituye validación de servidor para restaurar desde cero.
Ausencia de evidencia, permisos denegados, identidad distinta o invalidación siguen
revocando acceso. Las reglas y los controles de datos protegidos no se relajan.
Un error de restauración no borra la identidad nativa ni concede acceso privado.
Restaurar desde un proceso nuevo requiere conectividad para comprobar autorización;
no se añade modo sin conexión ni se inventa una duración de sesión.

Cierre explícito incrementa la revisión y llama FirebaseAuth.signOut; una restauración
pendiente no puede restablecer esa sesión. No se añaden almacenamiento propio de
contraseñas/tokens ni dependencias. El descarte de intento/resultado al pasar a
segundo plano y al reiniciar sigue intacto; no se restauran respuestas ni score.

## Pruebas y límites

Se observaron inicialmente dos fallos funcionales: restauración de identidad nativa
y conservación de concesión previa ante fallo transitorio. Se corrigieron ambos.
La prueba previa que esperaba un evento null sin concesión ahora verifica stream
vacío: ignorar eventos iniciales evita que un resultado viejo cierre un login válido;
el criterio de no conceder acceso por eventos no cambia.

Suite final: **135 satisfactorias**,0 fallidas; análisis **0 diagnósticos**. Seis
casos nuevos comprueban restauración autorizada, error transitorio de comprobación,
segundo plano/recreación de app simulados sin otra contraseña, restauración tardía
tras cerrar, fallo inicial sin concesión ni borrado nativo, e identidad no verificada/
no password. Regresión F01/F02/F03 completa. Identidades y lifecycle son sintéticos:
esto no representa una observación nueva del dispositivo del usuario.

Build flutter build apk --debug --no-pub: exit0,38.7s.
APK: `mobile/build/app/outputs/flutter-apk/priva-003-sesion-20261104.apk`.
SHA256: `e2fcc26c4d68cde9f5770dfd1fa120757b3f2341ada63f79184ef460896cd094`. Base5926365 más cambios de esta incidencia;
source snapshot en current-results.json. No se modificó código tras validar.

**Pendiente:** instalar este APK, entrar, abrir otra app y volver; después probar
cierre/reapertura del proceso sin borrar datos y cerrar sesión explícitamente.
Registrar modelo/Android/resultados. No cerrar T028 o aceptación F03 sin esas pruebas
y el resto de controles pendientes. Los módulos F06/F07 reales siguen sin integrar.

## Cierre posterior — 2026-11-04

El usuario confirmó conservación de sesión y aprobó cerrar F03. Ver
[aceptación y limitaciones](closure-2026-11-04.md):29 tareas completadas,6 parciales/
aplazadas. Los pendientes anteriores describen el estado histórico; no se convierten
en resultados satisfactorios. Se preservan los límites de la evidencia ejecutada.
