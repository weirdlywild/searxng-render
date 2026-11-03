#!/bin/sh
set -eu

: "${SEARXNG_SECRET:?SEARXNG_SECRET must be set}"
: "${AUTH_PASSWORD:?AUTH_PASSWORD must be set}"

HASH="$(caddy hash-password --plaintext "$AUTH_PASSWORD")"
sed "s|__AUTH_HASH__|$HASH|; s|ultrasecretkey|$SEARXNG_SECRET|" \
  /etc/caddy/Caddyfile.template > /tmp/Caddyfile.generated

caddy run --config /tmp/Caddyfile.generated &
exec /usr/local/searxng/.venv/bin/granian --host 127.0.0.1 --port 8081 searx.webapp:app
