#!/bin/bash
echo "Configuring"
mkdir -p "${flight_SERVICE_etc}"
>"${flight_SERVICE_etc}/example.rc"
for a in "$@"; do
  IFS="=" read k v <<< "${a}"
  echo "www_$k=\"$v\"" >> "${flight_SERVICE_etc}/www.rc"
  case $k in
    port)
      # XXX - test?
      sed -i "${flight_ROOT}"/etc/www/http.d/base-http.conf \
          -e "s/^\s*listen\s.*;/listen ${v} default;/g"
    ;;
    https_port)
      if [ -f "${flight_ROOT}"/etc/www/http.d/https.conf.disabled ] ; then
          sed -i "${flight_ROOT}"/etc/www/http.d/https.conf.disabled \
              -e "s/^\s*listen\s.*;/listen ${v} ssl default;/g"
      fi
      if [ -f "${flight_ROOT}"/etc/www/http.d/https.conf ] ; then
          sed -i "${flight_ROOT}"/etc/www/http.d/https.conf \
              -e "s/^\s*listen\s.*;/listen ${v} ssl default;/g"
      fi
    ;;
    *)
      echo "Unrecognised key: $k"
    ;;
  esac
done
