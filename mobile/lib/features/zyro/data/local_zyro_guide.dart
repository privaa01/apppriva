enum ZyroReplyKind { guidance, unverified, sensitive, refused }

class ZyroReply {
  const ZyroReply(this.text, this.kind);
  final String text;
  final ZyroReplyKind kind;
}

class ZyroQuestionCategory {
  const ZyroQuestionCategory({required this.name, required this.questions});
  final String name;
  final List<String> questions;
}

class LocalZyroGuide {
  const LocalZyroGuide();

  static const quickPrompts = <String>[
    '¿Cómo protejo mi cuenta?',
    '¿Cómo creo una contraseña segura?',
    '¿Qué hago con un enlace sospechoso?',
    '¿Cómo cuido mi privacidad en redes?',
    '¿Qué hago si entraron a mi cuenta?',
  ];

  static const questionCategories = <ZyroQuestionCategory>[
    ZyroQuestionCategory(
      name: 'Protección de la cuenta',
      questions: [
        '¿Cómo protejo mi cuenta?',
        '¿Cómo hago mi cuenta más segura?',
        '¿Qué debo revisar para asegurar mi cuenta?',
        '¿Qué medidas básicas protegen mi cuenta?',
        '¿Cómo evito que alguien entre a mi cuenta?',
        '¿Qué debo configurar al crear una cuenta?',
        '¿Cómo reviso si mi cuenta está segura?',
        '¿Por qué debo revisar las sesiones abiertas?',
        '¿Cómo mantengo seguros mis datos de recuperación?',
        '¿Qué hábitos ayudan a proteger una cuenta?',
      ],
    ),
    ZyroQuestionCategory(
      name: 'Contraseñas y verificación',
      questions: [
        '¿Cómo creo una contraseña segura?',
        '¿Debo usar una contraseña diferente en cada cuenta?',
        '¿Cómo activo la verificación en dos pasos?',
        '¿Qué características tiene una contraseña segura?',
        '¿Cuánto debe medir una contraseña?',
        '¿Puedo reutilizar la misma contraseña?',
        '¿Qué datos debo evitar en mi contraseña?',
        '¿Qué hago si olvidé mi contraseña?',
        '¿Cómo guardo mis contraseñas de forma segura?',
        '¿Qué es la verificación en dos pasos?',
      ],
    ),
    ZyroQuestionCategory(
      name: 'Enlaces y mensajes sospechosos',
      questions: [
        '¿Cómo reconozco un enlace sospechoso?',
        '¿Qué hago si recibo un link extraño?',
        '¿Cómo verifico un mensaje sospechoso?',
        '¿Cómo sé si un link es falso?',
        '¿Qué señales tiene un mensaje fraudulento?',
        '¿Debo abrir un enlace de un desconocido?',
        '¿Qué hago si ya abrí un enlace sospechoso?',
        '¿Cómo verifico una promoción inesperada?',
        '¿Por qué un mensaje urgente puede ser peligroso?',
        '¿Qué hago si un correo me pide iniciar sesión?',
      ],
    ),
    ZyroQuestionCategory(
      name: 'Privacidad en redes',
      questions: [
        '¿Cómo cuido mi privacidad en redes?',
        '¿Quién puede ver mis publicaciones?',
        '¿Debo compartir mi ubicación?',
        '¿Cómo limito quién ve mi perfil?',
        '¿Qué información no debo publicar?',
        '¿Es seguro compartir mi ubicación en tiempo real?',
        '¿Cómo reviso la privacidad de una red social?',
        '¿Debo publicar fotos de documentos?',
        '¿Cómo reduzco la información visible de mi perfil?',
        '¿Qué debo revisar antes de publicar una foto?',
      ],
    ),
    ZyroQuestionCategory(
      name: 'Cuenta comprometida',
      questions: [
        '¿Qué hago si entraron a mi cuenta?',
        '¿Qué hago si hackearon mi cuenta?',
        '¿Cómo recupero una cuenta comprometida?',
        '¿Cómo sé si entraron a mi cuenta?',
        '¿Qué señales indican una cuenta comprometida?',
        '¿Qué hago si no puedo entrar a una cuenta comprometida?',
        '¿Cómo cierro sesiones que no reconozco?',
        '¿Cómo recupero el acceso después de que entraron?',
        '¿Qué hago si recibo una alerta de acceso desconocido?',
        '¿Cómo respondo ante una cuenta comprometida?',
      ],
    ),
  ];

