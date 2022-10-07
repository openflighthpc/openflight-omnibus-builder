#!/bin/bash

export SHELLOPTS
set -e

if [ -z "$flight_ROOT" ]; then
  echo "flight_ROOT has not been set!" >&2
  exit 1
fi

echo "Starting"

mkdir -p "${flight_ROOT}"/var/run
mkdir -p "${flight_ROOT}"/var/log/hunter
cd "${flight_ROOT}"/opt/hunter/bin

pidfile="${flight_ROOT}"/var/run/hunter.pid
tool_bg "./start" "$pidfile"

for _ in `seq 1 20`; do
  sleep 0.5
  if [ -f "$pidfile" ]; then
    pid=$(cat "$pidfile")
    if [ -n "$pid" ]; then
      break
    fi
  fi
done

echo "Done waiting for PID. pid=${pid}"

# report pid or error
if [ -n "$pid" ]; then
  tool_set pid=$pid
  exit 0
else
  echo Failed to start hunter >&2
  exit 1
fi
