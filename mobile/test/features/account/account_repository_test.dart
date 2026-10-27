import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:priva_mobile/app/account_errors.dart';
import 'package:priva_mobile/features/account/data/supabase_account_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const testId = '00000000-0000-4000-8000-000000000001';
Map<String, dynamic> user({bool confirmed = true}) => {
  'id': testId,
  'email': 'persona@example.test',
  'aud': 'authenticated',
  'created_at': '2026-10-27T00:00:00Z',
  'email_confirmed_at': confirmed ? '2026-10-27T00:00:00Z' : null,
  'app_metadata': <String, dynamic>{},
  'user_metadata': {
    'name': 'Untrusted metadata',
    'amr': [
      {'method': 'password'},
    ],
  },
};
String jwt({
  String? method = 'password',
  bool expired = false,
  String sub = testId,
}) {
  String part(Object data) =>
      base64Url.encode(utf8.encode(jsonEncode(data))).replaceAll('=', '');
  return '${part({'alg': 'HS256', 'typ': 'JWT'})}.${part({
    'sub': sub,
    'aud': 'authenticated',
    'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 + (expired ? -60 : 3600),
    if (method != null) 'amr': [
        {'method': method},
      ],
  })}.c2ln';
}

Map<String, dynamic> session({
  String? method = 'password',
  bool confirmed = true,
  bool expired = false,
  String sub = testId,
}) => {
  'access_token': jwt(method: method, expired: expired, sub: sub),
  'token_type': 'bearer',
  'expires_in': 3600,
  'refresh_token': 'synthetic-refresh',
  'user': user(confirmed: confirmed),
};
http.Response jsonResponse(Object body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json'},
  request: http.Request('GET', Uri.parse('https://project.example.test')),
);

