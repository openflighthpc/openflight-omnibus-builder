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
name 'flight-runway'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-runway'
friendly_name 'Flight Runway'

install_dir '/opt/flight/opt/runway'

build_version '1.0.0'
build_iteration 1

# Creates required build directories
dependency 'preparation'

# flight-runway dependencies/components
dependency 'flight-runway'

# Version manifest file
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Integrated platform for Flight tools.'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

override :ruby, version: '2.6.1'

%w(ruby irb gem bundle rake flight flexec flenable flactivate flintegrate flensure).each do |f|
  extra_package_file "/opt/flight/bin/#{f}"
end

%w(05-flight.sh 05-flight.csh).each do |f|
  extra_package_file "/opt/flight/etc/profile.d/#{f}"
end

%w(commands/help commands/shell shell/shell).each do |f|
  extra_package_file "/opt/flight/libexec/#{f}"
end

runtime_dependency 'unzip'

package :rpm do
  vendor 'Alces Flight Ltd'
end
