export const POLICY_VERSION = "zyro-policy-1";
export const MAX_MESSAGE = 1000;
export const MAX_CONTEXT_ITEMS = 8;
export const MAX_CONTEXT_CHARS = 6000;
export const MAX_STEPS = 6;

export type Role = "user" | "zyro";
export type ResponseKind = "guide" | "general" | "limit";
export interface ContextItem { role: Role; text: string }
export interface ZyroRequest {
  schemaVersion: 1;
  requestId: string;
  message: string;
  context: ContextItem[];
}
export interface ZyroResponse {
  schemaVersion: 1;
  requestId: string;
  kind: ResponseKind;
  message: string;
  steps: string[];
  guideId?: string;
  guideRevision?: string;
  retryable: boolean;
  policyVersion: string;
}

const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
export function parseRequest(value: unknown): ZyroRequest {
  if (!value || typeof value !== "object") throw new Error("invalid-argument");
  const data = value as Record<string, unknown>;
  if (Object.keys(data).some((key) => !["schemaVersion", "requestId", "message", "context"].includes(key)) ||
      data.schemaVersion !== 1 || typeof data.requestId !== "string" || !uuid.test(data.requestId) ||
      typeof data.message !== "string" || data.message.trim().length === 0 || data.message.length > MAX_MESSAGE ||
      !Array.isArray(data.context) || data.context.length > MAX_CONTEXT_ITEMS) {
    throw new Error("invalid-argument");
  }
  let total = 0;
  for (const item of data.context) {
    if (!item || typeof item !== "object") throw new Error("invalid-argument");
    const row = item as Record<string, unknown>;
    if (Object.keys(row).some((key) => !["role", "text"].includes(key)) ||
        !["user", "zyro"].includes(String(row.role)) || typeof row.text !== "string") {
      throw new Error("invalid-argument");
    }
    total += row.text.length;
  }
  if (total > MAX_CONTEXT_CHARS) throw new Error("invalid-argument");
  return data as unknown as ZyroRequest;
}
