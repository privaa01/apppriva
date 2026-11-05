import {ContextItem} from "../../src/zyro/contracts.js";
import {GeneralOrientationProvider} from "../../src/zyro/vertex_adapter.js";

export class FakeVertex implements GeneralOrientationProvider {
  calls: Array<{message: string; context: ContextItem[]}> = [];
  response = "Revisa con calma las alertas y usa únicamente los canales oficiales.";
  error: Error | null = null;

  async respond(message: string, context: ContextItem[]): Promise<string> {
    this.calls.push({message, context: [...context]});
    if (this.error) throw this.error;
    return this.response;
  }
}