void main() {
  late List<http.Request> requests;
  late Future<http.Response> Function(http.Request) handle;
  late SupabaseClient client;
  late SupabaseAccountRepository repo;
  setUp(() {
    requests = [];
    handle = (request) async {
      if (request.url.path.endsWith('/profiles'))
        return jsonResponse([
          {'id': testId, 'name': 'Mariana'},
        ]);
      if (request.url.path.endsWith('/treatment_policies'))
        return jsonResponse([
          {
            'version': 'synthetic-v1',
            'body': 'Datos ficticios',
            'purposes': ['Saludo'],
            'is_test': true,
          },
        ]);
      if (request.url.path.endsWith('/signup'))
        return jsonResponse(user(confirmed: false));
      if (request.url.path.endsWith('/verify'))
        return jsonResponse(session(method: 'otp'));
      if (request.url.path.endsWith('/token')) return jsonResponse(session());
      if (request.url.path.endsWith('/user')) return jsonResponse(user());
      return jsonResponse({});
    };
    client = SupabaseClient(
      'https://project.example.test',
      'sb_publishable_synthetic_test_key',
      authOptions: const AuthClientOptions(
        autoRefreshToken: false,
        authFlowType: AuthFlowType.implicit,
      ),
      httpClient: MockClient((r) {
        requests.add(r);
        return handle(r);
      }),
    );
    repo = SupabaseAccountRepository(client, allowTestPolicy: true);
  });
  tearDown(() async {
    await client.dispose();
  });

  test(
    'signup submits only required authorization metadata and has no phone',
    () async {
      await repo.signUp(
        name: 'Mariana',
        email: 'persona@example.test',
        password: 'Synthetic123!',
        policyVersion: 'synthetic-v1',
      );
      final req = requests.singleWhere((r) => r.url.path.endsWith('/signup'));
      final body = jsonDecode(req.body) as Map<String, dynamic>;
      expect(body['data'], {
        'name': 'Mariana',
        'policy_version': 'synthetic-v1',
        'authorization_accepted': true,
      });
      expect(body.containsKey('phone'), isFalse);
      expect(repo.currentSession, isNull);
    },
  );
  test(
    'signup fails closed if provider unexpectedly grants a session',
    () async {
      handle = (r) async => r.url.path.endsWith('/signup')
          ? jsonResponse(session())
          : jsonResponse({});
      await expectLater(
        repo.signUp(
          name: 'Mariana',
          email: 'persona@example.test',
          password: 'Synthetic123!',
          policyVersion: 'v1',
        ),
        throwsA(isA<AccountFailure>()),
      );
      expect(repo.currentSession, isNull);
    },
  );
  test('confirmed password session uses protected profile, never user metadata name', () async {
    final signed = await repo.signIn(
      email: 'persona@example.test',
      password: 'Synthetic123!',
    );
    expect(signed?.canAccessPrivate, isTrue);
    expect(signed?.displayName, 'Mariana');
    expect(requests.where((r) => r.url.path.endsWith('/profiles')).length, 1);
  });
  test(
    'OTP response cannot unlock login even if user metadata claims password',
    () async {
      handle = (r) async => r.url.path.endsWith('/token')
          ? jsonResponse(session(method: 'otp'))
          : jsonResponse({});
      await expectLater(
        repo.signIn(email: 'persona@example.test', password: 'Synthetic123!'),
        throwsA(isA<AccountFailure>()),
      );
      expect(repo.currentSession, isNull);
    },
  );
  test('unconfirmed password response is rejected', () async {
    handle = (r) async => r.url.path.endsWith('/token')
        ? jsonResponse(session(confirmed: false))
        : jsonResponse({});
    await expectLater(
      repo.signIn(email: 'persona@example.test', password: 'Synthetic123!'),
      throwsA(isA<AccountFailure>()),
    );
    expect(repo.currentSession, isNull);
  });
  test('invalid login provider descriptions are never exposed', () async {
    for (final error in [
      'User does not exist',
      'Email not confirmed',
      'Invalid credentials',
    ]) {
      handle = (r) async => jsonResponse({
        'msg': error,
        'error_code': 'invalid_credentials',
      }, 400);
      try {
        await repo.signIn(
          email: 'persona@example.test',
          password: 'Synthetic123!',
        );
        fail('Expected sanitized error');
      } catch (e) {
        expect(e, isA<AccountFailure>());
        expect(e.toString(), isNot(contains(error)));
      }
    }
  });
  test('recovery sends a recovery request, never creates a user or passwordless login', () async {
    await repo.requestRecovery('persona@example.test');
    expect(requests.map((r) => r.url.path).toList(), ['/auth/v1/recover']);
    expect(
      (jsonDecode(requests.single.body) as Map)['email'],
      'persona@example.test',
    );
    expect(repo.currentSession, isNull);
  });
  test(
    'recovery verifies an email code with recovery purpose and stays OTP-only',
    () async {
      await repo.verifyRecovery(email: 'persona@example.test', code: '123456');
      final body = jsonDecode(requests.single.body) as Map;
      expect(body['email'], 'persona@example.test');
      expect(body['token'], '123456');
      expect(body['type'], 'recovery');
      expect(repo.currentSession?.canAccessPrivate, isFalse);
    },
  );
  test('signup confirmation explicitly clears its OTP session', () async {
    await repo.confirmEmail(email: 'persona@example.test', code: '123456');
    final body = jsonDecode(requests.first.body) as Map;
    expect(body['type'], 'signup');
    expect(repo.currentSession, isNull);
  });
  test(
    'change password uses authenticated update and does not create a user',
    () async {
      await repo.verifyRecovery(email: 'persona@example.test', code: '123456');
      await repo.changePassword('Synthetic456!');
      final req = requests.singleWhere(
        (r) => r.method == 'PUT' && r.url.path.endsWith('/user'),
      );
      expect((jsonDecode(req.body) as Map)['password'], 'Synthetic456!');
      expect(requests.any((r) => r.url.path.endsWith('/signup')), isFalse);
    },
  );
  test(
    'production refuses test policy and ambiguous active versions',
    () async {
      final production = SupabaseAccountRepository(client);
      expect(await production.loadPolicy(), isNull);
      handle = (r) async => jsonResponse([
        {
          'version': 'v1',
          'body': 'Policy',
          'purposes': ['Saludo'],
          'is_test': false,
        },
        {
          'version': 'v2',
          'body': 'Policy',
          'purposes': ['Saludo'],
          'is_test': false,
        },
      ]);
      expect(await production.loadPolicy(), isNull);
    },
  );
  test(
    'local test policy can be read while selecting only active policies',
    () async {
      final policy = await repo.loadPolicy();
      expect(policy?.version, 'synthetic-v1');
      expect(policy?.isTest, isTrue);
      expect(requests.single.url.queryParameters['is_active'], 'eq.true');
    },
  );
  test('session events preserve AMR distinction after refresh', () async {
    final event = repo.sessionChanges.firstWhere((v) => v != null);
    final login = await repo.signIn(
      email: 'persona@example.test',
      password: 'Synthetic123!',
    );
    expect((await event)?.passwordAuthenticated, isTrue);
    expect(login?.canAccessPrivate, isTrue);
    handle = (r) async => r.url.path.endsWith('/token')
        ? jsonResponse(session(method: 'otp'))
        : jsonResponse({});
    await client.auth.refreshSession('synthetic-refresh');
    expect(repo.currentSession?.passwordAuthenticated, isFalse);
  });
}
