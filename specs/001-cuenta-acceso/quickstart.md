# Guía de validación — F01

**Estado:** guía para la implementación futura. No hay aplicación, SDK Flutter,
manifest, pruebas ni proyecto de Auth configurados todavía. No ejecutar comandos
de app como si esos archivos existieran. El [plan](plan.md) sigue sin aprobar.

## 1. Revisión documental disponible ahora

Desde `/workspace/apppriva`:

```bash
export SPECIFY_FEATURE_DIRECTORY=specs/001-cuenta-acceso
bash .specify/scripts/bash/check-prerequisites.sh --paths-only --json
git diff --check
```

Esperado: `FEATURE_SPEC` apunta al spec 001 y `IMPL_PLAN` a su plan; no se producen
cambios de whitespace pendientes. Esto verifica documentación, no comportamiento.
No ejecutar `$speckit-tasks` mientras el plan tenga bloqueos o carezca de aprobación.

## 2. Preparación futura — después de aprobar plan e implementar

- Fijar versión de Flutter estable/Dart y dependencias, generar `pubspec.yaml` y lockfile
  y verificar mínimos móviles; no crear esa aplicación en esta etapa de planificación.
- Android: SDK y dispositivo/emulador. iOS: runner macOS con Xcode y simulador/dispositivo.
  Este Linux no demuestra compatibilidad iOS.
- Crear entorno de Auth exclusivamente de pruebas con correo sintético y configuración
  revisada: Confirm email, plantillas de código de alta/recuperación, SMTP evaluado,
  límites y expiración. Crear proyecto o enviar correo requiere la autorización propia
  de la etapa; no se hace como efecto de leer esta guía.
- Proveer `SUPABASE_URL` y `SUPABASE_PUBLISHABLE_KEY` mediante configuración de cliente.
  Son identificadores del proyecto, no autorización administrativa; aun así separar
  entornos. SMTP y claves privilegiadas solo en servidor/gestor de secretos, nunca
  en app, repositorio, chat, flags impresos o logs.
- Incorporar el adaptador de almacenamiento seguro elegido y probar su borrado.
- Publicar únicamente datos sintéticos. Antes de usuarios reales cerrar PD-05 y acuerdos.

Comandos previstos **solo cuando exista `mobile/` implementado**:

```bash
flutter --version
flutter doctor -v
cd mobile
flutter pub get
flutter analyze
flutter test
flutter devices
flutter test integration_test --device-id ID_DEL_DISPOSITIVO
```

`ID_DEL_DISPOSITIVO` debe sustituirse por el dispositivo elegido. La configuración
cliente se suministrará por el mecanismo de configuración que implemente el proyecto,
sin inventar flags que la app aún no consume. Las pruebas reales de correo requieren
el entorno de pruebas y los buzones preparados; no bastan mocks.

En Linux/runner Android, comprobar compilación con `flutter build apk --debug`.
En macOS preparado, comprobar `flutter build ios --simulator` y ejecutar la misma
suite de integración en simulador/dispositivo. El listado de comandos no acredita
que ya se ejecutaron, ni reemplaza pruebas en la matriz mínima y actual aprobadas.

## 3. Recorridos de aceptación

| Paso | Acción | Resultado esperado / CA |
| --- | --- | --- |
| Visitante | Abrir las cuatro categorías de Tips sin sesión; intentar destino protegido | Tips disponible; destino protegido no abre contenido; CA-ACC-01/02/05. |
| Formulario | Enviar campos vacíos/inválidos, ampliar texto y abrir teclado | Errores comprensibles y acciones operables; CA-01.1/01.5/01.7. |
| Privacidad | Consultar política antes de autorización | Versión/finalidad visibles y evidencia conforme a diseño; sin teléfono; CA-01.6. |
| Registro | Crear cuenta sintética y repetir envío | Una cuenta, no duplicados; sin contenido protegido antes de confirmar; CA-01.2/01.8/01.11. |
| Confirmación | Confirmar correo y completar acceso normal | Inicio permitido con sesión válida; cuenta propia; CA-01.2/ACC-03. |
| Errores | Probar correo existente/inexistente, credenciales inválidas, red interrumpida | Mensajes seguros, sin enumeración ni secretos; reintento controlado; CA-01.3/01.8/01.10. |
| Recuperar | Pedir código y verificar entrega en buzón sintético | Código por correo, sin SMS ni sustitución por acceso passwordless; CA-01.4/01.9. |
| Desafío | Probar código incorrecto, vencido, reutilizado y límite de intentos | No cambiar contraseña ni dar acceso; CA-01.12. |
| Cambio | Validar código correcto, cambiar contraseña y volver al acceso | No inicio automático a toda la app por recuperación; CA-01.13. |
| Aislamiento | Con credencial emitida por recovery, llamar directamente a datos protegidos sin UI | No se elude la restricción; si el proveedor no puede imponerla, fallo bloqueante de diseño. |
| Cierre | Cerrar sesión y usar retroceso/directo | Tips disponible, contenido protegido bloqueado; CA-ACC-04, coordinación F02. |

## 4. Validaciones técnicas negativas

- Probar autorización/RLS de perfil propio frente a otra identidad y visitante;
  no usar service key para simular al usuario.
- Verificar autorización frente a correo no confirmado y contexto recovery;
  no tomar una prueba de navegación como prueba de servidor.
- Examinar almacenamiento, crash reports y logs con datos sintéticos: no debe haber
  contraseña, código, tokens expuestos ni datos no justificados. La sesión persistida
  aprobada solo existe en almacenamiento nativo protegido.
- Inspeccionar configuración de logs/retención del proveedor y SMTP; documentar límites
  de inspección, sin afirmar borrado de backups no verificable.
- Verificar contraseñas conforme a política aprobada y límites reales del proveedor.
  Correo duplicado con respuesta ofuscada requiere comprobar configuración, no solo
  reemplazar un mensaje de error en el cliente.

## 5. Usabilidad, evidencia y cierre

Validar TalkBack/VoiceOver, foco, contraste y texto ampliado en matriz aprobada.
Para SC-001, aprobar antes de medir la propuesta de muestra/denominador del plan y
registrar completitud del registro sin ayuda, usando cuentas de prueba. No recolectar
resultados de cuestionario para validar autenticación.

Guardar resumen por CA con fecha, commit, plataforma, resultado y defectos, sin
códigos, contraseñas ni tokens. Separar pruebas pasadas, fallidas, omitidas y no
ejecutadas. Entrega solo después de resolver fallos bloqueantes y aprobación explícita.

**Validación actual:** solo resolución de rutas y consistencia documental. Ninguno
de los recorridos de app o proveedor se ha ejecutado en esta etapa.

## Comprobaciones añadidas tras las respuestas del usuario

- Cobertura: documentar el mínimo común real de Flutter y dependencias; probar la
  versión mínima y actual y móviles de distintos tamaños, memoria y arquitecturas
  soportadas. Informar exclusiones; ningún conjunto finito de pruebas permite
  afirmar funcionamiento en todos los dispositivos existentes.
- Seguridad: comprobar que una contraseña de menos de 12 caracteres se rechaza por
  el servicio, que un código fuera de sus 10 minutos no es válido, que el reenvío
  antes de 60 segundos se limita y que el máximo de 5 fallos se impone también si
  se llama al proveedor fuera de la app. No considerar aprobado por un contador local.
- Documentar resultado y limitaciones del proveedor; no ejecutar aún estas pruebas
  como parte de esta actualización documental ni usar datos reales.
