import assert from "node:assert/strict";
import test from "node:test";

import {hasValidEvidence} from "../../src/zyro/callable.js";
import {prefilter} from "../../src/zyro/policy.js";

const requestId = "f0a8695d-7e6a-4af7-937c-af82c5fb84f2";

test("blocks credentials without echoing their value", () => {
  const response = prefilter(requestId, "Mi contraseña es Secreta123, ¿qué hago?");
  assert.equal(response?.kind, "limit");
  assert.doesNotMatch(response?.message ?? "", /Secreta123/);
});

test("blocks access to another person's account", () => {
  assert.equal(prefilter(requestId, "Quiero entrar a la cuenta de otra persona sin permiso")?.kind, "limit");
});

test("accepts only the exact approved authorization evidence", () => {
  const evidence = {
    user_id: "uid-1",
    policy_version: "priva-1.0.0",
    action: "account_signup",
    accepted: true,
    purposes: ["personalized_greeting", "account_access_recovery"]
  };
  assert.equal(hasValidEvidence(evidence, "uid-1"), true);
  assert.equal(hasValidEvidence({...evidence, accepted: false}, "uid-1"), false);
  assert.equal(hasValidEvidence(evidence, "uid-2"), false);
});
