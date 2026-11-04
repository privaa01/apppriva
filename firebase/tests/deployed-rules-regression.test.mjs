import {readFileSync} from 'node:fs';
import {test} from 'node:test';
import {initializeTestEnvironment, assertFails} from '@firebase/rules-unit-testing';
import {doc, getDoc} from 'firebase/firestore';

test('reported deployed demo-only rules reproduce AC-05 for verified password owner', async () => {
  const env = await initializeTestEnvironment({projectId:'demo-priva',firestore:{
    host:'127.0.0.1',port:8085,rules:readFileSync(new URL('fixtures/deployed-before-priva-20261104.rules',import.meta.url),'utf8')
  }});
  try {
    const db=env.authenticatedContext('synthetic-owner',{
      email_verified:true,firebase:{sign_in_provider:'password'}
    }).firestore();
    await assertFails(getDoc(doc(db,'authorization_evidence','synthetic-owner')));
  } finally { await env.cleanup(); }
});
