#!/bin/bash
echo "Configuring"

# Ensure file exists and is not empty.
FILE="${flight_ROOT}"/etc/service/env/scheduler-daemon
mkdir -p $(dirname "${FILE}")
echo >> "${FILE}"

for a in "$@"; do
  IFS="=" read k v <<< "${a}"
  sed -i "${FILE}" \
      -e "/${k}=/d" \
      -e "\$a${k}=${v}" \
      -e '/^$/d'
done
