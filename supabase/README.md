# Servicio de cuenta Priva — F01

Configuración local de Auth/Postgres y plantillas por código. No crea ni configura un
proyecto alojado. La app no pide teléfono: `auth.sms.enable_confirmations` es un ajuste
de privacidad de Auth para respuesta ofuscada en altas repetidas; signup por SMS está
inactivo y no se recopila teléfono.

## Preparación local

Desde la raíz del repositorio, con Supabase CLI y Docker instalados:

```bash
supabase start
supabase db reset
```

La configuración aplica contraseña mínima 12, correo confirmado antes de sesión normal,
OTP de 600 segundos y reenvío después de 60 segundos. Verificación usa la cuota nativa
del proveedor, no un máximo exacto de cinco intentos. Sesiones: tiempo absoluto 2160h
(90 días) e inactividad 720h (30 días), sujetas al soporte del proveedor contratado.
No usar temporizadores de UI para afirmar que un token del servidor se invalidó.

El seed no se ejecuta automáticamente. Para pruebas exclusivamente locales se puede
cargar `tests/synthetic_policy.sql` con una conexión administrativa local. La política
está marcada de prueba y advierte usar datos ficticios. No aplicarla a usuarios reales.

## Contrato para la app

Tabla pública `treatment_policies`: `version`, `body`, `is_active`, `is_test`, `purposes`
(text[]). Solo se publican políticas activas; modificar políticas es operación de servidor.

`signUp.data` contiene exactamente los datos relevantes del alta:

- `name`: nombre para el saludo.
- `policy_version`: versión publicada consultada antes de aceptar.
- `authorization_accepted`: booleano JSON true.

Un trigger de `auth.users` obtiene el ID y la fecha del servidor y crea `profiles(id,name)`
y `authorization_evidence(user_id,policy_version,action,authorized_at)` en la misma
transacción. Acción fija `account_signup`; evidencia inmutable para clientes. Declaración
ausente, versión no publicada o fallo de evidencia revierte el alta, sin huérfanos.
Modificar user_metadata no cambia evidencia ni permisos. Este registro acredita una
declaración recibida; no sustituye revisión jurídica de los textos/finalidades.

Los datos privados exigen identidad propia y AMR firmado `password`. La confirmación
y recuperación por OTP no conceden acceso a perfiles: tras confirmar o recuperar se
cierra la sesión temporal y se pide acceso normal por contraseña.

## Pruebas reproducibles

```bash
python supabase/tests/account_access_http.py
```

La prueba usa contenedores con imágenes fijadas, buzones locales y cuentas sintéticas;
no envía correo externo. Crea y elimina solo sus propios recursos aislados. Prueba
migraciones, SQL y HTTP con tokens reales, sin imprimir correo, contraseña, códigos o tokens.
Ver evidencia en `specs/001-cuenta-acceso/validation/backend-results.json`.

## Antes de un proyecto alojado

Configurar y verificar los mismos límites, sesiones y plantillas en la versión desplegada.
Para producción se requiere SMTP propio evaluado; el servicio predeterminado de Supabase
no acredita entrega de correo a todos los usuarios. SMTP y claves privilegiadas solo en
servidor/gestor de secretos; nunca en la app ni el repositorio.

Revisar remitente/dominio, región, responsable, acuerdos, conservación de identidad,
autorización/logs/backups y mecanismos de derechos antes de datos reales. No se fijan
plazos jurídicos aquí. Las pruebas locales no certifican el proyecto hospedado.
