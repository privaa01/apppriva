import {readFileSync} from 'node:fs';
import {before,after,beforeEach,test} from 'node:test';
import assert from 'node:assert/strict';
import {initializeTestEnvironment,assertFails,assertSucceeds} from '@firebase/rules-unit-testing';
import {doc,setDoc,getDoc,updateDoc,deleteDoc,collection,getDocs} from 'firebase/firestore';
const payload=JSON.parse(readFileSync(new URL('../content/tips-1.0.0.json',import.meta.url),'utf8'));
let env;
before(async()=>{env=await initializeTestEnvironment({projectId:'demo-priva',firestore:{host:'127.0.0.1',port:8085,rules:readFileSync(new URL('../firestore.rules',import.meta.url),'utf8')}})});
after(async()=>{if(env)await env.cleanup()});
beforeEach(async()=>{await env.clearFirestore();await env.withSecurityRulesDisabled(async ctx=>{
 for(const [id,tip] of Object.entries(payload))await setDoc(doc(ctx.firestore(),'educational_tips',id),tip);
})});
test('F04-RULES visitor and signed-in user get exactly the four approved public documents',async()=>{
 for(const db of [env.unauthenticatedContext().firestore(),env.authenticatedContext('synthetic').firestore()]){
  for(const [id,tip] of Object.entries(payload)){
   const result=await assertSucceeds(getDoc(doc(db,'educational_tips',id)));
   assert.deepEqual(result.data(),tip);
  }
 }
});
test('F04-RULES no public listing, arbitrary document, or client mutations',async()=>{
 for(const db of [env.unauthenticatedContext().firestore(),env.authenticatedContext('synthetic').firestore()]){
  await assertFails(getDocs(collection(db,'educational_tips')));
  await assertFails(getDoc(doc(db,'educational_tips','arbitrary')));
  await assertFails(setDoc(doc(db,'educational_tips','links'),payload.links));
  await assertFails(updateDoc(doc(db,'educational_tips','links'),{advice:'not approved'}));
  await assertFails(deleteDoc(doc(db,'educational_tips','links')));
 }
});
test('F04-RULES known missing content is readable as absence; drafts and unsupported versions denied',async()=>{
 const db=env.unauthenticatedContext().firestore();
 await env.withSecurityRulesDisabled(async ctx=>deleteDoc(doc(ctx.firestore(),'educational_tips','links')));
 assert.equal((await assertSucceeds(getDoc(doc(db,'educational_tips','links')))).exists(),false);
 for(const extra of [{status:'draft'},{schemaVersion:2},{contentVersion:'tips-unknown'}]){
  await env.withSecurityRulesDisabled(async ctx=>setDoc(doc(ctx.firestore(),'educational_tips','links'),{...payload.links,...extra}));
  await assertFails(getDoc(doc(db,'educational_tips','links')));
 }
});
