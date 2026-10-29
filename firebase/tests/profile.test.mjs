import {readFileSync} from 'node:fs';
import {before, after, beforeEach, test} from 'node:test';
import assert from 'node:assert/strict';
import {initializeTestEnvironment, assertFails, assertSucceeds} from '@firebase/rules-unit-testing';
import {doc, getDoc, updateDoc, deleteDoc, writeBatch, serverTimestamp} from 'firebase/firestore';
let env;
before(async () => { env = await initializeTestEnvironment({projectId:'demo-priva',firestore:{
  host:'127.0.0.1',port:8085,rules:readFileSync(new URL('../firestore.rules',import.meta.url),'utf8')
}}); });
after(async () => { if(env) await env.cleanup(); });
beforeEach(async () => { await env.clearFirestore(); });
const dbFor=(uid,verified=true,provider='password')=>env.authenticatedContext(uid,{
  email_verified:verified,firebase:{sign_in_provider:provider}
}).firestore();
async function signup() {
  const db=dbFor('alice'); const batch=writeBatch(db);
  batch.set(doc(db,'profiles','alice'),{name:'Original'});
  batch.set(doc(db,'authorization_evidence','alice'),{user_id:'alice',policy_version:'priva-1.0.0',
    purposes:['personalized_greeting','account_access_recovery'],action:'account_signup',
    accepted:true,authorized_at:serverTimestamp()});
  await batch.commit(); return db;
}
test('verified owner updates name without changing consent',async()=>{
  const db=await signup();
  const before=(await getDoc(doc(db,'authorization_evidence','alice'))).data();
  await assertSucceeds(updateDoc(doc(db,'profiles','alice'),{name:'María José'}));
  const after=(await getDoc(doc(db,'authorization_evidence','alice'))).data();
  assert.deepEqual(after,before);
  assert.equal((await getDoc(doc(db,'profiles','alice'))).data().name,'María José');
});
test('visitors, other users, unverified and non-password identities cannot update',async()=>{
  await signup();
  for(const db of [env.unauthenticatedContext().firestore(),dbFor('bob'),
    dbFor('alice',false),dbFor('alice',true,'anonymous')]) {
    await assertFails(updateDoc(doc(db,'profiles','alice'),{name:'Other'}));
  }
});
test('empty and whitespace-only names rejected including separators',async()=>{
  const db=await signup();
  for(const name of ['',' ','\t\n','\u00a0','\ufeff']) {
    await assertFails(updateDoc(doc(db,'profiles','alice'),{name}));
  }
});
test('email, UID, phone and added fields cannot be written',async()=>{
  const db=await signup();
  for(const data of [{email:'synthetic@example.test'},{uid:'bob'},{phone:'synthetic'},
    {name:'New',history:[]},{name:123}]) {
    await assertFails(updateDoc(doc(db,'profiles','alice'),data));
  }
});
test('profile and consent cannot be deleted or consent modified',async()=>{
  const db=await signup();
  await assertFails(deleteDoc(doc(db,'profiles','alice')));
  await assertFails(deleteDoc(doc(db,'authorization_evidence','alice')));
  await assertFails(updateDoc(doc(db,'authorization_evidence','alice'),{accepted:false}));
});
test('missing consent denies update even for verified owner',async()=>{
  await signup();
  await env.withSecurityRulesDisabled(async context=>{
    await deleteDoc(doc(context.firestore(),'authorization_evidence','alice'));
  });
  await assertFails(updateDoc(doc(dbFor('alice'),'profiles','alice'),{name:'New'}));
});
