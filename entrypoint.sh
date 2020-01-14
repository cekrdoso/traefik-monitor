#!/bin/sh
set -e

if [ ! -z "${WATCH_CONF_DIR}" ] \
    && [ ! `/monitor.sh --pid >/dev/null 2>&1` ]; then
    export MONITOR_WORKDIR="/run/monitor"
    export MONITOR_WATCH_SRC_DIR="${WATCH_CONF_DIR}"
    export MONITOR_WATCH_DST_DIR="${MONITOR_WORKDIR}${WATCH_CONF_DIR}"
    export TRAEFIK_PROVIDERS_FILE_DIRECTORY="${MONITOR_WATCH_DST_DIR}"
    export TRAEFIK_PROVIDERS_FILE_WATCH="true"
    mkdir -p "${MONITOR_WATCH_SRC_DIR}" "${MONITOR_WATCH_DST_DIR}"
    rsync -a --inplace --delete "${MONITOR_WATCH_SRC_DIR}/" "${MONITOR_WATCH_DST_DIR}/"
    ( /monitor.sh ) &
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- traefik "$@"
fi

# if our command is a valid Traefik subcommand, let's invoke it through Traefik instead
# (this allows for "docker run traefik version", etc)
if traefik "$1" --help >/dev/null 2>&1
then
    set -- traefik "$@"
else
    echo "= '$1' is not a Traefik command: assuming shell execution." 1>&2
fi


exec "$@"
