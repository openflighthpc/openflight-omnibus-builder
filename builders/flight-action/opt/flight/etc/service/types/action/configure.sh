#!/bin/bash
echo "Configuring"

set_string() {
    local key
    local value
    key="$1"
    value=$( echo "${2}" | sed -s 's/"/\\"/g' )

    "${flight_ROOT}/bin/ruby" <<EOF
require 'yaml'
if File.exist?('/opt/flight/opt/action/etc/config.yaml')
  yaml = File.read('/opt/flight/opt/action/etc/config.yaml')
  config = YAML.load(yaml)
else
  config = { }
end
config["${key}"] = "${value}"
File.write('/opt/flight/opt/action/etc/config.yaml', config.to_yaml)
EOF
}

set_bool() {
    local key
    local value
    key="$1"
    if [ "${2}" == "true" ] ; then
        value=true
    else
        value=false
    fi

    "${flight_ROOT}/bin/ruby" <<EOF
require 'yaml'
if File.exist?('/opt/flight/opt/action/etc/config.yaml')
  yaml = File.read('/opt/flight/opt/action/etc/config.yaml')
  config = YAML.load(yaml)
else
  config = { }
end
config["${key}"] = ${value}
File.write('/opt/flight/opt/action/etc/config.yaml', config.to_yaml)
EOF
}

for a in "$@"; do
  IFS="=" read k v <<< "${a}"
  case $k in
    jwt_token)
      set_string jwt_token "${v}"
      ;;

    base_url)
      set_string base_url "${v}"
      ;;

    verify_ssl)
      set_bool verify_ssl "${v}"
      ;;

    *)
      echo "Unrecognised key: $k"
    ;;
  esac
done
