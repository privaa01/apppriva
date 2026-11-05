import {ZyroRequest, ZyroResponse} from "./contracts.js";
import {routeApprovedGuide} from "./guide_router.js";
import {generalUnavailable, isInScope, prefilter, safeGeneralResponse} from "./policy.js";
import {GeneralOrientationProvider} from "./vertex_adapter.js";

export async function routeZyro(
  input: ZyroRequest,
  provider: GeneralOrientationProvider
): Promise<ZyroResponse> {
  const limited = prefilter(input.requestId, input.message);
  if (limited) return limited;
  const guide = routeApprovedGuide(input.requestId, input.message);
  if (guide) return guide;
  if (!isInScope(input.message)) return generalUnavailable(input.requestId);
  try {
    const answer = await provider.respond(input.message, input.context);
    return safeGeneralResponse(input.requestId, answer);
  } catch {
    return generalUnavailable(input.requestId);
  }
}
