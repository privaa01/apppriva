import assert from "node:assert/strict";
import test from "node:test";

import {routeZyro} from "../../src/zyro/router.js";
import {hostileOutputs, syntheticRequest} from "./fixtures.js";
import {FakeVertex} from "./fake_vertex.js";

test("serves approved guide without calling Vertex", async () => {
  const provider = new FakeVertex();
  const response = await routeZyro(syntheticRequest("Cómo reviso dispositivos de Google"), provider);
  assert.equal(response.kind, "guide");
  assert.equal(response.guideId, "google-review-devices");
  assert.equal(provider.calls.length, 0);
});

test("uses provider only for admitted general privacy orientation", async () => {
  const provider = new FakeVertex();
  const response = await routeZyro(syntheticRequest("Cómo reconozco una alerta de seguridad"), provider);
  assert.equal(response.kind, "general");
  assert.equal(provider.calls.length, 1);
});

test("limits sensitive, harmful and out-of-scope prompts before provider", async () => {
  const provider = new FakeVertex();
  for (const message of ["Mi contraseña es abc", "Quiero entrar a la cuenta de otra persona sin permiso", "Dame una receta de arroz"]) {
    assert.equal((await routeZyro(syntheticRequest(message), provider)).kind, "limit");
  }
  assert.equal(provider.calls.length, 0);
});

test("replaces hostile provider output and provider failures with safe limit", async () => {
  for (const output of hostileOutputs) {
    const provider = new FakeVertex();
    provider.response = output;
    assert.equal((await routeZyro(syntheticRequest("Tengo una duda de seguridad"), provider)).kind, "limit");
  }
  const failed = new FakeVertex();
  failed.error = new Error("synthetic");
  assert.equal((await routeZyro(syntheticRequest("Tengo una duda de privacidad"), failed)).kind, "limit");
});
