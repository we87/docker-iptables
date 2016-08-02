#!/bin/sh

TARGET_IP=${TARGET_IP:-127.0.0.1}
TARGET_PORT=${TARGET_PORT:-8080}
RUN_FOREVER=${RUN_FOREVER:-"false"}

if [ -n "${DESTINATIONS}" ]; then
  DESTINATIONS="${DESTINATIONS}" IFS=,
  for dest in $DESTINATIONS; do
    iptables -t nat -A OUTPUT -p tcp -d $dest -j DNAT --to-destination ${TARGET_IP}:${TARGET_PORT}
  done
fi

if [ -n "${CMD}" ]; then
  CMD="${CMD}" IFS=,
  for c in $CMD; do
    exec_cmd="iptables $c"
    echo "==> will executing: \"${exec_cmd}\""
    eval "${exec_cmd}"
  done
fi

if [[ ${RUN_FOREVER} = "true" ]]; then
    sleep 1000d
fi
