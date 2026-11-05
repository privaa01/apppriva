import {readFileSync} from 'node:fs';
import {test} from 'node:test';
import assert from 'node:assert/strict';
import {validatePayload,main} from '../tool/publish_tips.mjs';
import {mkdtemp,readFile,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
const payload=()=>JSON.parse(readFileSync(new URL('../content/tips-1.0.0.json',import.meta.url),'utf8'));
test('F04-EDITORIAL publication preflight accepts only four approved versioned documents',()=>{
 assert.equal(Object.keys(validatePayload(payload())).length,4);
 for(const mutate of [p=>delete p.links,p=>p.other={},p=>p.links.status='draft',
  p=>p.links.contentVersion='changed',p=>p.profiles.recommendations=[],
  p=>p.passwords.categoryId='links',p=>p.sharing.editorialReview.sourceIds=[],
  p=>p.links.email='synthetic@example.test',p=>p.links.example.address='real-domain.com',
  p=>p.profiles.example.avatar='external-url',p=>p.links.clarification='',
  p=>p.links.editorialReview.sourceIds=['unverified']]){
  const p=payload();mutate(p);assert.throws(()=>validatePayload(p));
 }
});

test('F04-EDITORIAL default validation makes no HTTP requests and check never writes',async()=>{
 const requests=[];
 const client={request:async call=>{requests.push(call);throw {response:{status:404}}}};
 await main([],{client,payload:payload()});assert.equal(requests.length,0);
 await main(['--check'],{client,payload:payload()});
 assert.equal(requests.length,4);assert.ok(requests.every(x=>x.method==='GET'));
});
test('F04-EDITORIAL apply backs up before a single atomic commit for exactly four missing documents',async()=>{
 const folder=await mkdtemp(join(tmpdir(),'priva-tips-publish-test-'));const requests=[];
 try{
  const client={request:async call=>{
   requests.push(call);
   if(call.method==='GET')throw {response:{status:404}};
   const saved=JSON.parse(await readFile(join(folder,'educational-tips-before.json'),'utf8'));
   assert.equal(saved.project,'priva-785cb');assert.equal(Object.keys(saved.documents).length,4);
   return {data:{}};
  }};
  await main(['--apply','--backup-dir',folder],{client,payload:payload()});
  const commits=requests.filter(x=>x.method==='POST');assert.equal(commits.length,1);
  assert.equal(commits[0].url,'https://firestore.googleapis.com/v1/projects/priva-785cb/databases/(default)/documents:commit');
  assert.equal(commits[0].data.writes.length,4);
  for(const write of commits[0].data.writes){
   assert.match(write.update.name,/^projects\/priva-785cb\/databases\/\(default\)\/documents\/educational_tips\/(passwords|sharing|links|profiles)$/);
   assert.deepEqual(write.currentDocument,{exists:false});
  }
 }finally{await rm(folder,{recursive:true,force:true})}
});
test('F04-EDITORIAL conflicting existing content fails before writes or backup',async()=>{
 const requests=[];const client={request:async call=>{requests.push(call);return {data:{fields:{contentVersion:{stringValue:'different'}}}}}};
 await assert.rejects(main(['--apply','--backup-dir',join(tmpdir(),'priva-never-written')],{client,payload:payload()}),/Conflicting/);
 assert.ok(requests.every(x=>x.method==='GET'));
});
