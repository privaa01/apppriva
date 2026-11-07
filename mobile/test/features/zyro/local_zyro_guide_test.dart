import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/zyro/data/local_zyro_guide.dart';

void main() {
  const guide = LocalZyroGuide();

  test('F05-GUIDE returns verified local guidance for supported topics', () {
    expect(
      guide.answer('¿Cómo creo una contraseña?').kind,
      ZyroReplyKind.guidance,
    );
    expect(
      guide.answer('Recibí un enlace con un premio').text,
      contains('canal oficial'),
    );
    expect(
      guide.answer('Creo que entraron a mi cuenta').text,
      contains('Cierra las sesiones'),
    );
  });

  test('F05-GUIDE answers general account protection and variants', () {
    for (final query in [
      '¿Cómo protejo mi cuenta?',
      'Quiero asegurar mi cuenta',
      '¿Cómo evito que entren a mi cuenta?',
      'Seguridad de mi cuenta',
      'Necesito una cuenta segura',
    ]) {
      final reply = guide.answer(query);
      expect(reply.kind, ZyroReplyKind.guidance, reason: query);
      expect(
        reply.text,
        contains('Activa la verificación en dos pasos'),
        reason: query,
      );
      expect(reply.text, contains('sesiones que no reconozcas'), reason: query);
    }
  });

  test(
    'F05-GUIDE distinguishes a compromised account from a harmful request',
    () {
      final victim = guide.answer('Me hackearon mi cuenta');
      expect(victim.kind, ZyroReplyKind.guidance);
      expect(victim.text, contains('Cambia la contraseña'));

      expect(
        guide.answer('Quiero hackear una cuenta').kind,
        ZyroReplyKind.refused,
      );
    },
  );

  test('F05-GUIDE covers admitted topics through common variants', () {
    final cases = <String, String>{
      '¿Qué es la verificación en dos pasos?': 'verificación en dos pasos',
      '¿Qué es el phishing?': 'canal oficial',
      '¿Quién puede ver mis publicaciones?': 'quién puede ver',
      'Cómo cuido lo que subo a redes sociales': 'exposición',
      '¿Cómo sé si un perfil es falso?': 'canal que ya conozcas',
      'Revisar privacidad': 'exposición',
      'Recibí un SMS urgente con un premio': 'canal oficial',
    };
    cases.forEach((query, expected) {
      final reply = guide.answer(query);
      expect(reply.kind, ZyroReplyKind.guidance, reason: query);
      expect(reply.text, contains(expected), reason: query);
    });
  });

  test('F05-GUIDE refuses sensitive data and harmful requests', () {
    for (final query in [
      'Mi contraseña es ejemplo123',
      'Te paso mi código 123456',
      'Mi tarjeta es 4111 1111 1111 1111',
    ]) {
      expect(guide.answer(query).kind, ZyroReplyKind.sensitive, reason: query);
    }
    expect(
      guide.answer('Quiero hackear una cuenta').kind,
      ZyroReplyKind.refused,
    );
  });

  test('F05-GUIDE never invents account deletion steps', () {
    for (final query in [
      '¿Cómo elimino Instagram?',
      'Quiero desactivar mi cuenta de Facebook',
      'Eliminar o desactivar una cuenta',
    ]) {
      final reply = guide.answer(query);
      expect(reply.kind, ZyroReplyKind.unverified, reason: query);
      expect(
        reply.text,
        contains('no tengo una guía de plataforma verificada'),
        reason: query,
      );
    }
  });

  test('F05-GUIDE unknown query explains the supported scope', () {
    final reply = guide.answer('¿Qué película me recomiendas?');
    expect(reply.kind, ZyroReplyKind.unverified);
    expect(reply.text, contains('No tengo una guía verificada'));
  });
}
