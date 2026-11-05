import {Firestore} from "firebase-admin/firestore";
import {CallableRequest, HttpsError} from "firebase-functions/v2/https";

import {parseRequest, ZyroResponse} from "./contracts.js";
import {consumeRateLimit} from "./rate_limit.js";
import {routeZyro} from "./router.js";
import {GeneralOrientationProvider} from "./vertex_adapter.js";

interface AuthorizationEvidence {
  user_id?: unknown;
  policy_version?: unknown;
  action?: unknown;
  accepted?: unknown;
  purposes?: unknown;
}

export interface ZyroCallableDependencies {
  readEvidence(uid: string): Promise<AuthorizationEvidence | undefined>;
  consume(uid: string): Promise<void>;
  provider: GeneralOrientationProvider;
}

export function hasValidEvidence(value: AuthorizationEvidence | undefined, uid: string): boolean {
  return value?.user_id === uid && value.policy_version === "priva-1.0.0" &&
    value.action === "account_signup" && value.accepted === true &&
    Array.isArray(value.purposes) && value.purposes.length === 2 &&
    value.purposes[0] === "personalized_greeting" &&
    value.purposes[1] === "account_access_recovery";
}

export async function handleZyroWithDependencies(
  request: CallableRequest<unknown>,
  dependencies: ZyroCallableDependencies
): Promise<ZyroResponse> {
  const auth = request.auth;
  if (!auth || auth.token.firebase?.sign_in_provider !== "password" || auth.token.email_verified !== true) {
    throw new HttpsError("unauthenticated", "Debes iniciar sesión con un correo verificado.");
  }
  if (!request.app) {
    throw new HttpsError("failed-precondition", "No pudimos comprobar la aplicación.");
  }
  let input;
  try {
    input = parseRequest(request.data);
  } catch {
    throw new HttpsError("invalid-argument", "La solicitud no tiene el formato esperado.");
  }
  const evidence = await dependencies.readEvidence(auth.uid);
  if (!hasValidEvidence(evidence, auth.uid)) {
    throw new HttpsError("permission-denied", "No pudimos comprobar la autorización de acceso.");
  }
  await dependencies.consume(auth.uid);
  return routeZyro(input, dependencies.provider);
}

export async function handleZyro(
  request: CallableRequest<unknown>,
  database: Firestore,
  provider: GeneralOrientationProvider
): Promise<ZyroResponse> {
  return handleZyroWithDependencies(request, {
    readEvidence: async (uid) => {
      const snapshot = await database.collection("authorization_evidence").doc(uid).get();
      return snapshot.data();
    },
    consume: (uid) => consumeRateLimit(database, uid),
    provider
  });
}
