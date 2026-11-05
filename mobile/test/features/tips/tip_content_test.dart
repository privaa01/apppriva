import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'tips_test_fixtures.dart';

import 'package:priva_mobile/features/tips/data/tip_content.dart';

void main() {
  final payload = jsonDecode(
    File('assets/content/tips-1.0.0.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  test(
    'F04-CONTENT native fixture equals the approved bundled payload',
    () {
      expect(approvedTipsPayload(), payload);
    },
  );
  test('F04-CONTENT approved four documents satisfy the production schema', () {
    for (final id in TipContent.ids) {
      expect(
        () =>
            TipContent.parse(id, Map<String, dynamic>.from(payload[id] as Map)),
        returnsNormally,
      );
    }
  });
  test(
    'F04-CONTENT rejects missing, extra, mixed-version and wrong-category data',
    () {
      final valid = Map<String, dynamic>.from(payload['passwords'] as Map);
      for (final mutation in [
        {...valid}..remove('advice'),
        {...valid, 'email': 'synthetic@example.test'},
        {...valid, 'schemaVersion': 2},
        {...valid, 'contentVersion': 'draft'},
        {...valid, 'categoryId': 'sharing'},
        {
          ...valid,
          'recommendations': ['one'],
        },
        {...valid, 'explanation': ''},
        {...valid, 'title': List.filled(33000, 'a').join()},
      ]) {
        expect(
          () => TipContent.parse('passwords', mutation),
          throwsFormatException,
        );
      }
      expect(() => TipContent.parse('arbitrary', valid), throwsFormatException);
    },
  );
  test(
    'F04-EDITORIAL payload educational text matches the approved source',
    () {
      final editorial = File(
        '../specs/004-tips-educativos/contenido-editorial.md',
      ).readAsStringSync();
      for (final value in payload.values) {
        final tip = value as Map<String, dynamic>;
        for (final field in [
          'title',
          'description',
          'panelTitle',
          'explanation',
          'advice',
          'clarification',
        ]) {
          expect(
            editorial,
            contains(tip[field] as String),
            reason: '${tip['categoryId']} $field',
          );
        }
        for (final recommendation in tip['recommendations'] as List) {
          expect(editorial, contains(recommendation as String));
        }
      }
    },
  );
}
