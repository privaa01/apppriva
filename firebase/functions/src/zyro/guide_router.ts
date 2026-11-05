import {POLICY_VERSION, ZyroResponse} from "./contracts.js";
import {findVerifiedGuide} from "./catalog.js";

export function routeApprovedGuide(requestId: string, message: string): ZyroResponse | null {
  const guide = findVerifiedGuide(message);
  if (!guide) return null;
  return {
    schemaVersion: 1,
    requestId,
    kind: "guide",
    message: `${guide.action}. ${guide.consequences}`,
    steps: [...guide.steps],
    guideId: guide.id,
    guideRevision: guide.revision,
    retryable: false,
    policyVersion: POLICY_VERSION
  };
}
