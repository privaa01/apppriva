#!/usr/bin/env python3
"""Actual local services + app adapter/controller/widget integration. No hosted mutations."""
import base64,hashlib,hmac,importlib.util,json,os,subprocess,sys,tempfile,threading,time,urllib.request,urllib.error,re
from http.server import BaseHTTPRequestHandler,ThreadingHTTPServer
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('account_fixture',ROOT/'supabase/tests/account_access_http.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
fixture=module.Fixture()
lose_signup=False
delay_next=0
class Proxy(BaseHTTPRequestHandler):
 def log_message(self,*a):pass
 def send(self,status,body,ctype='application/json'):
  self.send_response(status);self.send_header('content-type',ctype);self.send_header('content-length',str(len(body)));self.end_headers();self.wfile.write(body)
 def do_GET(self):self.forward()
 def do_PUT(self):self.forward()
 def do_DELETE(self):self.forward()
 def do_POST(self):self.forward()
 def forward(self):
  global lose_signup,delay_next
  raw=self.rfile.read(int(self.headers.get('Content-Length',0)))
  if self.path.startswith('/__test/'):
   try:
    data=json.loads(raw);email=data['email']
    if not re.fullmatch(r'synthetic-\d+@example\.test',email):raise ValueError('synthetic only')
    action=self.path.rsplit('/',1)[1]
    if action=='code':result={'code':fixture.code_for(email)}
    elif action=='counts':
     text=fixture.sql("select json_build_object('accounts',(select count(*) from auth.users where email='"+email+"'),'profiles',(select count(*) from public.profiles p join auth.users u on p.id=u.id where u.email='"+email+"'),'evidence',(select count(*) from public.authorization_evidence e join auth.users u on e.user_id=u.id where u.email='"+email+"'));")
     result=json.loads(text)
    elif action=='expire-code':
     fixture.sql("update auth.users set recovery_sent_at=now()-interval '601 seconds' where email='"+email+"';");result={}
    elif action=='fail-evidence':
     fixture.sql("alter table public.authorization_evidence add constraint priva_fixture_failure check (action <> 'account_signup') not valid;");result={}
    elif action=='restore-evidence':
     fixture.sql('alter table public.authorization_evidence drop constraint if exists priva_fixture_failure;');result={}
    elif action=='lose-next-signup':lose_signup=True;result={}
    elif action=='delay-next-auth':delay_next=16;result={}
    elif action=='outage':delay_next=-1;result={}
    elif action=='restore-network':delay_next=0;result={}
    else:raise ValueError('unknown operation')
    self.send(200,json.dumps(result).encode())
   except Exception:self.send(500,b'{}')
   return
  prefix='/auth/v1' if self.path.startswith('/auth/v1/') else '/rest/v1'
  if not self.path.startswith(prefix+'/'):self.send(404,b'{}');return
  if prefix=='/auth/v1' and delay_next==-1:self.send(503,b'{}');return
  delay=delay_next if prefix=='/auth/v1' else 0
  if delay>0:delay_next=0
  url=fixture.bases['auth' if prefix=='/auth/v1' else 'rest']+self.path[len(prefix):]
  headers={k:v for k,v in self.headers.items() if k.lower() not in {'host','content-length','connection'}}
  headers['X-Priva-Test-IP']='198.51.100.44'
  q=urllib.request.Request(url,data=raw if raw else None,headers=headers,method=self.command)
  try:
   with urllib.request.urlopen(q,timeout=20) as r:status=r.status;body=r.read();ctype=r.headers.get('content-type','application/json')
  except urllib.error.HTTPError as e:status=e.code;body=e.read();ctype=e.headers.get('content-type','application/json')
  except Exception:self.send(502,b'{}');return
  if lose_signup and self.path.startswith('/auth/v1/signup'):
   lose_signup=False;self.send(503,b'{"msg":"Synthetic lost acknowledgement"}');return
  if delay>0:time.sleep(delay)
  self.send(status,body,ctype)

def token():
 def enc(data):return base64.urlsafe_b64encode(json.dumps(data,separators=(',',':')).encode()).decode().rstrip('=')
 payload=enc({'alg':'HS256','typ':'JWT'})+'.'+enc({'role':'anon','aud':'authenticated','exp':int(time.time())+3600})
 return payload+'.'+base64.urlsafe_b64encode(hmac.new(fixture.jwt.encode(),payload.encode(),hashlib.sha256).digest()).decode().rstrip('=')

def main():
 server=None
 try:
  fixture.launch();server=ThreadingHTTPServer(('127.0.0.1',0),Proxy);threading.Thread(target=server.serve_forever,daemon=True).start()
  with tempfile.TemporaryDirectory(prefix='priva-integration-') as folder:
   config=Path(folder)/'config.json';config.write_text(json.dumps({'PRIVA_INTEGRATION_URL':f'http://127.0.0.1:{server.server_port}','PRIVA_INTEGRATION_KEY':token(),'PRIVA_METRICS_PATH':str(Path(folder)/'metrics.json')}));config.chmod(0o600)
   command=['/workspace/.tools/flutter/bin/flutter','test','--no-pub','--concurrency=1','--reporter=expanded','tool/local_integration_test.dart','--dart-define-from-file='+str(config)]
   result=subprocess.run(command,cwd=ROOT/'mobile').returncode
   metrics=Path(folder)/'metrics.json'
   if metrics.exists():
    data=json.loads(metrics.read_text());assert len(data)==20 and all(set(x)=={'operation','profile','sample','feedback_us','response_us','passed'} for x in data)
    (ROOT/'specs/001-cuenta-acceso/validation/performance-local.json').write_text(json.dumps({'scope':'local_headless_registration_only','samples':data},indent=2)+'\n')
   return result
 finally:
  if server:server.shutdown()
  fixture.cleanup()
if __name__=='__main__':sys.exit(main())
