export type HealthResult = {
  status: number;
  body: { status: "ok" | "unavailable"; revision: string };
};

export async function health(
  probe: () => Promise<void>,
  revision: string,
): Promise<HealthResult> {
  try {
    if (!/^[a-f0-9]{40}$/.test(revision))
      throw new Error("Invalid build revision");
    await probe();
    return { status: 200, body: { status: "ok", revision } };
  } catch {
    return { status: 503, body: { status: "unavailable", revision } };
  }
}
