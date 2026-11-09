import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/questionnaire/data/bundled_question_bank_repository.dart';
import 'package:priva_mobile/features/questionnaire/data/question_bank_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('el asset aprobado tiene 67 IDs, cinco módulos y porcentajes', () async {
    final bank = await BundledQuestionBankRepository().load();
    expect(bank.questions, hasLength(67));
    expect(
      bank.questions.map((question) => question.id).toSet(),
      hasLength(67),
    );
    expect(
      bank.questions.map((question) => question.topic).toSet(),
      hasLength(5),
    );
    for (final question in bank.questions) {
      expect(
        question.options.map((option) => option.id),
        containsAll(['A', 'B', 'C']),
      );
      expect(question.options, hasLength(3));
      expect(
        question.options.every(
          (option) =>
              option.vulnerabilityPercent >= 0 &&
              option.vulnerabilityPercent <= 100,
        ),
        isTrue,
      );
    }
  });

  test('la revisión 2.0.1 usa lenguaje claro en preguntas complejas', () async {
    final bank = await BundledQuestionBankRepository().load();
    expect(bank.contentVersion, 'question-bank-es-CO-2.0.1');
    expect(bank.reviewedOn, '2026-11-09');
    final prompts = {
      for (final question in bank.questions) question.id: question.prompt,
    };
    expect(
      prompts['Q009'],
      '¿Proteges la aplicación donde guardas tus contraseñas con una '
      'contraseña principal segura?',
    );
    expect(prompts['Q041'], contains('servicio DNS privado'));
    expect(
      prompts['Q067'],
      '¿Has modificado el sistema de tu celular para quitar las restricciones '
      'de fábrica?',
    );
    final allPrompts = prompts.values.join(' ').toLowerCase();
    for (final jargon in [
      'sólida e infalible',
      'notificación push',
      'oauth indiscriminadamente',
      'juice jacking',
      'ingeniería social y phishing',
      'jailbreak (ios) o rooting',
    ]) {
      expect(allPrompts, isNot(contains(jargon)), reason: jargon);
    }
  });

  test('rechaza todo el banco si el asset es inválido', () async {
    final bundle = _StringBundle(
      '{"schemaVersion":1,"status":"approved","questions":[]}',
    );
    await expectLater(
      BundledQuestionBankRepository(bundle: bundle).load(),
      throwsA(isA<QuestionBankException>()),
    );
  });
}

class _StringBundle extends CachingAssetBundle {
  _StringBundle(this.value);
  final String value;
  @override
  Future<String> loadString(String key, {bool cache = true}) async => value;
  @override
  Future<ByteData> load(String key) => throw UnimplementedError();
}
