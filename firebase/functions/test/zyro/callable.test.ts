import assert from "node:assert/strict";
import test from "node:test";
import {CallableRequest, HttpsError} from "firebase-functions/v2/https";

import {handleZyroWithDependencies, ZyroCallableDependencies} from "../../src/zyro/callable.js";
import {syntheticRequest} from "./fixtures.js";
import {FakeVertex} from "./fake_vertex.js";

const evidence = {
  user_id: "uid-1",
  policy_version: "priva-1.0.0",
  action: "account_signup",
  accepted: true,
  purposes: ["personalized_greeting", "account_access_recovery"]
};

function request(overrides: Record<string, unknown> = {}): CallableRequest<unknown> {
  return {
    data: syntheticRequest("Cómo reviso dispositivos de Google"),
    auth: {
      uid: "uid-1",
      token: {email_verified: true, firebase: {sign_in_provider: "password"}}
    },
    app: {appId: "synthetic-app"},
    ...overrides
  } as unknown as CallableRequest<unknown>;
}

function dependencies(overrides: Partial<ZyroCallableDependencies> = {}): ZyroCallableDependencies {
  return {
    readEvidence: async () => evidence,
    consume: async () => undefined,
    provider: new FakeVertex(),
    ...overrides
  };
}

async function expectCode(promise: Promise<unknown>, code: string): Promise<void> {
  await assert.rejects(promise, (error: unknown) =>
    error instanceof HttpsError && error.code === code);
}

test("rejects missing auth, App Check, verified email and password provider", async () => {
  await expectCode(handleZyroWithDependencies(request({auth: undefined}), dependencies()), "unauthenticated");
  await expectCode(handleZyroWithDependencies(request({app: undefined}), dependencies()), "failed-precondition");
  await expectCode(handleZyroWithDependencies(request({auth: {...request().auth, token: {email_verified: false, firebase: {sign_in_provider: "password"}}}}), dependencies()), "unauthenticated");
  await expectCode(handleZyroWithDependencies(request({auth: {...request().auth, token: {email_verified: true, firebase: {sign_in_provider: "anonymous"}}}}), dependencies()), "unauthenticated");
});

test("rejects invalid schema and missing authorization", async () => {
  await expectCode(handleZyroWithDependencies(request({data: {schemaVersion: 1}}), dependencies()), "invalid-argument");
  await expectCode(handleZyroWithDependencies(request(), dependencies({readEvidence: async () => undefined})), "permission-denied");
});

test("consumes quota and returns the approved guide", async () => {
  const consumed: string[] = [];
  const response = await handleZyroWithDependencies(
    request(),
    dependencies({consume: async (uid) => { consumed.push(uid); }})
  );
  assert.deepEqual(consumed, ["uid-1"]);
  assert.equal(response.kind, "guide");
  assert.equal(response.guideId, "google-review-devices");
});
