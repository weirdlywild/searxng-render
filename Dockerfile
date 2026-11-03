FROM caddy:2.11.7 AS caddy

FROM searxng/searxng:latest

USER root
COPY --from=caddy /usr/bin/caddy /usr/local/bin/caddy

COPY Caddyfile.template /etc/caddy/Caddyfile.template
COPY entrypoint.sh /usr/local/searxng/entrypoint-custom.sh
COPY settings.yml /etc/searxng/settings.yml

RUN chmod +x /usr/local/bin/caddy /usr/local/searxng/entrypoint-custom.sh

WORKDIR /usr/local/searxng
ENTRYPOINT ["/usr/local/searxng/entrypoint-custom.sh"]
