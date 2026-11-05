import assert from "node:assert/strict";
import test from "node:test";

import {GUIDE_CATALOGUE_ID, findVerifiedGuide, verifiedGuides} from "../../src/zyro/catalog.js";
import {routeApprovedGuide} from "../../src/zyro/guide_router.js";

test("loads only the twelve approved current guides", () => {
  assert.equal(GUIDE_CATALOGUE_ID, "zyro-guides-es-CO-1.1.0");
  assert.equal(verifiedGuides.length, 12);
  assert.deepEqual(new Set(verifiedGuides.map((guide) => guide.platform)), new Set(["instagram", "facebook", "google"]));
  assert.ok(verifiedGuides.every((guide) => guide.status === "vigente" && guide.steps.length <= 6));
});

test("matches an approved platform and intent without generating steps", () => {
  assert.equal(findVerifiedGuide("¿Cómo hago privada mi cuenta de Instagram?")?.id, "instagram-private-account");
  assert.equal(findVerifiedGuide("Quiero revisar los dispositivos de Google")?.id, "google-review-devices");
  assert.equal(findVerifiedGuide("¿Qué aplicaciones están conectadas a Facebook?")?.id, "facebook-connected-apps");
});

test("does not guess when platform or approved intent is absent", () => {
  assert.equal(findVerifiedGuide("Quiero proteger mejor mi cuenta"), null);
  assert.equal(findVerifiedGuide("¿Cómo elimino Instagram?"), null);
  assert.equal(findVerifiedGuide("¿Cómo configuro TikTok?"), null);
});

test("routes a guide with traceable metadata and the same request id", () => {
  const requestId = "f0a8695d-7e6a-4af7-937c-af82c5fb84f2";
  const response = routeApprovedGuide(requestId, "Activa la verificación en dos pasos de Google");
  assert.equal(response?.requestId, requestId);
  assert.equal(response?.kind, "guide");
  assert.equal(response?.guideId, "google-two-step-verification");
  assert.equal(response?.guideRevision, "2026-11-05");
  assert.ok(response && response.steps.length <= 6);
});
