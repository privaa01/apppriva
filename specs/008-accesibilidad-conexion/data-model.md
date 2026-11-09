# Data Model — F08

## TextScalePreset

Valor cerrado, no personal y sin identidad asociada.

| Caso | Factor | Etiqueta visible | Persistencia |
| --- | ---: | --- | --- |
| small | 0.90 | Pequeño | `small` |
| normal | 1.00 | Normal | `normal` |
| large | 1.25 | Grande | `large` |
| extraLarge | 1.50 | Muy grande | `extraLarge` |

Reglas:

- `normal` es el valor inicial y el fallback ante ausencia o valor desconocido.
- La clave local es `priva.text_scale`.
- No se almacena UID, correo, nombre, respuesta, resultado ni marca temporal.
- Cerrar sesión no elimina la preferencia; borrar los datos de la app sí puede hacerlo.

## TextScaleState

| Campo | Tipo | Regla |
| --- | --- | --- |
| preset | `TextScalePreset` | Siempre uno de los cuatro valores. |
| initialized | `bool` | Verdadero antes de mostrar el primer contenido útil. |
| saving | `bool` | Evita escrituras simultáneas; el cambio visual puede ser optimista. |

Transiciones: `loading → ready(normal|persistido) → saving(nuevo) → ready(nuevo)`.
Si guardar falla, se conserva el valor visible para la sesión y se anuncia que no
pudo recordarse; el siguiente inicio usa el último valor válido persistido o Normal.

## ConnectivityState

| Campo | Tipo | Regla |
| --- | --- | --- |
| available | `bool` | `false` solo cuando el sistema informa `none`. |
| initialized | `bool` | Estado inicial conservador compatible con el arranque existente. |
| retrying | `bool` | Una operación manual a la vez. |

Transiciones:

- `available → unavailable`: detener/no iniciar la operación remota y mostrar aviso.
- `unavailable → available`: habilitar “Reintentar”, sin ejecutar automáticamente.
- `available + retry → retrying → available|error`.
- Doble toque durante `retrying`: ignorado por botón deshabilitado.

No se persiste estado de conexión ni una cola de operaciones.
