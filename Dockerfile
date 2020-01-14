FROM traefik:v2.0

COPY entrypoint.sh /entrypoint.sh
COPY monitor.sh /monitor.sh

RUN apk update && apk add rsync \
    && chmod +x /entrypoint.sh /monitor.sh
