import subprocess,json,time,secrets,urllib.request,urllib.error,threading,http.server,base64,re
from pathlib import Path
out=Path('/tmp/priva-auth-validation');out.mkdir(exist_ok=True)
results=[]; names=['priva-val-auth','priva-val-mail','priva-val-pg','priva-val-template'];net='priva-validation-001'
def run(args,check=True):
 r=subprocess.run(args,capture_output=True,text=True)
 if check and r.returncode:raise RuntimeError('command failed: '+' '.join(args[:3])+' '+r.stderr[:200])
 return r.stdout.strip()
def req(path,data=None,token=None,base='http://127.0.0.1:18999',method=None):
 headers={'Content-Type':'application/json','X-Priva-Probe-IP':'198.51.100.10'}
 if token:headers['Authorization']='Bearer '+token
 q=urllib.request.Request(base+path,data=json.dumps(data).encode() if data is not None else None,headers=headers,method=method)
 try:
  with urllib.request.urlopen(q,timeout=10) as r:
   raw=r.read();return r.status,({} if method=='DELETE' else json.loads(raw) if raw.strip() else {})
 except urllib.error.HTTPError as e:
  try:d=json.load(e)
  except:d={}
  return e.code,d
def record(name,passed,**details):
 v={'check':name,'pass':bool(passed),**details};results.append(v);print(json.dumps(v),flush=True)
def sql(q):return run(['docker','exec',names[2],'psql','-U','postgres','-At','-c',q])
class H(http.server.BaseHTTPRequestHandler):
 def do_GET(self):
  body=b'<html><body>PRIVA-VALIDATION-CODE: {{ .Token }}</body></html>'
  self.send_response(200);self.send_header('Content-Type','text/html');self.end_headers();self.wfile.write(body)
 def log_message(self,*a):pass
server=http.server.ThreadingHTTPServer(('0.0.0.0',18990),H);threading.Thread(target=server.serve_forever,daemon=True).start()
password=secrets.token_urlsafe(24);jwt=secrets.token_urlsafe(40)
env=out/'auth.env'
env.write_text('\n'.join([
'GOTRUE_API_HOST=0.0.0.0','GOTRUE_API_PORT=9999','API_EXTERNAL_URL=http://localhost:18999',
'GOTRUE_SITE_URL=http://localhost:18999','GOTRUE_DB_DRIVER=postgres',
f'GOTRUE_DB_DATABASE_URL=postgres://postgres:{password}@priva-val-pg:5432/postgres?search_path=auth',
'GOTRUE_DB_NAMESPACE=auth',f'GOTRUE_JWT_SECRET={jwt}','GOTRUE_JWT_AUD=authenticated',
'GOTRUE_JWT_DEFAULT_GROUP_NAME=authenticated','GOTRUE_EXTERNAL_EMAIL_ENABLED=true',
'GOTRUE_MAILER_AUTOCONFIRM=false','GOTRUE_EXTERNAL_PHONE_ENABLED=false',
'GOTRUE_SMS_AUTOCONFIRM=false','GOTRUE_PASSWORD_MIN_LENGTH=12','GOTRUE_MAILER_OTP_EXP=600',
'GOTRUE_SMTP_HOST=priva-val-mail','GOTRUE_SMTP_PORT=1025','GOTRUE_SMTP_ADMIN_EMAIL=priva@example.test',
'GOTRUE_SMTP_MAX_FREQUENCY=60s','GOTRUE_RATE_LIMIT_EMAIL_SENT=1000','GOTRUE_RATE_LIMIT_HEADER=X-Priva-Probe-IP','GOTRUE_RATE_LIMIT_VERIFY=30',
'GOTRUE_MAILER_TEMPLATES_CONFIRMATION=http://127.0.0.1:8080/template',
'GOTRUE_MAILER_TEMPLATES_RECOVERY=http://127.0.0.1:8080/template',
'GOTRUE_LOG_LEVEL=info','NO_PROXY=priva-val-template,priva-val-mail,priva-val-pg,localhost,127.0.0.1','no_proxy=priva-val-template,priva-val-mail,priva-val-pg,localhost,127.0.0.1'])+'\n');env.chmod(0o600)
for existing in names:
 if subprocess.run(['docker','container','inspect',existing],capture_output=True).returncode==0:
  raise SystemExit('Refusing to modify pre-existing validation container: '+existing)
if subprocess.run(['docker','network','inspect',net],capture_output=True).returncode==0:
 raise SystemExit('Refusing to modify pre-existing validation network')
