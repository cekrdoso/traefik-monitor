#!/bin/sh

MONITOR_PID_FILE="${MONITOR_PID_FILE:-/run/monitor.pid}"

if [ "${1}x" = "--pidx" ]; then

    [ -r "${MONITOR_PID_FILE}" ] && cat "${MONITOR_PID_FILE}" || exit 1
    exit 0

elif [ -r "${MONITOR_PID_FILE}" ]; then

    echo "Monitor is already running, exiting."
    exit 1

fi
echo $$ > "${MONITOR_PID_FILE}"

while ! pidof traefik; do
    sleep 1
done

while : ; do
    sleep 15
    rsync -a --inplace --delete "${MONITOR_WATCH_SRC_DIR}/" "${MONITOR_WATCH_DST_DIR}/"
done
