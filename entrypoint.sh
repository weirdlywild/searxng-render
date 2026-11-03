#!/bin/sh
set -u

: "${SEARXNG_SECRET:?SEARXNG_SECRET must be set}"
: "${AUTH_PASSWORD:?AUTH_PASSWORD must be set}"

echo "[entrypoint] diagnosing caddy..."
ls -la /usr/local/bin/caddy || echo "[entrypoint] caddy binary MISSING"
/usr/local/bin/caddy version || echo "[entrypoint] caddy version failed rc=$?"
mkdir -p /tmp/caddy-config
HASH="$($(/usr/local/bin/caddy hash-password --plaintext "$AUTH_PASSWORD" 2>/tmp/caddy-err) )" || { echo "[entrypoint] hash-password failed rc=$? err:"; cat /tmp/caddy-err; }
echo "[entrypoint] hash ok: ${HASH:+yes}"

sed "s|__AUTH_HASH__|$HASH|; s|ultrasecretkey|$SEARXNG_SECRET|" /etc/caddy/Caddyfile.template > /tmp/caddy-config/Caddyfile.generated
echo "[entrypoint] caddyfile generated with hash: ${HASH:+yes}"
cat /tmp/caddy-config/Caddyfile.generated | head -8

exec /usr/local/bin/caddy run --config /tmp/caddy-config/Caddyfile.generated --adapter caddyfile --pidfile /tmp/caddy.pid &
CADDY_PID=$!
sleep 2

export SEARXNG_PORT=8081
exec /usr/local/searxng/.venv/bin/granian --host 127.0.0.1 --port 8081 searx.webapp:app
