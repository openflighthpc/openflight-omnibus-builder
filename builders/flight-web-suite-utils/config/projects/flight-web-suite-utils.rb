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
name 'flight-web-suite-utils'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-web-suite-utils'
friendly_name 'Flight Web Suite Utils'

install_dir '/opt/flight/opt/web-suite-utils'

VERSION = '1.0.0-rc1'
override 'flight-web-suite-utils', version: VERSION

build_version VERSION
build_iteration 1

dependency 'preparation'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Miscellaneous utilities for flight-web-suite'

runtime_dependency 'flight-starter-system-1.0'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

# Glob after updating the opt directory
Dir.glob('opt/**/*')
   .select { |p| File.file? p }
   .each { |p| extra_package_file p }

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
end
