# Guía de validación prevista — F02

Estado: guía para implementación futura. No afirma que Perfil ya esté implementado
ni que existan sus tests. No ejecutar publicación o datos reales por aprobar el plan.

## Prerrequisitos

- Spec aprobado; plan y tareas deberán aprobarse antes de implementar.
- Baseline Flutter/Dart y Firebase del001; configuración pública Android incorporada.
- Dependencia url_launcher propuesta pendiente de instalar/fijar lockfile.
- Proyecto Firebase autorizado con dos cuentas sintéticas verificadas, perfiles y
  evidencia válida. Sin credenciales de personas en chat, capturas o logs.
- Nuevas reglas validadas en emulador antes de publicar cambio autorizado. Registrar
  bloqueo del entorno si no descarga el emulador; no usar reglas públicas.
- Android mínimo API24 y actual al ejecutar, pequeña/grande, TalkBack y con/sin
  cliente de correo. Registrar modelo/OS/versión APK; no inventar disponibilidad.

## Comandos de referencia

En mobile/, después de implementar los entregables:

```bash
flutter pub get
flutter test --no-pub
flutter run
flutter build apk --debug
```

Desde la raíz: `bash mobile/tool/analyze.sh`.
Desde firebase/: `npm ci` y `npm test`, que usa proyecto emulado demo-priva.
Los comandos ya existen para la base; aún no incluyen pruebas F02 por crear.
La configuración actual permite flutter run normal, sin depender de archivos locales.

## Recorridos y resultados esperados

1. Iniciar sesión A y abrir Perfil: nombre/correo propios reales; carga/error no
   muestran ejemplos ni datos anteriores. Repetir con B y sin sesión.
2. Editar nombre: vacío/espacios rechazan; cancelar conserva valor. Guardar válido
   confirma servidor, actualiza saludo y persiste al reabrir; correo no editable.
3. Guardar sin red, doble pulsación o respuesta lenta: no falso éxito ni duplicación;
   valor confirmado anterior hasta reconciliar. Cerrar sesión/cambiar identidad
   durante la operación: respuesta tardía no restaura perfil privado.
4. Reglas: usuario A no lee/escribe B; visitante/no verificado no modifica perfiles;
   ni A modifica correo, campos extra, UID, evidencia o borrado. Comparar evidencia
   sintética antes/después de la edición: idéntica. Alta de F01 debe seguir funcionando.
5. Cerrar sesión con/sin red: desaparece Perfil y borrador, retroceso/ruta no lo
   recupera. Tips continúa público. No afirmar cierre remoto global ni borrar cuenta.
6. Solicitar eliminación: destinatario correcto, explicación de que es solicitud;
   abre redactor sin enviar, ni datos personales adjuntos. Cancelar no elimina.
   Repetir sin cliente de correo y con error simulado: copiar dirección disponible.
7. Texto200%, teclado y TalkBack: leer/cambiar nombre/cerrar/información de solicitud
   alcanzables. Medir contraste y tamaño táctil; reportar fallos y repruebas.
8. Rendimiento propuesto: medir1s feedback/15s respuesta o aviso con reloj monotónico,
   20 repeticiones por carga/guardado/perfil de red y dispositivo acordado. Medir
   apertura/fallback de redactor; no incluir entrega de correo ni promediar excesos.

## Evidencia y cierre

Crear durante implementación `validation/` con matriz CA→test→resultado, comandos,
versión/app/dispositivo, pruebas sanitizadas de reglas y defectos/repruebas. No guardar
correos reales, códigos, tokens o cuestionario. Distinguir ejecución independiente,
reporte del usuario, omitido/aplazado y fallo. No heredar aprobaciones del001 a reglas
modificadas o escenarios nativos nuevos.

Solicitar aceptación de F02 solo tras resolver criterios y bloqueos aplicables,
registrar commit/push y no avanzar al003 automáticamente. No ampliar eliminación
por SDK: el equipo atiende la solicitud por su canal y procedimiento aprobado.
