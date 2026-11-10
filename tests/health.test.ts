import { test } from "node:test";
import assert from "node:assert/strict";
import { health } from "../src/modules/health/health.ts";

test("a reachable database produces the exact build revision", async () => {
  const result = await health(
    async () => {},
    "0123456789abcdef0123456789abcdef01234567",
  );
  assert.deepEqual(result, {
    status: 200,
    body: {
      status: "ok",
      revision: "0123456789abcdef0123456789abcdef01234567",
    },
  });
});

test("database failures return unavailable without exposing the error", async () => {
  const result = await health(async () => {
    throw new Error("secret connection detail");
  }, "0123456789abcdef0123456789abcdef01234567");
  assert.deepEqual(result, {
    status: 503,
    body: {
      status: "unavailable",
      revision: "0123456789abcdef0123456789abcdef01234567",
    },
  });
});

test("an invalid build revision cannot be healthy", async () => {
  const result = await health(async () => {}, "not-a-sha");
  assert.equal(result.status, 503);
});
