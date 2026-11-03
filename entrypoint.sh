#!/bin/sh
set -eu

: "${SEARXNG_SECRET:?SEARXNG_SECRET must be set}"
: "${AUTH_PASSWORD:?AUTH_PASSWORD must be set}"

sed -i "s/ultrasecretkey/$SEARXNG_SECRET/" /etc/searxng/settings.yml

exec /usr/local/searxng/.venv/bin/granian --host 0.0.0.0 --port 8080 authwrap:app
