# searxng-render

Custom SearXNG image for Render: JSON API enabled + HTTP basic auth via pure-python middleware.

- Public entrypoint (port 8080) is Caddy: requires basic auth (user `raj`, password via `AUTH_PASSWORD` env).
- SearXNG (granian) binds 127.0.0.1:8081.
- `SEARXNG_SECRET` replaces the secret_key at startup; `SEARXNG_BASE_URL` set to the Render URL.
