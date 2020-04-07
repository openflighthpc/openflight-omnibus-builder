#!/bin/bash
echo "Configuring"

set_string() {
    local key
    local value
    key="$1"
    value=$( echo "${2}" | sed -s 's/"/\\"/g' )

    # NOTE: This script is practically identical to `set_nil`.  If changing
    # one, change the other.
  "${flight_ROOT}/bin/ruby" <<EOF
require 'json'
json = File.read('/opt/flight/opt/desktop-webapp/build/config.json')
config = JSON.parse(json)
config["${key}"] = "${value}"
new_json = JSON.pretty_generate(config)
File.write('/opt/flight/opt/desktop-webapp/build/config.json', new_json)
EOF
}

set_nil() {
    local key
    key="$1"


    # NOTE: This script is practically identical to `set_string`.  If changing
    # one, change the other.
  "${flight_ROOT}/bin/ruby" <<EOF
require 'json'
json = File.read('/opt/flight/opt/desktop-webapp/build/config.json')
config = JSON.parse(json)
config["${key}"] = nil
new_json = JSON.pretty_generate(config)
File.write('/opt/flight/opt/desktop-webapp/build/config.json', new_json)
EOF
}

for a in "$@"; do
  IFS="=" read k v <<< "${a}"
  case $k in
    clusterName)
      set_string clusterName "${v}"
      ;;

    clusterDescription)
      set_string clusterDescription "${v}"
      ;;

    clusterLogo)
      if [[ -z "${v// }" ]]; then
          set_nil clusterLogo
      else
          set_string clusterLogo "${v}"
      fi
      ;;

    hostname)
      url="https://${v}/desktop/api"
      set_string apiRootUrl "${url}"
      ;;
    *)
      echo "Unrecognised key: $k"
    ;;
  esac
done
