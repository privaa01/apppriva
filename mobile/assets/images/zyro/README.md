# Imágenes de Zyro

Sube aquí las ilustraciones originales de Zyro para asociarlas a las pantallas de
Priva. Esta carpeta está registrada como directorio de assets en `mobile/pubspec.yaml`.

Usa PNG con fondo transparente cuando corresponda. Conserva únicamente la
ilustración: las capturas completas de pantallas son referencias de diseño, no
imágenes para renderizar como interfaz. No incluyas datos personales reales.

## Correspondencia con las pantallas

Los nombres siguientes permiten identificar el destino de cada archivo. No es
necesario subir una imagen para todas las pantallas. Esta tabla no decide añadir
Zyro donde el wireframe no lo indique.

| Archivo esperado | Pantalla de destino | Spec responsable |
| --- | --- | --- |
| `p01-inicio.png` | Inicio | F03 — Inicio y navegación |
| `p02-tips.png` | Tips | F04 — Tips educativos |
| `p03-contrasenas.png` | Contraseñas seguras | F04 — Tips educativos |
| `p04-cuida-lo-que-subes.png` | Cuida lo que subes | F04 — Tips educativos |
| `p05-enlaces-sospechosos.png` | Enlaces sospechosos | F04 — Tips educativos |
| `p06-perfiles-falsos.png` | Perfiles falsos | F04 — Tips educativos |
| `p07-chat.png` | Chat IA — Zyro | F05 — Orientación mediante Zyro |
| `p08-cuestionario.png` | Cuestionario | F06 — Cuestionario |
| `p09-resultados.png` | Resultados | F07 — Resultados |
| `p10-crear-cuenta.png` | Crear cuenta | F01 — Cuenta y acceso |
| `p11-iniciar-sesion.png` | Iniciar sesión; ilustración confirmada en el wireframe recibido | F01 — Cuenta y acceso |
| `p12-perfil.png` | Perfil, solo si el diseño lo requiere | F02 — Perfil y cuenta |

Los IDs P01–P12 proceden del [inventario de pantallas](../../../../docs/descomposicion/README.md).
La posición, tamaño y variante se contrastarán con el wireframe de cada pantalla.

## Subir desde GitHub

1. Abre esta carpeta en GitHub y selecciona **Add file → Upload files**.
2. Sube las imágenes con el nombre de su pantalla y confirma los cambios en la rama
   en la que estés trabajando.
3. Indica en el chat que las imágenes están listas para integrarlas.

Si una misma ilustración se utiliza en varias pantallas, sube un único archivo con
nombre descriptivo e indica los destinos; no es necesario duplicarla.

## Integración en Flutter

La ruta de un archivo, una vez subido, será por ejemplo
`assets/images/zyro/p11-iniciar-sesion.png`. Antes de conectarlo a una vista, comprobar
que existe y que corresponde al diseño. Mantener textos como widgets ajustables,
proporciones de imagen y una descripción accesible cuando aporte información;
excluir de semántica las ilustraciones meramente decorativas.

Estado inicial: carpeta preparada, sin ilustraciones originales subidas ni vínculos
visuales implementados. No sustituir la imagen de Zyro por una captura completa ni
implementar otras funcionalidades para incorporar un asset.
