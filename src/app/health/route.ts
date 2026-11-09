import { readFile } from "node:fs/promises";
import { Client } from "pg";
import { health } from "../../modules/health/health";

export const dynamic = "force-dynamic";
export const runtime = "nodejs";

export async function GET() {
  const revision = await readFile("/app/revision.txt", "utf8")
    .then((value) => value.trim())
    .catch(() => "");
  const result = await health(async () => {
    if (!process.env.HEALTH_DATABASE_URL)
      throw new Error("Missing database configuration");
    const client = new Client({
      connectionString: process.env.HEALTH_DATABASE_URL,
      connectionTimeoutMillis: 2000,
      query_timeout: 2000,
    });
    try {
      await client.connect();
      await client.query("SELECT 1");
    } finally {
      await client.end().catch(() => {});
    }
  }, revision);
  return Response.json(result.body, {
    status: result.status,
    headers: { "Cache-Control": "no-store" },
  });
}
