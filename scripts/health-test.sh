#!/usr/bin/env bash
set -Eeuo pipefail

revision=$(git rev-parse HEAD)
suffix="$$-${RANDOM}"
network="ae-health-${suffix}"
db="ae-health-db-${suffix}"
app="ae-health-app-${suffix}"
network_created=0
db_created=0
app_created=0
cleanup() {
  local result=$? cleanup_failed=0
  trap - EXIT
  if (( app_created )); then docker rm -f "$app" >/dev/null || cleanup_failed=1; fi
  if (( db_created )); then docker rm -f "$db" >/dev/null || cleanup_failed=1; fi
  if (( network_created )); then docker network rm "$network" >/dev/null || cleanup_failed=1; fi
  if (( cleanup_failed )); then
    echo 'Health test cleanup failed; inspect the ae-health resources.' >&2
    result=1
  fi
  exit "$result"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

docker network create "$network" >/dev/null
network_created=1
docker create --name "$db" --network "$network" -e POSTGRES_PASSWORD=disposable-test-only postgres:17-alpine >/dev/null
db_created=1
docker start "$db" >/dev/null
ready=0
for _ in {1..60}; do
  if docker exec "$db" pg_isready -U postgres >/dev/null 2>&1; then ready=1; break; fi
  sleep 1
done
if (( ! ready )); then echo 'PostgreSQL did not become ready' >&2; exit 1; fi

docker create --name "$app" --network "$network" -e "HEALTH_DATABASE_URL=postgresql://postgres:disposable-test-only@${db}:5432/postgres" sd-test-todo-2:local >/dev/null
app_created=1
docker start "$app" >/dev/null
probe='const [expected, revision] = process.argv.slice(1); (async () => { for (let i = 0; i < 40; i++) { try { const response = await fetch("http://127.0.0.1:3000/health"); const body = await response.json(); if (response.status === Number(expected) && body.status === (expected === "200" ? "ok" : "unavailable") && body.revision === revision) { console.log(`${response.status} ${JSON.stringify(body)}`); return; } if (i === 39) console.error("Unexpected health response", response.status, JSON.stringify(body)); } catch (error) { if (i === 39) console.error("Health request failed", error.message); } await new Promise(resolve => setTimeout(resolve, 500)); } process.exitCode = 1; })();'
docker exec "$app" node -e "$probe" 200 "$revision"
docker stop "$db" >/dev/null
docker exec "$app" node -e "$probe" 503 "$revision"
