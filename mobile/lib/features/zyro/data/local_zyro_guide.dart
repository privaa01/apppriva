enum ZyroReplyKind { guidance, unverified, sensitive, refused }

class ZyroReply {
  const ZyroReply(this.text, this.kind);
  final String text;
  final ZyroReplyKind kind;
}

class _Rule {
  const _Rule(this.terms, this.reply);
  final List<String> terms;
  final ZyroReply reply;
}

class LocalZyroGuide {
  const LocalZyroGuide();

  static const quickPrompts = <String>[
    'Proteger una cuenta',
    'Reconocer engaños',
    'Revisar privacidad',
    'Cuenta comprometida',
    'Eliminar o desactivar una cuenta',
  ];

  // El orden importa: primero se protegen los datos sensibles, después se
  // distingue a una víctima de una petición dañina y, por último, se buscan
  // los temas admitidos. Así «me hackearon mi cuenta» no se confunde con
  // «quiero hackear una cuenta».
  static const _rules = <_Rule>[
    _Rule(
      [
        'mi contrasena es',
        'mi clave es',
        'mi codigo es',
        'mi pin es',
        'te paso mi codigo',
        'te comparto mi codigo',
        'te doy mi contrasena',
        'mi tarjeta es',
        'mi numero de tarjeta',
        'mi dni es',
        'mi documento es',
        'mi direccion es',
        'mi telefono es',
      ],
      ZyroReply(
        'No compartas contraseñas, códigos de verificación ni datos privados. '
        'Borra ese dato del mensaje y cuéntame el problema de forma general.',
        ZyroReplyKind.sensitive,
      ),
    ),
    _Rule(
      [
        'entraron a mi cuenta',
        'entraron en mi cuenta',
        'alguien entro a mi cuenta',
        'cuenta comprometida',
        'me robaron la cuenta',
        'me robaron mi cuenta',
        'robaron mi cuenta',
        'me hackearon',
        'hackearon mi cuenta',
        'hackearon mi correo',
        'accedieron a mi cuenta',
        'acceso no autorizado',
        'actividad sospechosa en mi cuenta',
        'no puedo entrar a mi cuenta',
        'perdi el acceso a mi cuenta',
        'olvide mi contrasena',
        'olvide la contrasena',
        'olvide mi clave',
        'me cambiaron la contrasena',
        'me cambiaron la clave',
      ],
      ZyroReply(
        'Si crees que alguien entró a tu cuenta:\n1. Abre la aplicación o sitio '
        'oficial.\n2. Cambia la contraseña.\n3. Cierra las sesiones que no reconozcas.\n'
        '4. Activa la verificación en dos pasos.\n5. Usa la recuperación oficial si '
        'ya no puedes entrar.',
        ZyroReplyKind.guidance,
      ),
    ),
    _Rule(
      [
        'hackear',
        'hackeo',
        'entrar a una cuenta ajena',
        'entrar a la cuenta de',
        'acceder a la cuenta de',
        'acceder sin permiso',
        'robar una contrasena',
        'robar la contrasena',
        'conseguir la contrasena',
        'obtener la contrasena',
        'descifrar la contrasena',
        'espiar mensajes',
        'espiar a mi',
        'espiar el telefono',
        'espiar su telefono',
        'leer mensajes de',
        'instalar un espia',
        'virus para',
      ],
      ZyroReply(
        'No puedo ayudar a acceder a cuentas o datos de otras personas. Puedo '
        'orientarte para proteger tu propia cuenta o recuperar su acceso por el '
        'canal oficial.',
        ZyroReplyKind.refused,
      ),
    ),
    _Rule(
      [
        'protejo mi cuenta',
        'proteger mi cuenta',
        'protege mi cuenta',
        'proteger mis cuentas',
        'protege mis cuentas',
        'proteger una cuenta',
        'protege una cuenta',
        'asegurar mi cuenta',
        'aseguro mi cuenta',
        'seguridad de mi cuenta',
        'seguridad de mis cuentas',
        'cuenta segura',
        'cuentas seguras',
        'cuidar mi cuenta',
        'evitar que entren a mi cuenta',
        'evito que entren a mi cuenta',
        'evitar que me hackeen',
        'evito que me hackeen',
        'evitar hackeos',
        'evito hackeos',
        'mejorar la seguridad de mi cuenta',
        'mi cuenta esta segura',
        'mi cuenta protegida',
        'como protejo mi cuenta',
        'como proteger mi cuenta',
        'como asegurar mi cuenta',
      ],
      ZyroReply(
        'Para proteger tu cuenta:\n1. Usa una contraseña larga y diferente para '
        'cada cuenta.\n2. Activa la verificación en dos pasos cuando esté disponible.\n'
        '3. Revisa y cierra las sesiones que no reconozcas.\n4. Mantén actualizado '
        'tu correo y método de recuperación.\n5. No compartas contraseñas ni códigos.\n'
        '6. Desconfía de mensajes que pidan iniciar sesión desde un enlace.',
        ZyroReplyKind.guidance,
      ),
    ),
    _Rule(
      [
        'contrasena',
        'contrasenas',
        'clave',
        'claves',
        'password',
        'passwords',
        '2fa',
        'doble factor',
        'verificacion en dos pasos',
        'autenticacion en dos pasos',
        'verificacion de dos pasos',
        'codigo de verificacion',
        'pin de seguridad',
      ],
      ZyroReply(
        'Para proteger tus cuentas:\n1. Usa una contraseña larga y diferente en '
        'cada cuenta.\n2. Evita nombres, fechas y datos personales.\n3. Activa la '
        'verificación en dos pasos cuando esté disponible.\n4. Nunca compartas '
        'contraseñas ni códigos.',
        ZyroReplyKind.guidance,
      ),
    ),
    _Rule(
      [
        'perfil falso',
        'perfiles falsos',
        'perfil es falso',
        'perfiles son falsos',
        'cuenta falsa',
        'cuentas falsas',
        'cuenta es falsa',
        'cuenta sea falsa',
        'perfil sospechoso',
        'suplantacion de identidad',
        'me suplantaron',
        'me piden dinero',
        'me pide dinero',
        'solicitud de amistad',
        'persona desconocida',
        'cita por internet',
        'verificar un perfil',
      ],
      ZyroReply(
        'Para revisar un perfil sospechoso:\n1. Verifica la identidad por un canal '
        'que ya conozcas.\n2. Revisa publicaciones e interacciones, pero recuerda '
        'que tener pocas publicaciones no demuestra que sea falso.\n3. No compartas '
        'datos personales ni envíes dinero.\n4. Si crees que suplanta a alguien, '
        'denúncialo desde la red social y evita interactuar.',
        ZyroReplyKind.guidance,
      ),
    ),
    _Rule(
      [
        'enlace',
        'enlaces',
        'link',
        'links',
        'premio',
        'premios',
        'mensaje sospechoso',
        'mensajes sospechosos',
        'phishing',
        'sms',
        'correo sospechoso',
        'correo raro',
        'mensaje del banco',
        'urgente',
        'urgencia',
        'ganaste',
        'regalo',
        'regalos',
        'promocion',
        'estafa',
        'estafas',
        'fraude',
        'engano',
        'enganos',
      ],
      ZyroReply(
        'Antes de abrir un enlace:\n1. Detente si el mensaje usa urgencia o promete '
        'un premio inesperado.\n2. No ingreses contraseñas ni datos bancarios.\n3. '
        'Busca el sitio o canal oficial por tu cuenta para verificar la información.',
        ZyroReplyKind.guidance,
      ),
    ),
    _Rule(
      [
        'privacidad',
        'red social',
        'redes sociales',
        'publicacion',
        'publicaciones',
        'publicar',
        'ubicacion',
        'quien puede ver',
        'audiencia',
        'exposicion',
        'compartir informacion',
        'compartir mis fotos',
        'lo que subo',
        'subir fotos',
        'mi informacion personal',
        'permisos de la aplicacion',
        'permisos de las aplicaciones',
      ],
      ZyroReply(
        'Para reducir la exposición en redes sociales:\n1. Revisa quién puede ver '
        'tus publicaciones.\n2. Evita compartir ubicación en tiempo real, dirección '
        'o documentos.\n3. Publica fotografías de viajes después de regresar.\n'
        '4. Revisa los permisos de las aplicaciones y limita el acceso a cámara, '
        'micrófono o ubicación cuando no los necesites.',
        ZyroReplyKind.guidance,
      ),
    ),
    _Rule(
      [
        'eliminar mi cuenta',
        'eliminar la cuenta',
        'eliminar cuenta',
        'eliminar una cuenta',
        'borrar mi cuenta',
        'borrar la cuenta',
        'borrar cuenta',
        'borrar una cuenta',
        'desactivar mi cuenta',
        'desactivar la cuenta',
        'desactivar cuenta',
        'desactivar una cuenta',
        'darse de baja',
        'dar de baja',
        'cerrar mi cuenta',
        'cerrar la cuenta',
        'cerrar cuenta',
        'instagram',
        'facebook',
        'tiktok',
        'whatsapp',
        'twitter',
        'snapchat',
        'telegram',
        'gmail',
        'google',
        'youtube',
        'linkedin',
      ],
      ZyroReply(
        'Todavía no tengo una guía de plataforma verificada para darte pasos exactos. '
        'No quiero inventarlos. Busca “Cuenta”, “Privacidad” o “Centro de cuentas” '
        'dentro de la aplicación oficial y distingue entre desactivar temporalmente '
        'y eliminar de forma permanente.',
        ZyroReplyKind.unverified,
      ),
    ),
  ];

  ZyroReply answer(String input) {
    final query = _normalize(input);
    for (final rule in _rules) {
      if (rule.terms.any(query.contains)) {
        return rule.reply;
      }
    }
    return const ZyroReply(
      'No tengo una guía verificada para esa consulta. Puedo orientarte sobre '
      'protección de cuentas, contraseñas, enlaces y mensajes engañosos, privacidad '
      'en redes, perfiles falsos, cuentas comprometidas o eliminación y '
      'desactivación de cuentas.',
      ZyroReplyKind.unverified,
    );
  }

  String _normalize(String value) {
    var result = value.toLowerCase().trim();
    const accents = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ü': 'u',
      'ñ': 'n',
    };
    accents.forEach((from, to) => result = result.replaceAll(from, to));
    return result;
  }
}