try:
 run(['docker','network','create',net])
 run(['docker','run','-d','--name',names[2],'--network',net,'-e','POSTGRES_PASSWORD='+password,'postgres@sha256:54e0dd8e8cddcdbb9156c2486eed5a43eccb7214d7c6828097d41ce049fb3984'])
 for i in range(40):
  if 'accepting connections' in run(['docker','exec',names[2],'pg_isready','-h','127.0.0.1','-U','postgres'],False):break
  time.sleep(.5)
 sql('create schema auth;')
 run(['docker','run','-d','--name',names[1],'--network',net,'-p','127.0.0.1:18025:8025','axllent/mailpit@sha256:986b14ff7b253e62883ea19fd3112806f116e5e2f221e03f12fb81c7312ff532'])
 run(['docker','run','-d','--name',names[3],'--network',net,'-p','127.0.0.1:18999:9999','python@sha256:5789aa194f757888f41fa3d48e14b6feaa1b57c0af0b56fcb1372d6474d3bff0','python','-c',"from http.server import HTTPServer,BaseHTTPRequestHandler\nclass H(BaseHTTPRequestHandler):\n def do_GET(self):\n  self.send_response(200);self.end_headers();self.wfile.write(b'<html>PRIVA-VALIDATION-CODE: {{ .Token }}</html>')\nHTTPServer(('0.0.0.0',8080),H).serve_forever()"])
 run(['docker','run','-d','--name',names[0],'--network','container:'+names[3],'--env-file',str(env),'supabase/gotrue@sha256:1736a63078f5922b198c4cbe50f80ab9a2d3b54fe8b7b6cfb2e9dc5dbbc12c6b'])
 for i in range(60):
  try:
   if req('/health')[0]==200:break
  except Exception:time.sleep(.5)
 else:raise RuntimeError('Auth health failed')
 record('local_auth_health',True)
 email='persona@example.test';pwd='PrivaTest12!'
 code,data=req('/signup',{'email':email,'password':'x'*11})
 record('min_12_rejects_11_characters',code>=400,http_status=code)
 code,data=req('/signup',{'email':email,'password':pwd,'data':{'name':'Sintetico'}})
 uid=data.get('id') or data.get('user',{}).get('id')
 record('signup_requires_confirmation',code==200 and not data.get('access_token'),http_status=code)
 def mailcode():
  for i in range(30):
   _,m=req('/api/v1/messages',base='http://127.0.0.1:18025')
   if m.get('messages'):
    for msg in m['messages']:
     _,full=req('/api/v1/message/'+msg['ID'],base='http://127.0.0.1:18025')
     mt=re.search(r'PRIVA-VALIDATION-CODE:\s*(\d+)',str(full.get('HTML',''))+' '+str(full.get('Text','')))
     if mt:return mt.group(1)
   time.sleep(.25)
  (out/'last-message-local.json').write_text(json.dumps(full));print('mail-api-meta',json.dumps({'keys':list(m.keys()),'total':m.get('total'),'messages_count':len(m.get('messages',[])), 'full_keys':list(full.keys()) if 'full' in locals() else [],'html_len':len(full.get('HTML','')) if 'full' in locals() else 0}),flush=True);raise RuntimeError('local code not found')
 code0=mailcode()
 code,data=req('/token?grant_type=password',{'email':email,'password':pwd})
 record('unconfirmed_password_login_denied',code>=400,http_status=code)
 code,data=req('/verify',{'email':email,'token':code0,'type':'signup'})
 record('signup_code_valid',code==200,http_status=code)
 code,data=req('/token?grant_type=password',{'email':email,'password':pwd})
 normal=data.get('access_token');refresh=data.get('refresh_token')
 def claims(t):return json.loads(base64.urlsafe_b64decode(t.split('.')[1]+'='*(-len(t.split('.')[1])%4)))
 normalclaims=claims(normal)
 record('password_login_amr',any(a.get('method')=='password' for a in normalclaims.get('amr',[])),methods=[a.get('method') for a in normalclaims.get('amr',[])])
 code,refreshed=req('/token?grant_type=refresh_token',{'refresh_token':refresh})
 if code==200:
  nc=claims(refreshed['access_token']);record('normal_refresh_preserves_password_amr',any(a.get('method')=='password' for a in nc.get('amr',[])))
 else:record('normal_refresh_preserves_password_amr',False,http_status=code)
 req('/api/v1/messages',base='http://127.0.0.1:18025',method='DELETE')
 code,data=req('/recover',{'email':email})
 record('request_recovery_local_mail',code==200,http_status=code)
 recoverycode=mailcode()
 code,data=req('/recover',{'email':email})
 record('resend_under_60s_denied',code>=400,http_status=code)
 bad='000000' if recoverycode!='000000' else '111111'
 statuses=[]
 for i in range(5):statuses.append(req('/verify',{'email':email,'token':bad,'type':'recovery'})[0])
 record('five_wrong_codes_denied',all(x>=400 for x in statuses),http_statuses=statuses)
 code,data=req('/verify',{'email':email,'token':recoverycode,'type':'recovery'})
 recovery=data.get('access_token')
 record('native_code_not_invalidated_by_five_failures',code==200,http_status=code,note='Observed native behavior; exact five-failure requirement withdrawn explicitly by user on 2026-10-27.')
 if recovery:
  rc=claims(recovery)
  rcode,refdata=req('/token?grant_type=refresh_token',{'refresh_token':data.get('refresh_token')})
  if rcode==200:
   rfc=claims(refdata['access_token']);record('recovery_refresh_remains_without_password_amr',all(a.get('method')!='password' for a in rfc.get('amr',[])))
  else:record('recovery_refresh_remains_without_password_amr',False,http_status=rcode)
  record('recovery_code_session_amr',all(a.get('method')!='password' for a in rc.get('amr',[])),methods=[a.get('method') for a in rc.get('amr',[])])
  code,data=req('/verify',{'email':email,'token':recoverycode,'type':'recovery'})
  record('recovery_code_single_use',code>=400,http_status=code)
  code,data=req('/user',{'password':'PrivaUpdatedSynthetic2026!'},token=recovery,method='PUT')
  record('recovery_can_change_password',code==200,http_status=code)
 # Exercise a true PostgreSQL RLS policy with token claims injected just as a JWT verifier would do.
 # This proves SQL predicate, NOT production JWT verification or PostgREST deployment.
 sql("create role priva_test_client nologin; create table public.priva_validation_private(user_id uuid, value text); alter table public.priva_validation_private enable row level security; grant select on public.priva_validation_private to priva_test_client; create policy password_session_only on public.priva_validation_private for select to priva_test_client using (user_id=(current_setting('request.jwt.claims',true)::jsonb->>'sub')::uuid and exists(select 1 from jsonb_array_elements(coalesce(current_setting('request.jwt.claims',true)::jsonb->'amr','[]'::jsonb)) a where a->>'method'='password')); insert into public.priva_validation_private values ('"+uid+"','synthetic');")
 def visible(c):
  v=json.dumps(c).replace("'","''")
  return sql("begin; set local role priva_test_client; set local request.jwt.claims='"+v+"'; select count(*) from public.priva_validation_private; rollback;").splitlines()[-2]
 record('rls_password_session_reads_own_row',visible(normalclaims)=='1')
 other=dict(normalclaims);other['sub']='00000000-0000-0000-0000-000000000001'
 record('rls_other_identity_denied',visible(other)=='0')
 if recovery:record('rls_otp_recovery_session_denied',visible(rc)=='0')
 code,data=req('/token?grant_type=refresh_token',{'refresh_token':refresh})
 if data.get('access_token'):
  cl=claims(data['access_token']);record('refresh_preserves_password_amr',any(a.get('method')=='password' for a in cl.get('amr',[])))
 # Age server-side sent_at to test 600-second expiry without waiting ten minutes.
 sql("update auth.users set recovery_sent_at=now()-interval '61 seconds' where id='"+uid+"';")
 req('/api/v1/messages',base='http://127.0.0.1:18025',method='DELETE')
 rcode,_=req('/recover',{'email':email});record('resend_after_60s_allowed',rcode==200,http_status=rcode,method='Test database timestamp aged 61 seconds.');expired=mailcode()
 sql("update auth.users set recovery_sent_at=now()-interval '601 seconds' where id='"+uid+"';")
 code,data=req('/verify',{'email':email,'token':expired,'type':'recovery'})
 record('server_600s_expiry_rejects_aged_code',code>=400,http_status=code,method='Test database timestamp advanced; no wall-clock ten-minute wait.')
 statuses=[]
 for i in range(80):
  vstatus,_=req('/verify',{'email':email,'token':bad,'type':'recovery'});statuses.append(vstatus)
  if vstatus==429:break
 record('native_verify_rate_limit_enforced',429 in statuses,requests_in_probe=len(statuses),last_http_status=statuses[-1])
except Exception as e:
 record('harness_error',False,error=str(e)[:250])
 # Keep full logs out of user output; local synthetic environment only.
 logresult=subprocess.run(['docker','logs',names[0]],capture_output=True,text=True);(out/'auth-local.log').write_text(logresult.stdout+logresult.stderr)
finally:
 (out/'results.json').write_text(json.dumps(results,indent=2)+'\n')
 for name in names:run(['docker','rm','-f',name],False)
 run(['docker','network','rm',net],False)
 server.shutdown();env.unlink(missing_ok=True)
 print('Sanitized results:',str(out/'results.json'),flush=True)

raise SystemExit(1 if any(not x["pass"] for x in results) else 0)
