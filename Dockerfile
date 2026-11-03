FROM searxng/searxng:latest

USER root
COPY Caddyfile.template /etc/caddy/Caddyfile.template
COPY authwrap.py /usr/local/searxng/authwrap.py
COPY entrypoint.sh /usr/local/searxng/entrypoint-custom.sh
COPY settings.yml /etc/searxng/settings.yml

RUN chmod +x /usr/local/searxng/entrypoint-custom.sh

WORKDIR /usr/local/searxng
ENTRYPOINT ["/usr/local/searxng/entrypoint-custom.sh"]
