#!/bin/bash
echo "Configuring"

set_string() {
    local key
    local value
    key="$1"
    value=$( echo "${2}" | sed -s 's/"/\\"/g' )

    "${flight_ROOT}/bin/ruby" <<EOF
require 'yaml'
if File.exist?('/opt/flight/opt/action-api/config/application.yaml')
  yaml = File.read('/opt/flight/opt/action-api/config/application.yaml')
  config = YAML.load(yaml)
else
  config = { }
end
config["${key}"] = "${value}"
File.write('/opt/flight/opt/action-api/config/application.yaml', config.to_yaml)
EOF
}

for a in "$@"; do
  IFS="=" read k v <<< "${a}"
  case $k in
    jwt_secret)
      set_string jwt_secret "${v}"
      ;;

    *)
      echo "Unrecognised key: $k"
    ;;
  esac
done
