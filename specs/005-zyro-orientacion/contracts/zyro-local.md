# Contrato local de Zyro

## Entrada

- Texto no vacío de hasta 300 caracteres o una consulta rápida.
- Se normalizan mayúsculas, espacios y tildes solo para clasificar.
- El texto no sale del proceso de la aplicación.

## Salida

- Tema admitido: orientación breve y, cuando aplica, pasos numerados.
- Credenciales o códigos: aviso para retirar el dato y hablar en general.
- Petición dañina: rechazo y alternativa segura.
- Tema o plataforma sin guía: límite explícito, sin pasos inventados.

## Privacidad y ciclo de vida

- No existe historial.
- No se escribe en disco, Firebase, analítica ni registros propios.
- Salir de la pantalla, cerrar sesión o cerrar la aplicación destruye la conversación.

## Rendimiento

- La respuesta local debe mostrarse en menos de un segundo en 20 repeticiones.
- No requiere red y debe operar en modo avión.

