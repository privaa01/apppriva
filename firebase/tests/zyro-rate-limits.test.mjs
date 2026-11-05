import {readFileSync} from 'node:fs';
import {before, after, beforeEach, test} from 'node:test';
import {initializeTestEnvironment, assertFails} from '@firebase/rules-unit-testing';
import {collection, deleteDoc, doc, getDoc, getDocs, setDoc, updateDoc} from 'firebase/firestore';

let env;
before(async () => {
  env = await initializeTestEnvironment({projectId: 'demo-priva', firestore: {
    host: '127.0.0.1', port: 8085,
    rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8')
  }});
});
after(async () => { if (env) await env.cleanup(); });
beforeEach(async () => { await env.clearFirestore(); });

test('clients cannot read, list, create, update or delete Zyro rate limits', async () => {
  const databases = [
    env.unauthenticatedContext().firestore(),
    env.authenticatedContext('alice', {email_verified: true, firebase: {sign_in_provider: 'password'}}).firestore()
  ];
  for (const database of databases) {
    const reference = doc(database, 'zyro_rate_limits', 'alice');
    await assertFails(getDoc(reference));
    await assertFails(getDocs(collection(database, 'zyro_rate_limits')));
    await assertFails(setDoc(reference, {requestCount: 1}));
    await assertFails(updateDoc(reference, {requestCount: 2}));
    await assertFails(deleteDoc(reference));
  }
});
