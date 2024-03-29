#==============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
#
# This file is part of OpenFlight Omnibus Builder.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# This project is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with this project. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on OpenFlight Omnibus Builder, please visit:
# https://github.com/openflighthpc/openflight-omnibus-builder
#===============================================================================
name 'flight-job-script-api'
maintainer 'Alces Flight Ltd'
homepage "https://github.com/openflighthpc/flight-job-script-service"
friendly_name 'Flight Job Script API'

install_dir '/opt/flight/opt/job-script-api'

VERSION = '1.9.0'
override 'flight-job-script-api', version: ENV.fetch('ALPHA', VERSION)

build_version(ENV.key?('ALPHA') ? VERSION.sub(/(-\w+)?\Z/, '-alpha') : VERSION)
build_iteration 1

dependency 'preparation'
dependency 'flight-job-script-api'
dependency 'update_puma_scripts'
dependency 'update_web_suite_package_scripts'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'API server for creating customised job scripts'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

# Flight Dependencies
runtime_dependency 'flight-runway'
runtime_dependency 'flight-ruby-system-2.0'
runtime_dependency 'flight-www'
runtime_dependency 'flight-www-system-1.0'
runtime_dependency 'flight-service'
runtime_dependency 'flight-service-system-1.0'

if ohai['platform_family'] == 'rhel'
  runtime_dependency 'flight-job >= 2.10.0'
  runtime_dependency 'flight-job < 2.11.0'
  runtime_dependency 'flight-service >= 1.3.0'
elsif ohai['platform_family'] == 'debian'
  runtime_dependency 'flight-job (>= 2.10.0)'
  runtime_dependency 'flight-job (<< 2.11.0)'
  runtime_dependency 'flight-service (>= 1.3.0)'
else
  raise "Unrecognised platform: #{ohai['platform_family']}"
end

config_file '/opt/flight/etc/job-script-api.yaml'
config_file '/opt/flight/etc/service/env/job-script-api'
config_file '/opt/flight/etc/logrotate.d/job-script-api'
config_file '/opt/flight/etc/www/server-https.d/job-script-api.conf'

require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end

package :rpm do
  vendor 'Alces Flight Ltd'
end

package :deb do
  vendor 'Alces Flight Ltd'
end
