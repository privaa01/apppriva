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
