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
name 'flight-console-webapi'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-console-webapi'
friendly_name 'Flight Console Webapi'

install_dir '/opt/flight/opt/console-webapi'

build_version '0.0.1'
build_iteration 0

dependency 'preparation'
dependency 'flight-console-webapi'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'API to provide browser access to an interactive terminal console'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

runtime_dep_versions = {
}

# NOTE: This syntax matches the RPM version syntax and may need tweaking for
# other distros.
runtime_dep_versions.each do |k,v|
  runtime_dependency "#{k} >= #{v[:gte]}, #{k} < #{v[:lt]}"
end

runtime_dependency 'flight-service-www'

require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end

package :rpm do
  vendor 'Alces Flight Ltd'
end
