#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
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
name 'flight-console-api'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-console-api'
friendly_name 'Flight Console api'

install_dir '/opt/flight/opt/console-api'

VERSION = '2.2.3'
override 'flight-console-api', version: ENV.fetch('ALPHA', VERSION)

build_version(ENV.key?('ALPHA') ? VERSION.sub(/(-\w+)?\Z/, '-alpha') : VERSION)
build_iteration 1

dependency 'preparation'
dependency 'update_web_suite_package_scripts'
dependency 'flight-console-api'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'API to provide browser access to an interactive terminal console'

exclude '**/.git'
exclude '**/.gitkeep'

runtime_dependency 'flight-service-system-1.0'
runtime_dependency 'flight-nodejs'
runtime_dependency 'flight-js-system-2.0'
runtime_dependency 'flight-www'
runtime_dependency 'flight-www-system-1.0'

require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end

config_file "#{install_dir}/etc/config.json"
config_file "/opt/flight/etc/logrotate.d/console-api"
config_file "/opt/flight/etc/www/server-https.d/console-01-api.conf"

package :rpm do
  vendor 'Alces Flight Ltd'
end

package :deb do
  vendor 'Alces Flight Ltd'
end
