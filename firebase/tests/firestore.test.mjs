import {readFileSync} from 'node:fs';
import {before, after, beforeEach, test} from 'node:test';
import {initializeTestEnvironment, assertFails, assertSucceeds} from '@firebase/rules-unit-testing';
import {doc, setDoc, getDoc, updateDoc, deleteDoc, collection, getDocs, writeBatch, serverTimestamp, Timestamp} from 'firebase/firestore';
let env;
before(async () => {
  env = await initializeTestEnvironment({projectId: 'demo-priva', firestore: {
    host: '127.0.0.1', port: 8085, rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8')
  }});
});
after(async () => { if(env) await env.cleanup(); });
beforeEach(async () => { await env.clearFirestore(); });
const dbFor = (uid, verified = false) => env.authenticatedContext(uid, {
  email_verified: verified, firebase: {sign_in_provider: 'password'}
}).firestore();
const evidence = (uid, extra = {}) => ({user_id: uid, policy_version: 'priva-1.0.0',
  purposes: ['personalized_greeting','account_access_recovery'], action: 'account_signup',
  accepted: true, authorized_at: serverTimestamp(), ...extra});
async function signup(db, uid, extra = {}) {
  const batch = writeBatch(db);
  batch.set(doc(db,'profiles',uid), {name:'Prueba'});
  batch.set(doc(db,'authorization_evidence',uid), evidence(uid,extra));
  return batch.commit();
}
test('atomic own signup allowed; no profile read until verified', async () => {
  const db = dbFor('alice');
  await assertSucceeds(signup(db,'alice'));
  await assertSucceeds(getDoc(doc(db,'authorization_evidence','alice')));
  await assertFails(getDoc(doc(db,'profiles','alice')));
  await assertSucceeds(getDoc(doc(dbFor('alice',true),'profiles','alice')));
});
test('missing consent, wrong policy, extra personal fields, client date denied atomically', async () => {
  for(const extra of [{accepted:false},{policy_version:'fake'},{phone:'not-allowed'},
    {authorized_at:Timestamp.fromMillis(0)},{purposes:['advertising']},{user_id:'other'}]) {
    await assertFails(signup(dbFor('alice'),'alice',extra));
  }
  await assertSucceeds(signup(dbFor('alice'),'alice'));
});
test('profile alone and evidence alone denied', async () => {
  const db=dbFor('alice');
  await assertFails(setDoc(doc(db,'profiles','alice'),{name:'Prueba'}));
  await assertFails(setDoc(doc(db,'authorization_evidence','alice'),evidence('alice')));
});
test('consent immutable, no client delete or overwrite', async () => {
  const db=dbFor('alice');
  await signup(db,'alice');
  await assertFails(updateDoc(doc(db,'authorization_evidence','alice'),{accepted:false}));
  await assertFails(deleteDoc(doc(db,'authorization_evidence','alice')));
  await assertFails(signup(db,'alice'));
});
test('visitor and other user cannot read or write account data', async () => {
  await signup(dbFor('alice'),'alice');
  for(const db of [env.unauthenticatedContext().firestore(),dbFor('bob',true)]) {
    await assertFails(getDoc(doc(db,'authorization_evidence','alice')));
    await assertFails(getDoc(doc(db,'profiles','alice')));
    await assertFails(signup(db,'alice'));
  }
});
test('collection listing and questionnaire persistence denied', async () => {
  const db=dbFor('alice',true);
  await signup(db,'alice');
  await assertFails(getDocs(collection(db,'authorization_evidence')));
  await assertFails(getDocs(collection(db,'profiles')));
  await assertFails(setDoc(doc(db,'questionnaire','alice'),{answers:['synthetic']}));
});
test('non-password identity cannot write consent', async () => {
  const db=env.authenticatedContext('alice',{email_verified:true,
    firebase:{sign_in_provider:'anonymous'}}).firestore();
  await assertFails(signup(db,'alice'));
});

test('verified password owner can read missing evidence without a permission error', async () => {
  const db = dbFor('missing-evidence-owner', true);
  const snapshot = await assertSucceeds(getDoc(doc(db, 'authorization_evidence', 'missing-evidence-owner')));
  if (snapshot.exists()) throw new Error('Synthetic missing record unexpectedly exists');
  await assertFails(getDoc(doc(dbFor('other-owner', true), 'authorization_evidence', 'missing-evidence-owner')));
  await assertFails(getDoc(doc(env.unauthenticatedContext().firestore(), 'authorization_evidence', 'missing-evidence-owner')));
});

const demoId='11111111-1111-4111-8111-111111111111';
const demoPayload=()=>({mode:'demo',revision:'demo-contact-v1',nameOrAlias:'Visitante de prueba',email:'prueba@example.test',message:'Mensaje ficticio para probar el formulario.',consent:true,createdAt:serverTimestamp()});
test('existing demo contact accepts only whitelisted fictitious fields and stays unreadable', async()=>{
  const db=env.unauthenticatedContext().firestore();
  await assertSucceeds(setDoc(doc(db,'demo_contact',demoId),demoPayload()));
  await assertFails(getDoc(doc(db,'demo_contact',demoId)));
  await assertFails(updateDoc(doc(db,'demo_contact',demoId),{consent:false}));
  await assertFails(deleteDoc(doc(db,'demo_contact',demoId)));
  await assertFails(setDoc(doc(db,'demo_contact','22222222-2222-4222-8222-222222222222'),{...demoPayload(),email:'not-approved@example.test'}));
  await assertFails(setDoc(doc(db,'demo_contact','invalid-id'),demoPayload()));
});
test('existing suppression gate remains effective and suppression records remain private', async()=>{
  await env.withSecurityRulesDisabled(async context=>{
    await setDoc(doc(context.firestore(),'privacy_suppressions',demoId),{});
  });
  const db=env.unauthenticatedContext().firestore();
  await assertFails(setDoc(doc(db,'demo_contact',demoId),demoPayload()));
  await assertFails(getDoc(doc(db,'privacy_suppressions',demoId)));
  await assertFails(getDoc(doc(dbFor('alice',true),'privacy_suppressions',demoId)));
});
