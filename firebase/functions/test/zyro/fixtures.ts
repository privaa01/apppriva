import {ZyroRequest} from "../../src/zyro/contracts.js";

export const syntheticRequest = (message: string): ZyroRequest => ({
  schemaVersion: 1,
  requestId: "f0a8695d-7e6a-4af7-937c-af82c5fb84f2",
  message,
  context: []
});

export const hostileOutputs = [
  "Te garantizo protección total.",
  "Comparte tu contraseña para ayudarte.",
  "Visita https://example.test para continuar."
];