  ZyroReply answer(String input) {
    final query = _normalize(input);
    if (_containsAny(query, const [
      'mi contrasena es',
      'mi clave es',
      'mi codigo es',
      'te paso mi codigo',
    ])) {
      return const ZyroReply(
        'No compartas contraseñas, códigos de verificación ni datos privados. '
        'Borra ese dato del mensaje y cuéntame el problema de forma general.',
        ZyroReplyKind.sensitive,
      );
    }
    if (_containsAny(query, const [
      'quiero hackear',
      'como hackear',
      'entrar a una cuenta ajena',
      'robar una contrasena',
      'espiar mensajes',
    ])) {
      return const ZyroReply(
        'No puedo ayudar a acceder a cuentas o datos de otras personas. Puedo '
        'orientarte para proteger tu propia cuenta o recuperar su acceso por el '
        'canal oficial.',
        ZyroReplyKind.refused,
      );
    }
    if (_containsAny(query, const [
      'proteger mi cuenta',
      'protejo mi cuenta',
      'como proteger mi cuenta',
      'como puedo proteger mi cuenta',
      'proteger una cuenta',
      'asegurar mi cuenta',
      'cuenta mas segura',
      'seguridad de mi cuenta',
      'protegen mi cuenta',
      'evito que alguien entre a mi cuenta',
      'configurar al crear una cuenta',
      'cuenta esta segura',
      'sesiones abiertas',
      'datos de recuperacion',
    ])) {
      return const ZyroReply(
        'Para proteger tu cuenta:\n1. Usa una contraseña larga y diferente.\n'
        '2. Activa la verificación en dos pasos.\n3. Revisa y cierra las sesiones '
        'que no reconozcas.\n4. Mantén actualizado tu correo o método de '
        'recuperación.\n5. No compartas contraseñas ni códigos.\n6. Evita iniciar '
        'sesión desde enlaces recibidos por mensajes.',
        ZyroReplyKind.guidance,
      );
    }
    if (_containsAny(query, const [
      'contrasena',
      'contrasenas',
      'clave',
      'claves',
      'verificacion en dos pasos',
    ])) {
      return const ZyroReply(
        'Para proteger tus cuentas:\n1. Usa una contraseña larga y diferente en '
        'cada cuenta.\n2. Evita nombres, fechas y datos personales.\n3. Activa la '
        'verificación en dos pasos cuando esté disponible.\n4. Nunca compartas '
        'contraseñas ni códigos.',
        ZyroReplyKind.guidance,
      );
    }
    if (_containsAny(query, const [
      'enlace',
      'link',
      'premio',
      'mensaje sospechoso',
      'mensaje fraudulento',
      'promocion inesperada',
      'mensaje urgente',
      'correo me pide iniciar sesion',
    ])) {
      return const ZyroReply(
        'Antes de abrir un enlace:\n1. Detente si el mensaje usa urgencia o promete '
        'un premio inesperado.\n2. No ingreses contraseñas ni datos bancarios.\n3. '
        'Busca el sitio o canal oficial por tu cuenta para verificar la información.',
        ZyroReplyKind.guidance,
      );
    }
    if (_containsAny(query, const [
      'privacidad',
      'red social',
      'publicacion',
      'publicar',
      'ubicacion',
      'quien ve mi perfil',
      'informacion visible de mi perfil',
    ])) {
      return const ZyroReply(
        'Para reducir la exposición en redes sociales:\n1. Revisa quién puede ver '
        'tus publicaciones.\n2. Evita compartir ubicación en tiempo real, dirección '
        'o documentos.\n3. Publica fotografías de viajes después de regresar.',
        ZyroReplyKind.guidance,
      );
    }
    if (_containsAny(query, const [
      'entraron a mi cuenta',
      'cuenta comprometida',
      'me robaron la cuenta',
      'hackearon mi cuenta',
      'sesiones que no reconozco',
      'despues de que entraron',
      'acceso desconocido',
    ])) {
      return const ZyroReply(
        'Si crees que alguien entró a tu cuenta:\n1. Abre la aplicación o sitio '
        'oficial.\n2. Cambia la contraseña.\n3. Cierra las sesiones que no reconozcas.\n'
        '4. Activa la verificación en dos pasos.\n5. Usa la recuperación oficial si '
        'ya no puedes entrar.',
        ZyroReplyKind.guidance,
      );
    }
    if (_containsAny(query, const [
      'eliminar',
      'borrar cuenta',
      'desactivar',
      'instagram',
      'facebook',
      'tiktok',
    ])) {
      return const ZyroReply(
        'Todavía no tengo una guía de plataforma verificada para darte pasos exactos. '
        'No quiero inventarlos. Busca “Cuenta”, “Privacidad” o “Centro de cuentas” '
        'dentro de la aplicación oficial y distingue entre desactivar temporalmente '
        'y eliminar de forma permanente.',
        ZyroReplyKind.unverified,
      );
    }
    return const ZyroReply(
      'No tengo una guía verificada para esa consulta. Puedo orientarte sobre '
      'protección de cuentas, contraseñas, enlaces sospechosos, privacidad en redes, '
      'cuentas comprometidas o eliminación y desactivación de cuentas.',
      ZyroReplyKind.unverified,
    );
  }

  bool _containsAny(String value, List<String> terms) =>
      terms.any(value.contains);

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
