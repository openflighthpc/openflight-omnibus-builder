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
name 'flight-nodejs'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/openflight-omnibus-builder/blob/master/builders/flight-nodejs/README.md'
friendly_name 'Flight NodeJS'

install_dir '/opt/flight/opt/nodejs'

NODEJS_VERSION = '12.16.3'
VERSION = NODEJS_VERSION
override 'flight-nodejs', version: VERSION

build_version VERSION
build_iteration 1

dependency 'preparation'
dependency 'flight-nodejs'
dependency 'version-manifest'

# JS_SYSTEM 2.0 represents a versioning scheme where `flight-nodejs` tracks
# the upstream nodejs version.  I.e., `flight-nodejs-14.15.4` installs nodejs
# 14.15.4.
JS_SYSTEM = '2.0'

override 'nodejs', version: NODEJS_VERSION
override 'yarn', version: '1.22.4'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'NodeJS platform for Flight tools.'

exclude '**/.git'
exclude '**/.gitkeep'

%w(node npm yarn).each do |f|
  extra_package_file "/opt/flight/bin/#{f}"
end

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority ":flight-js-system-#{JS_SYSTEM}"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section "::flight-js-system-#{JS_SYSTEM}"
end
