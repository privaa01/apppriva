#!/usr/bin/env python3
"""Disposable Auth/PostgREST contract tests. No external mail or real credentials.

All secrets and OTPs remain in memory or a mode-0600 temporary directory. Persisted
results contain check names/status only. No hosted project is created or modified.
"""
from __future__ import annotations

import argparse
import json
import secrets
import subprocess
import tempfile
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
IMAGES = {
    'postgres': 'postgres@sha256:54e0dd8e8cddcdbb9156c2486eed5a43eccb7214d7c6828097d41ce049fb3984',
    'auth': 'supabase/gotrue@sha256:1736a63078f5922b198c4cbe50f80ab9a2d3b54fe8b7b6cfb2e9dc5dbbc12c6b',
    'mail': 'axllent/mailpit@sha256:986b14ff7b253e62883ea19fd3112806f116e5e2f221e03f12fb81c7312ff532',
    'template': 'python@sha256:5789aa194f757888f41fa3d48e14b6feaa1b57c0af0b56fcb1372d6474d3bff0',
    'rest': 'postgrest/postgrest@sha256:d09618df2b7b9547c80a076c2f4045b326be8d7ac06060d263caefec1334e3c9',
}


def docker(*args: str, input_text: str | None = None, check: bool = True) -> str:
    result = subprocess.run(['docker', *args], input=input_text, capture_output=True, text=True)
    if check and result.returncode:
        # Never echo full command/env or service logs, which may carry tokens.
        raise RuntimeError('Docker operation failed: ' + args[0] + ' / ' + (result.stderr.splitlines()[0] if result.stderr else 'no diagnostic'))
    return result.stdout.strip()


def request(base: str, path: str, data: dict | None = None,
            token: str | None = None, method: str | None = None) -> tuple[int, object]:
    headers = {'Content-Type': 'application/json', 'X-Priva-Test-IP': '198.51.100.44'}
    if token:
        headers['Authorization'] = 'Bearer ' + token
    query = urllib.request.Request(base + path, method=method,
                                   headers=headers,
                                   data=None if data is None else json.dumps(data).encode())
    try:
        with urllib.request.urlopen(query, timeout=15) as response:
            raw = response.read()
            try:
                body = json.loads(raw) if raw.strip() else None
            except (ValueError, UnicodeDecodeError):
                body = None
            return response.status, body
    except urllib.error.HTTPError as error:
        try:
            body = json.load(error)
        except (ValueError, UnicodeDecodeError):
            body = None
        return error.code, body


