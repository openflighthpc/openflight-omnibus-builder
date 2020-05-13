#!/bin/bash
echo "Starting"
if [ -f ${flight_SERVICE_etc}/www.rc ]; then
  . ${flight_SERVICE_etc}/www.rc
fi
mkdir -p "${flight_ROOT}"/var/run
mkdir -p "${flight_ROOT}"/var/log/www
for a in access.log error.log websockets-access.log websockets-error.log; do
  touch "${flight_ROOT}"/var/log/www/$a
  chown nobody "${flight_ROOT}"/var/log/www/$a
done
www_port="${www_port:-80}"
tool_bg "${flight_ROOT}"/opt/www/embedded/sbin/nginx -c "${flight_ROOT}"/etc/www/nginx.conf
wait
c=0
while [ ! -f "${flight_ROOT}/var/run/www.pid" ]; do
  if [ $c -gt 10 ]; then
    break
  fi
  sleep 1
  c+=1
done
tool_set pid=$(cat "${flight_ROOT}/var/run/www.pid")
