name "enforce-flight-nodejs"
description "enforce existence of flight-nodejs"
default_version "1.0.0"

license :project_license
skip_transitive_dependency_licensing true

build do
  block do
    raise "Flight NodeJS is not installed!" if ! File.exists?('/opt/flight/bin/yarn')
  end
end