class Fixture:
    def __init__(self) -> None:
        self.prefix = 'priva-account-' + secrets.token_hex(5)
        self.network = self.prefix + '-network'
        self.names: list[str] = []
        self.password = secrets.token_urlsafe(32)
        self.jwt = secrets.token_urlsafe(48)
        self.temp = tempfile.TemporaryDirectory(prefix='priva-account-')
        self.results: list[dict] = []
        self.bases: dict[str, str] = {}

    def start(self, key: str, env: dict[str, str] | None = None,
              publish: int | None = None, namespace: str | None = None,
              command: list[str] | None = None) -> str:
        name = self.prefix + '-' + key
        args = ['run', '-d', '--name', name, '--network', namespace or self.network]
        if publish is not None:
            args += ['-p', '127.0.0.1::' + str(publish)]
        if env:
            envfile = Path(self.temp.name) / (key + '.env')
            envfile.write_text('\n'.join(k + '=' + v for k, v in env.items()) + '\n')
            envfile.chmod(0o600)
            args += ['--env-file', str(envfile)]
        args += [IMAGES[key], *(command or [])]
        docker(*args)
        self.names.append(name)
        if publish is not None:
            mapping = docker('port', name, str(publish) + '/tcp')
            self.bases[key] = 'http://127.0.0.1:' + mapping.rsplit(':', 1)[-1]
        return name

    def sql(self, sql: str, check: bool = True) -> str:
        return docker('exec', '-i', self.prefix + '-postgres', 'psql', '-U', 'postgres',
                      '-At', '-v', 'ON_ERROR_STOP=1', input_text=sql, check=check)

    def record(self, name: str, success: bool, **safe_details: object) -> None:
        entry = {'check': name, 'passed': bool(success), **safe_details}
        self.results.append(entry)
        print(json.dumps(entry), flush=True)
        if not success:
            raise AssertionError(name)

    def wait_http(self, base: str, path: str, desired: tuple[int, ...] = (200,)) -> None:
        for _ in range(100):
            try:
                status, _ = request(base, path)
                if status in desired:
                    return
            except (OSError, ValueError):
                pass
            time.sleep(.2)
        raise RuntimeError('Local HTTP service did not become ready')

    def launch(self) -> None:
        docker('network', 'create', self.network)
        self.start('postgres', {'POSTGRES_PASSWORD': self.password})
        for _ in range(100):
            ready = docker('exec', self.prefix + '-postgres', 'pg_isready', '-h',
                           '127.0.0.1', '-U', 'postgres', check=False)
            if 'accepting connections' in ready:
                break
            time.sleep(.2)
        self.sql('create schema auth; create role anon nologin; create role authenticated nologin;')
        self.start('mail', publish=8025)
        template = self.start('template', publish=9999, command=[
            'python', '-c',
            "from http.server import HTTPServer,BaseHTTPRequestHandler\n"
            "class H(BaseHTTPRequestHandler):\n"
            " def do_GET(self):\n"
            "  self.send_response(200);self.end_headers();self.wfile.write(b'<html>PRIVA-CODE: {{ .Token }}</html>')\n"
            " def log_message(self,*args): pass\n"
            "HTTPServer(('0.0.0.0',8080),H).serve_forever()",
        ])
        authenv = {
            'GOTRUE_API_HOST': '0.0.0.0', 'GOTRUE_API_PORT': '9999',
            'API_EXTERNAL_URL': 'http://localhost:9999', 'GOTRUE_SITE_URL': 'http://localhost:9999',
            'GOTRUE_DB_DRIVER': 'postgres',
            'GOTRUE_DB_DATABASE_URL': f'postgres://postgres:{self.password}@{self.prefix}-postgres:5432/postgres?search_path=auth',
            'GOTRUE_DB_NAMESPACE': 'auth', 'GOTRUE_JWT_SECRET': self.jwt,
            'GOTRUE_JWT_AUD': 'authenticated', 'GOTRUE_JWT_DEFAULT_GROUP_NAME': 'authenticated',
            'GOTRUE_EXTERNAL_EMAIL_ENABLED': 'true', 'GOTRUE_EXTERNAL_PHONE_ENABLED': 'false',
            'GOTRUE_MAILER_AUTOCONFIRM': 'false', 'GOTRUE_SMS_AUTOCONFIRM': 'false',
            'GOTRUE_PASSWORD_MIN_LENGTH': '12', 'GOTRUE_MAILER_OTP_EXP': '600',
            'GOTRUE_SMTP_HOST': self.prefix + '-mail', 'GOTRUE_SMTP_PORT': '1025',
            'GOTRUE_SMTP_ADMIN_EMAIL': 'priva@example.test', 'GOTRUE_SMTP_MAX_FREQUENCY': '60s',
            'GOTRUE_RATE_LIMIT_EMAIL_SENT': '1000', 'GOTRUE_RATE_LIMIT_HEADER': 'X-Priva-Test-IP',
            'GOTRUE_RATE_LIMIT_VERIFY': '30',
            'GOTRUE_MAILER_TEMPLATES_CONFIRMATION': 'http://127.0.0.1:8080/template',
            'GOTRUE_MAILER_TEMPLATES_RECOVERY': 'http://127.0.0.1:8080/template',
            'GOTRUE_LOG_LEVEL': 'error', 'NO_PROXY': 'localhost,127.0.0.1',
        }
        self.start('auth', authenv, namespace='container:' + template)
        self.bases['auth'] = self.bases['template']
        self.wait_http(self.bases['auth'], '/health')
        # Supabase supplies these helper functions and roles in hosted Postgres.
        self.sql("""
            grant usage on schema public,auth to anon,authenticated;
            create or replace function auth.jwt() returns jsonb language sql stable as
            $$ select nullif(current_setting('request.jwt.claims',true),'')::jsonb $$;
            create or replace function auth.uid() returns uuid language sql stable as
            $$ select (auth.jwt()->>'sub')::uuid $$;
        """)
        for path in sorted((ROOT / 'supabase/migrations').glob('*.sql')):
            self.sql(path.read_text())
        self.record('sql_regression_suite', 'account_sql_regressions_passed' in self.sql(
            (ROOT / 'supabase/tests/account_access.test.sql').read_text()))
        self.sql((ROOT / 'supabase/tests/synthetic_policy.sql').read_text())
        self.sql("create role priva_rest_authenticator login noinherit password '" + self.password + "';"
                 " grant anon,authenticated to priva_rest_authenticator;")
        self.start('rest', {
            'PGRST_DB_URI': f'postgres://priva_rest_authenticator:{self.password}@{self.prefix}-postgres:5432/postgres',
            'PGRST_DB_SCHEMAS': 'public', 'PGRST_DB_ANON_ROLE': 'anon',
            'PGRST_JWT_SECRET': self.jwt, 'PGRST_JWT_AUD': 'authenticated',
            'PGRST_SERVER_HOST': '0.0.0.0', 'PGRST_SERVER_PORT': '3000',
            'PGRST_LOG_LEVEL': 'crit',
        }, publish=3000)
        self.wait_http(self.bases['rest'], '/treatment_policies?select=version')

    def code_for(self, email: str) -> str:
        import re
        for _ in range(60):
            status, listing = request(self.bases['mail'], '/api/v1/messages')
            if status == 200 and isinstance(listing, dict):
                for message in listing.get('messages', []):
                    _, body = request(self.bases['mail'], '/api/v1/message/' + message['ID'])
                    if isinstance(body, dict) and any(to.get('Address') == email for to in body.get('To', [])):
                        match = re.search(r'PRIVA-CODE:\s*(\d+)', body.get('HTML', '') + body.get('Text', ''))
                        if match:
                            return match.group(1)
            time.sleep(.2)
        raise AssertionError('Synthetic message did not arrive locally')

    def signup(self, email: str, **changes: object) -> tuple[int, dict]:
        metadata = {'name': 'Persona sintética', 'policy_version': 'test-2026-10-27',
                    'authorization_accepted': True, **changes}
        return request(self.bases['auth'], '/signup', {
            'email': email, 'password': 'PrivaSynthetic2026!', 'data': metadata,
        })  # type: ignore[return-value]

    def cleanup(self) -> None:
        for name in reversed(self.names):
            docker('rm', '-f', name, check=False)
        docker('network', 'rm', self.network, check=False)
        self.temp.cleanup()

    def test(self) -> None:
        auth, rest = self.bases['auth'], self.bases['rest']
        status, policies = request(rest, '/treatment_policies?select=version,is_test,purposes')
        self.record('active_policy_public', status == 200 and len(policies) == 1 and policies[0]['is_test'])
        status, rows = request(rest, '/profiles?select=id,name')
        self.record('visitor_private_denied', status == 200 and rows == [])
        status, _ = request(rest, '/treatment_policies', {'version': 'unauthorized'}, method='POST')
        self.record('visitor_policy_write_denied', status >= 400)

        for label, changes in [('missing_acceptance', {'authorization_accepted': False}),
                               ('string_acceptance', {'authorization_accepted': 'true'}),
                               ('unknown_policy', {'policy_version': 'not-published'})]:
            status, _ = self.signup(label + '@example.test', **changes)
            count = self.sql("select count(*) from auth.users where email='" + label + "@example.test';")
            self.record(label + '_rolls_back', status >= 400 and count == '0')

        self.sql("""create function public.fail_evidence_test() returns trigger language plpgsql as $$
             begin raise exception 'Synthetic evidence failure' using errcode='23514'; end $$;
             create trigger fail_evidence_test before insert on public.authorization_evidence
             for each row execute function public.fail_evidence_test();""")
        status, _ = self.signup('rollback@example.test')
        self.record('auth_api_evidence_failure_rolls_back', status >= 400 and
                    self.sql("select count(*) from auth.users where email='rollback@example.test';") == '0')
        self.sql('drop trigger fail_evidence_test on public.authorization_evidence; drop function public.fail_evidence_test();')

        email = 'first@example.test'
        status, account = self.signup(email)
        uid = account.get('id')
        self.record('signup_without_session', status == 200 and bool(uid) and not account.get('access_token'))
        self.record('auth_profile_evidence_atomic', self.sql(
            "select count(*) from public.profiles p join public.authorization_evidence e on p.id=e.user_id "
            "where p.id='" + uid + "';") == '1')
        evidence_time = self.sql("select authorized_at from public.authorization_evidence where user_id='" + uid + "';")
        status, _ = request(auth, '/token?grant_type=password', {'email': email, 'password': 'PrivaSynthetic2026!'})
        self.record('unverified_password_login_denied', status >= 400)
        code = self.code_for(email)
        status, confirmed = request(auth, '/verify', {'email': email, 'token': code, 'type': 'signup'})
        confirmation_token = confirmed.get('access_token')
        self.record('signup_confirmation_by_code', status == 200 and bool(confirmation_token))
        status, rows = request(rest, '/profiles?select=id', token=confirmation_token)
        self.record('confirmation_otp_cannot_read_private_http', status == 200 and rows == [])
        status, normal = request(auth, '/token?grant_type=password', {'email': email, 'password': 'PrivaSynthetic2026!'})
        token, refresh = normal.get('access_token'), normal.get('refresh_token')
        self.record('password_login_success', status == 200 and bool(token))
        status, rows = request(rest, '/profiles?select=id,name', token=token)
        self.record('own_password_profile_http', status == 200 and len(rows) == 1 and rows[0]['id'] == uid)
        status, rows = request(rest, '/authorization_evidence?select=user_id,policy_version,action', token=token)
        self.record('own_immutable_evidence_read_http', status == 200 and len(rows) == 1 and rows[0]['action'] == 'account_signup')
        status, _ = request(rest, '/authorization_evidence?user_id=eq.' + uid,
                            {'action': 'changed'}, token=token, method='PATCH')
        self.record('client_evidence_update_denied_http', status >= 400)
        status, _ = request(auth, '/user', {'data': {'policy_version': 'changed', 'name': 'Changed'}},
                            token=token, method='PUT')
        self.record('metadata_change_does_not_rewrite_evidence', status == 200 and
                    self.sql("select policy_version from public.authorization_evidence where user_id='" + uid + "';") == 'test-2026-10-27')
        status, _ = self.signup(email)
        self.record('duplicate_signup_no_duplicate_records', status == 200 and
                    self.sql("select count(*) from auth.users where email='first@example.test';") == '1' and
                    self.sql("select count(*) from public.authorization_evidence where user_id='" + uid + "';") == '1' and
                    self.sql("select authorized_at from public.authorization_evidence where user_id='" + uid + "';") == evidence_time)
        status, renewed = request(auth, '/token?grant_type=refresh_token', {'refresh_token': refresh})
        renewed_token = renewed.get('access_token')
        status2, rows = request(rest, '/profiles?select=id', token=renewed_token)
        self.record('password_refresh_preserves_private_access_http', status == 200 and status2 == 200 and len(rows) == 1)

        email2 = 'second@example.test'
        self.signup(email2)
        request(auth, '/verify', {'email': email2, 'token': self.code_for(email2), 'type': 'signup'})
        _, other = request(auth, '/token?grant_type=password', {'email': email2, 'password': 'PrivaSynthetic2026!'})
        other_token = other.get('access_token')
        status, rows = request(rest, '/profiles?id=eq.' + uid, token=other_token)
        self.record('other_identity_denied_http', status == 200 and rows == [])
        status, _ = request(rest, '/profiles?select=id', token=token.split('.')[0] + '.' + token.split('.')[1] + '.' + ('a' if token.split('.')[2][0] != 'a' else 'b') + token.split('.')[2][1:])
        self.record('tampered_jwt_denied_http', status == 401)

        request(self.bases['mail'], '/api/v1/messages', method='DELETE')
        status, _ = request(auth, '/recover', {'email': email})
        self.record('recovery_request_local_email', status == 200)
        recovery_code = self.code_for(email)
        status, _ = request(auth, '/recover', {'email': email})
        self.record('native_recovery_cooldown_60s', status == 429)
        status, _ = request(auth, '/verify', {'email': email, 'token': '000000' if recovery_code != '000000' else '111111', 'type': 'recovery'})
        self.record('wrong_recovery_code_denied', status >= 400)
        status, recovered = request(auth, '/verify', {'email': email, 'token': recovery_code, 'type': 'recovery'})
        recovery_token = recovered.get('access_token')
        self.record('recovery_code_valid', status == 200 and bool(recovery_token))
        status, rows = request(rest, '/profiles?select=id', token=recovery_token)
        self.record('recovery_otp_cannot_read_private_http', status == 200 and rows == [])
        status, rows = request(rest, '/authorization_evidence?select=id', token=recovery_token)
        self.record('recovery_otp_cannot_read_evidence_http', status == 200 and rows == [])
        _, recovery_refresh = request(auth, '/token?grant_type=refresh_token', {'refresh_token': recovered.get('refresh_token')})
        status, rows = request(rest, '/profiles?select=id', token=recovery_refresh.get('access_token'))
        self.record('recovery_refresh_stays_restricted_http', status == 200 and rows == [])
        status, _ = request(auth, '/user', {'password': 'UpdatedSynthetic2026!'}, token=recovery_token, method='PUT')
        self.record('recovery_changes_password', status == 200)
        status, _ = request(auth, '/verify', {'email': email, 'token': recovery_code, 'type': 'recovery'})
        self.record('recovery_code_single_use', status >= 400)
        status, _ = request(auth, '/token?grant_type=password', {'email': email, 'password': 'UpdatedSynthetic2026!'})
        self.record('normal_login_after_recovery', status == 200)
        # No tokens or codes in persisted output; this demonstrates native expiry using test DB time.
        self.sql("update auth.users set recovery_sent_at=now()-interval '61 seconds' where id='" + uid + "';")
        request(self.bases['mail'], '/api/v1/messages', method='DELETE')
        request(auth, '/recover', {'email': email})
        expired_code = self.code_for(email)
        self.sql("update auth.users set recovery_sent_at=now()-interval '601 seconds' where id='" + uid + "';")
        status, _ = request(auth, '/verify', {'email': email, 'token': expired_code, 'type': 'recovery'})
        self.record('recovery_expiry_600s', status >= 400)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path, default=ROOT / 'specs/001-cuenta-acceso/validation/backend-results.json')
    args = parser.parse_args()
    fixture = Fixture()
    try:
        fixture.launch()
        fixture.test()
    except Exception as error:
        fixture.results.append({'check': 'suite_completed', 'passed': False, 'error_type': type(error).__name__})
        print('Backend suite failed: ' + type(error).__name__ + ' / ' + (str(error) if isinstance(error,RuntimeError) else ''), flush=True)
    finally:
        fixture.cleanup()
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps({'scope': 'local_auth_postgres_postgrest_http',
                                          'images': IMAGES, 'checks': fixture.results}, indent=2) + '\n')
    return 0 if fixture.results and all(x['passed'] for x in fixture.results) else 1


if __name__ == '__main__':
    raise SystemExit(main())
