import assert from "node:assert/strict";
import test from "node:test";
import {Firestore} from "firebase-admin/firestore";
import {HttpsError} from "firebase-functions/v2/https";

import {consumeRateLimit} from "../../src/zyro/rate_limit.js";

test("allows ten requests per window, rejects the eleventh and stores no content", async () => {
  let stored: Record<string, unknown> | undefined;
  const database = {
    collection: () => ({doc: () => ({id: "uid-1"})}),
    runTransaction: async (callback: (transaction: unknown) => Promise<void>) => callback({
      get: async () => ({data: () => stored}),
      set: (_reference: unknown, value: Record<string, unknown>) => { stored = value; }
    })
  } as unknown as Firestore;

  for (let index = 0; index < 10; index++) {
    await consumeRateLimit(database, "uid-1", 1000);
  }
  assert.equal(stored?.requestCount, 10);
  assert.deepEqual(Object.keys(stored ?? {}).sort(), ["expiresAt", "requestCount", "windowStartedAt"]);
  await assert.rejects(
    consumeRateLimit(database, "uid-1", 1000),
    (error: unknown) => error instanceof HttpsError && error.code === "resource-exhausted"
  );
});

test("starts a new window after ten minutes", async () => {
  let stored: Record<string, unknown> | undefined;
  const database = {
    collection: () => ({doc: () => ({id: "uid-1"})}),
    runTransaction: async (callback: (transaction: unknown) => Promise<void>) => callback({
      get: async () => ({data: () => stored}),
      set: (_reference: unknown, value: Record<string, unknown>) => { stored = value; }
    })
  } as unknown as Firestore;
  await consumeRateLimit(database, "uid-1", 1000);
  await consumeRateLimit(database, "uid-1", 1000 + 10 * 60 * 1000);
  assert.equal(stored?.requestCount, 1);
});
