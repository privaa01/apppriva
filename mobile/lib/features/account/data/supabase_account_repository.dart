import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/account_errors.dart';
import '../application/account_state.dart';
import 'account_models.dart';
import 'account_repository.dart';

class SupabaseAccountRepository implements AccountRepository {
  SupabaseAccountRepository(this.client, {this.allowTestPolicy = false});
  final SupabaseClient client;
  final bool allowTestPolicy;
  AccountSession? _map(Session? s, {String? name}) {
    if (s == null) return null;
    try {
      final claims = jsonDecode(
        utf8.decode(
          base64Url.decode(base64Url.normalize(s.accessToken.split('.')[1])),
        ),
      ) as Map<String, dynamic>;
      final valid =
          claims['sub'] == s.user.id &&
          (claims['exp'] as num) > DateTime.now().millisecondsSinceEpoch / 1000;
      final password = (claims['amr'] as List? ?? []).any(
        (e) => e is Map && e['method'] == 'password',
      );
      return AccountSession(
        userId: s.user.id,
        emailVerified: valid && s.user.emailConfirmedAt != null,
        passwordAuthenticated: valid && password,
        displayName: name,
      );
    } catch (_) {
      return null;
    }
  }

  Future<T> _safe<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (_) {
      throw const AccountFailure();
    }
  }

  @override
  AccountSession? get currentSession => _map(client.auth.currentSession);
  @override
  Stream<AccountSession?> get sessionChanges =>
      client.auth.onAuthStateChange.map((e) => _map(e.session));
  @override
  Future<TreatmentPolicy?> loadPolicy() => _safe(() async {
    final rows = await client
        .from('treatment_policies')
        .select()
        .eq('is_active', true)
        .limit(2);
    if (rows.length != 1) return null;
    final policy = TreatmentPolicy.fromJson(rows.single);
    return policy.isTest && !allowTestPolicy ? null : policy;
  });
  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String policyVersion,
  }) => _safe(() async {
    final result = await client.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'policy_version': policyVersion,
        'authorization_accepted': true,
      },
    );
    if (result.session != null) {
      await client.auth.signOut();
      throw const AccountFailure();
    }
  });
  @override
  Future<void> confirmEmail({required String email, required String code}) =>
      _safe(() async {
        await client.auth.verifyOTP(
          email: email,
          token: code,
          type: OtpType.signup,
        );
        await client.auth.signOut();
      });
  @override
  Future<void> resendConfirmation(String email) => _safe(() async {
    await client.auth.resend(email: email, type: OtpType.signup);
  });
  @override
  Future<AccountSession?> signIn({
    required String email,
    required String password,
  }) => _safe(() async {
    final result = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final mapped = _map(result.session);
    if (mapped?.canAccessPrivate != true) {
      await client.auth.signOut();
      throw const AccountFailure();
    }
    final rows = await client
        .from('profiles')
        .select('id,name')
        .eq('id', mapped!.userId)
        .limit(1);
    return _map(
      result.session,
      name: rows.isEmpty ? null : rows.single['name'] as String?,
    );
  });
  @override
  Future<void> requestRecovery(String email) =>
      _safe(() => client.auth.resetPasswordForEmail(email));
  @override
  Future<void> verifyRecovery({required String email, required String code}) =>
      _safe(() async {
        await client.auth.verifyOTP(
          email: email,
          token: code,
          type: OtpType.recovery,
        );
      });
  @override
  Future<void> changePassword(String password) => _safe(() async {
    await client.auth.updateUser(UserAttributes(password: password));
  });
  @override
  Future<void> signOut() => _safe(() => client.auth.signOut());
}
