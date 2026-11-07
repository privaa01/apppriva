enum ZyroReplyKind { guidance, unverified, sensitive, refused }

class ZyroReply {
  const ZyroReply(this.text, this.kind);
  final String text;
  final ZyroReplyKind kind;
}

class LocalZyroGuide {
  const LocalZyroGuide();

  static const quickPrompts = <String>[
    'Proteger mi cuenta',
    'Proteger mis contraseñas',
    'Reconocer un enlace sospechoso',
    'Revisar la privacidad de mis redes',
    'Creo que entraron a mi cuenta',
    'Eliminar o desactivar una cuenta',
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
      'hackear',
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
