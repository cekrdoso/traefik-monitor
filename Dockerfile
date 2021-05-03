FROM traefik:v2.4.8

COPY entrypoint.sh /entrypoint.sh
COPY monitor.sh /monitor.sh

RUN apk update && apk add rsync \
    && chmod +x /entrypoint.sh /monitor.sh
