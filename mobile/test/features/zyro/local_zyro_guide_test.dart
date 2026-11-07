import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/zyro/data/local_zyro_guide.dart';

void main() {
  const guide = LocalZyroGuide();

  test('F05-GUIDE returns local guidance for supported topics', () {
    expect(
      guide.answer('¿Cómo protejo mi cuenta?').kind,
      ZyroReplyKind.guidance,
    );
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

  test('F05-GUIDE refuses sensitive data and harmful requests', () {
    expect(
      guide.answer('Mi contraseña es ejemplo123').kind,
      ZyroReplyKind.sensitive,
    );
    expect(
      guide.answer('Quiero hackear una cuenta').kind,
      ZyroReplyKind.refused,
    );
  });

  test('F05-GUIDE never invents account deletion steps', () {
    final reply = guide.answer('¿Cómo elimino Instagram?');
    expect(reply.kind, ZyroReplyKind.unverified);
    expect(reply.text, contains('no tengo una guía de plataforma verificada'));
  });

  test('F05-GUIDE unknown query explains the supported scope', () {
    final reply = guide.answer('¿Qué película me recomiendas?');
    expect(reply.kind, ZyroReplyKind.unverified);
    expect(reply.text, contains('No tengo una guía verificada'));
  });
}
