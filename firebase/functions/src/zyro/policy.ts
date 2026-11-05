import {POLICY_VERSION, ZyroResponse} from "./contracts.js";

const sensitive = /\b(contrase(?:ña|na)|password|c[oó]digo(?:\s+de)?\s+(?:verificaci[oó]n|recuperaci[oó]n)|token|clave secreta)\b/i;
const harmful = /\b(hack(?:ear)?|entrar|acceder|espiar|robar)\b.{0,40}\b(cuenta|perfil|correo)\b.{0,20}\b(ajena|otro|otra|sin permiso)\b/i;
const scope = /\b(privacidad|seguridad|cuenta|contrase(?:ña|na)|sesi[oó]n|dispositivo|perfil|correo|phishing|fraude|instagram|facebook|google|gmail|datos|verificaci[oó]n|autenticaci[oó]n)\b/i;
const unsafeOutput = /(https?:\/\/|www\.|contrase(?:ña|na)|c[oó]digo de verificaci[oó]n|garantiz(?:o|amos|ado)|protecci[oó]n total|100\s*%)/i;

function limit(requestId: string, message: string): ZyroResponse {
  return {
    schemaVersion: 1,
    requestId,
    kind: "limit",
    message,
    steps: [],
    retryable: false,
    policyVersion: POLICY_VERSION
  };
}

export function prefilter(requestId: string, message: string): ZyroResponse | null {
  if (sensitive.test(message)) {
    return limit(requestId, "No compartas contraseñas, códigos ni claves. Puedo orientarte sin conocer esos datos.");
  }
  if (harmful.test(message)) {
    return limit(requestId, "No puedo ayudar a acceder a cuentas ajenas. Sí puedo orientarte para proteger o recuperar tu propia cuenta mediante los canales oficiales.");
  }
  return null;
}

export function generalUnavailable(requestId: string): ZyroResponse {
  return limit(requestId, "Todavía no tengo una guía aprobada para esa consulta. Revisa la ayuda oficial desde la aplicación o el sitio que ya conoces de la plataforma.");
}

export function isInScope(message: string): boolean {
  return scope.test(message);
}

export function safeGeneralResponse(requestId: string, message: string): ZyroResponse {
  const clean = message.trim();
  if (clean.length === 0 || clean.length > 1200 || unsafeOutput.test(clean)) {
    return limit(requestId, "No pude verificar esa orientación. Consulta la ayuda oficial desde la aplicación o el sitio que ya conoces de la plataforma.");
  }
  return {
    schemaVersion: 1,
    requestId,
    kind: "general",
    message: clean,
    steps: [],
    retryable: false,
    policyVersion: POLICY_VERSION
  };
}
