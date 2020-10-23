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
name 'flight-howto'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-howto'
friendly_name 'Flight Inventory'

install_dir '/opt/flight/opt/howto'

VERSION = '1.0.3'
override 'flight-howto', version: VERSION

build_version VERSION
build_iteration 2

dependency 'preparation'
dependency 'flight-howto'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'View user guides for your HPC environment'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

runtime_dependency 'flight-ruby-system-2.0'
runtime_dependency 'flight-runway'

# Updates the version in the libexec file
path = File.expand_path('../../opt/flight/libexec/commands/howto', __dir__)
original = File.read(path)
File.write path, original.sub(/^: VERSION: [[:graph:]]+$/, ": VERSION: #{VERSION}")

Dir.glob('opt/**/*')
   .select { |p| File.file? p }
   .each { |p| extra_package_file p }

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority ":flight-howto-system-1.0"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section "::flight-howto-system-1.0"
end
