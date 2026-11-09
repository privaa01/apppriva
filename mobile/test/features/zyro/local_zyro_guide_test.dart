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

  test('F05-GUIDE every main question returns useful guidance', () {
    for (final question in LocalZyroGuide.quickPrompts) {
      final reply = guide.answer(question);
      expect(reply.kind, ZyroReplyKind.guidance, reason: question);
      expect(reply.text, isNot(contains('No tengo una guía')));
    }
  });

  test('F05-GUIDE every categorized question returns useful guidance', () {
    expect(LocalZyroGuide.questionCategories, hasLength(5));
    for (final category in LocalZyroGuide.questionCategories) {
      expect(category.questions, hasLength(10), reason: category.name);
      for (final question in category.questions) {
        final reply = guide.answer(question);
        expect(reply.kind, ZyroReplyKind.guidance, reason: question);
      }
    }
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

  test('F05-GUIDE answers sufficiently similar catalog questions', () {
    final account = guide.answer(
      '¿Qué debo revisar para tener una cuenta protegida?',
    );
    expect(account.kind, ZyroReplyKind.guidance);
    expect(account.text, contains('verificación en dos pasos'));

    final privacy = guide.answer(
      '¿Qué información conviene ocultar de mi perfil?',
    );
    expect(privacy.kind, ZyroReplyKind.guidance);
    expect(privacy.text, contains('exposición en redes sociales'));
  });

  test('F05-GUIDE tolerates a small spelling error in a similar question', () {
    final reply = guide.answer(
      '¿Cómo reduzco la información visible de mi perfl?',
    );
    expect(reply.kind, ZyroReplyKind.guidance);
    expect(reply.text, contains('exposición en redes sociales'));
  });

  test('F05-GUIDE does not force unrelated or ambiguous questions', () {
    expect(
      guide.answer('¿Qué película me recomiendas?').kind,
      ZyroReplyKind.unverified,
    );
    expect(
      guide.answer('¿Cómo organizo mejor mi día?').kind,
      ZyroReplyKind.unverified,
    );
  });

  test('F05-PERF 20 local replies each complete under one second', () {
    final questions = [
      ...LocalZyroGuide.quickPrompts,
      for (final category in LocalZyroGuide.questionCategories)
        ...category.questions,
    ];
    for (var index = 0; index < 20; index++) {
      final stopwatch = Stopwatch()..start();
      final reply = guide.answer(questions[index % questions.length]);
      stopwatch.stop();
      expect(reply.text, isNotEmpty);
      expect(
        stopwatch.elapsed,
        lessThan(const Duration(seconds: 1)),
        reason: 'Respuesta ${index + 1}',
      );
    }
  });
}
