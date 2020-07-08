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
name 'flight-inventory'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-inventory'
friendly_name 'Flight Inventory'

install_dir '/opt/flight/opt/inventory'

VERSION = '2.0.0.rc1'
override 'flight-inventory', version: VERSION

build_version VERSION
build_iteration 0

dependency 'preparation'
dependency 'flight-inventory'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Manage interactive GUI inventory sessions'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

runtime_dependency 'flight-ruby-system-2.0'
runtime_dependency 'flight-runway'

# Updates the version in the libexec file
path = File.expand_path('../../opt/flight/libexec/commands/inventory', __dir__)
original = File.read(path)
updated = original.sub(/^: VERSION: [[:graph:]]+$/, ": VERSION: #{VERSION}")
unless original == updated
  File.write path, updated
  $stderr.puts <<~WARN
    Updated the version in the libexec file! Please commit the file and try again.
  WARN
  exit 1
end

extra_package_file 'opt/flight/libexec/commands/inventory'

package :rpm do
  vendor 'Alces Flight Ltd'
end

package :deb do
  vendor 'Alces Flight Ltd'
end
