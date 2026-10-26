# Actualización de pantallas — 2026-10-26

Fuente: dos imágenes adjuntas por el usuario en el chat, revisadas visualmente.
Los nombres locales comunicados son «WhatsApp Image 2026-10-26 at 3.45.10 PM (1).jpeg»
y «WhatsApp Image 2026-10-26 at 3.45.10 PM.jpeg». La asociación se realiza por contenido,
no se presume cuál nombre corresponde a cada imagen. Las rutas `/Users/...` son del
dispositivo del usuario; no son archivos accesibles del entorno en la nube.
Esta nota registra la revisión; no sustituye ni afirma conservar los archivos de imagen.

## Decisión explícita del usuario

«la app no pide numero de telefono».

Priva no solicita ni incorpora un teléfono de usuario como dato de registro, perfil
o recuperación. No se presume recuperación por SMS. No se elige por ello ningún
mecanismo alternativo: PD-09 sigue pendiente para los detalles de recuperación.

## P11 — Iniciar sesión

Se observan correo electrónico, contraseña y botón «Iniciar sesión», junto a una
ilustración de Zyro. La ausencia de diseño de P11 (D01) está subsanada.
También se observan Inicio, Perfil y menú inferior Tips/Chat IA/Cuestionario.
Estos controles contradicen §5 y CA-03.1 del spec original (D16).
Propuesta pendiente: retirarlos del acceso, manteniendo la regla escrita.
No se observa recuperación de acceso ni estados de validación/error en la imagen.
La imagen no acredita implementación ni corrección de autenticación.

## P12 — Perfil corregido

Se observan saludo, correo ilustrativo, cierre de sesión, cabecera y menú inferior.
No aparecen número de teléfono ni el texto «Estado de tus datos: Medio».
Permanece una fila vacía: no se le asigna una finalidad ni un dato por inferencia.
Se propone retirarla si no corresponde a un requisito aprobado.
No se observan controles de edición, eliminación de cuenta ni tamaño de texto.
No se copia el correo ilustrativo como dato real o configuración del proyecto.

## Gobierno

Actualización limitada a evidencia visual y decisión de no pedir teléfono.
No ratifica la constitución ni aprueba todos los specs. No se avanza a planificación,
tareas ni implementación. El PDF y el spec original se mantienen intactos.

## Decisión posterior que sustituye la propuesta sobre D16

El usuario indicó «mantenlo depende los wireframe» y aclaró:
«al no iniciar sesion solo se podra acceder a los tips, cuando se inicia sesion
el usuario tiene derecho a toda la app».

Por tanto, NO se retira la navegación del diseño de acceso. D16 queda resuelto
mediante acceso público a Tips y sus cuatro detalles, con el resto del contenido
protegido hasta iniciar sesión. Los flujos de registro/acceso/recuperación siguen
siendo utilizables sin sesión. Se mantiene el control de la propia cuenta.
Esta decisión sustituye únicamente las reglas afectadas; no aprueba globalmente
los borradores ni autoriza avanzar de etapa. Los originales se conservan como
antecedentes y los borradores funcionales incorporan la revisión y sus criterios.
