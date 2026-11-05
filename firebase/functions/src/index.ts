import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {onCall} from "firebase-functions/v2/https";

import {handleZyro} from "./zyro/callable.js";
import {VertexOrientationProvider} from "./zyro/vertex_adapter.js";

initializeApp();
const database = getFirestore();
const provider = new VertexOrientationProvider(
  process.env.GCLOUD_PROJECT ?? "priva-785cb"
);

export const zyroRespond = onCall(
  {
    region: "us-central1",
    memory: "256MiB",
    timeoutSeconds: 15,
    concurrency: 10,
    enforceAppCheck: true
  },
  (request) => handleZyro(request, database, provider)
);
