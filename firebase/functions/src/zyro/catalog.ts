import rawCatalogue from "./guides.v1.json";

export type GuidePlatform = "instagram" | "facebook" | "google";

export interface VerifiedGuide {
  id: string;
  platform: GuidePlatform;
  action: string;
  surface: string;
  revision: string;
  status: "vigente";
  steps: string[];
  consequences: string;
  source: string;
}

interface CatalogueFile {
  schemaVersion: number;
  catalogueId: string;
  reviewedAt: string;
  guides: unknown[];
}

const platforms = new Set<GuidePlatform>(["instagram", "facebook", "google"]);

function parseGuide(value: unknown): VerifiedGuide | null {
  if (!value || typeof value !== "object") return null;
  const row = value as Record<string, unknown>;
  const keys = ["id", "platform", "action", "surface", "revision", "status", "steps", "consequences", "source"];
  if (Object.keys(row).some((key) => !keys.includes(key)) ||
      keys.some((key) => !(key in row)) ||
      typeof row.id !== "string" || row.id.length === 0 ||
      typeof row.platform !== "string" || !platforms.has(row.platform as GuidePlatform) ||
      typeof row.action !== "string" || typeof row.surface !== "string" ||
      typeof row.revision !== "string" || row.status !== "vigente" ||
      typeof row.consequences !== "string" || typeof row.source !== "string" ||
      !Array.isArray(row.steps) || row.steps.length === 0 || row.steps.length > 6 ||
      row.steps.some((step) => typeof step !== "string" || step.trim().length === 0)) {
    return null;
  }
  return Object.freeze({...row, steps: Object.freeze([...row.steps])}) as unknown as VerifiedGuide;
}

export function isServableGuide(value: unknown): boolean {
  return parseGuide(value) !== null;
}

function loadCatalogue(value: unknown): ReadonlyArray<VerifiedGuide> {
  if (!value || typeof value !== "object") throw new Error("invalid-guide-catalogue");
  const file = value as CatalogueFile;
  if (file.schemaVersion !== 1 || typeof file.catalogueId !== "string" ||
      typeof file.reviewedAt !== "string" || !Array.isArray(file.guides)) {
    throw new Error("invalid-guide-catalogue");
  }
  const parsed = file.guides.map(parseGuide);
  if (parsed.some((guide) => guide === null)) throw new Error("invalid-guide-catalogue");
  const guides = parsed as VerifiedGuide[];
  if (new Set(guides.map((guide) => guide.id)).size !== guides.length) {
    throw new Error("duplicate-guide-id");
  }
  return Object.freeze(guides);
}

export const GUIDE_CATALOGUE_ID = rawCatalogue.catalogueId;
export const verifiedGuides = loadCatalogue(rawCatalogue);

const intentTerms: Readonly<Record<string, readonly string[]>> = {
  "instagram-private-account": ["privada", "privado", "quien puede ver", "quién puede ver"],
  "instagram-two-step-verification": ["dos pasos", "2 pasos", "autenticacion", "autenticación", "verificacion", "verificación"],
  "instagram-review-sessions": ["sesion", "sesión", "dispositivo", "acceso que no", "donde inicie", "dónde inicié"],
  "instagram-interaction-controls": ["mensaje", "mencion", "mención", "etiqueta", "estado de actividad", "historia"],
  "facebook-publication-audience": ["publicacion", "publicación", "audiencia", "quien puede ver", "quién puede ver", "historia"],
  "facebook-two-step-verification": ["dos pasos", "2 pasos", "autenticacion", "autenticación", "verificacion", "verificación"],
  "facebook-review-sessions": ["sesion", "sesión", "dispositivo", "acceso que no", "donde inicie", "dónde inicié"],
  "facebook-connected-apps": ["aplicacion", "aplicación", "sitio web", "conectada", "permiso"],
  "google-security-review": ["revision de seguridad", "revisión de seguridad", "recomendacion", "recomendación", "asegurar mi cuenta"],
  "google-two-step-verification": ["dos pasos", "2 pasos", "verificacion", "verificación", "llave de acceso"],
  "google-review-devices": ["dispositivo", "sesion", "sesión", "acceso que no", "donde inicie", "dónde inicié"],
  "google-activity-privacy": ["actividad", "historial", "takeout", "datos y privacidad", "descargar mis datos"]
};

function normalized(text: string): string {
  return text.trim().toLocaleLowerCase("es-CO");
}

export function findVerifiedGuide(message: string): VerifiedGuide | null {
  const text = normalized(message);
  const platform = (["instagram", "facebook", "google"] as const)
    .find((candidate) => text.includes(candidate));
  if (!platform) return null;
  let best: VerifiedGuide | null = null;
  let bestScore = 0;
  for (const guide of verifiedGuides) {
    if (guide.platform !== platform) continue;
    const score = (intentTerms[guide.id] ?? []).filter((term) => text.includes(term)).length;
    if (score > bestScore) {
      best = guide;
      bestScore = score;
    }
  }
  return bestScore > 0 ? best : null;
}
