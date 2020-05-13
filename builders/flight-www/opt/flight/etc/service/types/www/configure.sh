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
    *)
      echo "Unrecognised key: $k"
    ;;
  esac
done
