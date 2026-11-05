import {Firestore, Timestamp} from "firebase-admin/firestore";
import {HttpsError} from "firebase-functions/v2/https";

const WINDOW_MS = 10 * 60 * 1000;
const TTL_MS = 24 * 60 * 60 * 1000;
const MAX_REQUESTS = 10;

export async function consumeRateLimit(database: Firestore, uid: string, now = Date.now()): Promise<void> {
  const reference = database.collection("zyro_rate_limits").doc(uid);
  await database.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(reference);
    const data = snapshot.data();
    const previousStart = data?.windowStartedAt instanceof Timestamp
      ? data.windowStartedAt.toMillis() : 0;
    const inWindow = now - previousStart < WINDOW_MS;
    const count = inWindow && typeof data?.requestCount === "number" ? data.requestCount : 0;
    if (count >= MAX_REQUESTS) {
      throw new HttpsError("resource-exhausted", "Zyro alcanzó el límite temporal. Inténtalo más tarde.");
    }
    transaction.set(reference, {
      windowStartedAt: Timestamp.fromMillis(inWindow ? previousStart : now),
      requestCount: count + 1,
      expiresAt: Timestamp.fromMillis(now + TTL_MS)
    });
  });
}
