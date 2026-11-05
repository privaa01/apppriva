import {GoogleGenAI} from "@google/genai";

import {ContextItem} from "./contracts.js";

export interface GeneralOrientationProvider {
  respond(message: string, context: ContextItem[]): Promise<string>;
}

export class VertexOrientationProvider implements GeneralOrientationProvider {
  private readonly client: GoogleGenAI;

  constructor(
    project: string,
    private readonly model = "gemini-3.5-flash-lite",
    location = "us-central1"
  ) {
    this.client = new GoogleGenAI({
      vertexai: true,
      project,
      location,
      httpOptions: {timeout: 14000, retryOptions: {attempts: 1}}
    });
  }

  async respond(message: string, context: ContextItem[]): Promise<string> {
    const response = await this.client.models.generateContent({
      model: this.model,
      contents: JSON.stringify({message, context}),
      config: {
        systemInstruction: "Eres Zyro, asistente educativo de privacidad y seguridad para personas de 40 a 65 años. Responde en español sencillo, reconoce incertidumbre, no solicites credenciales, no incluyas URLs, no ejecutes acciones, no prometas protección y no generes pasos para configurar cuentas. Devuelve solo el JSON solicitado.",
        responseMimeType: "application/json",
        responseJsonSchema: {
          type: "object",
          additionalProperties: false,
          required: ["message"],
          properties: {message: {type: "string", maxLength: 1200}}
        },
        temperature: 0.2,
        maxOutputTokens: 400
      }
    });
    if (!response.text) throw new Error("empty-provider-response");
    const parsed: unknown = JSON.parse(response.text);
    if (!parsed || typeof parsed !== "object" ||
        Object.keys(parsed).some((key) => key !== "message") ||
        typeof (parsed as {message?: unknown}).message !== "string") {
      throw new Error("invalid-provider-response");
    }
    return (parsed as {message: string}).message;
  }
}
