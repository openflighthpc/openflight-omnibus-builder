#==============================================================================
# Copyright (C) 2023-present Alces Flight Ltd.
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

name 'flight-silo'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-silo'
friendly_name 'Flight Example'

install_dir '/opt/flight/opt/silo'


if ohai['platform_family'] == 'rhel'
  rhel_rel = ohai['platform_version'].split('.').first.to_i
  if rhel_rel == 7
    VERSION = '0.0.0'

  elsif rhel_rel == 8
    VERSION = '0.0.0'
  end
elsif ohai['platform_family'] == 'debian'
  VERSION='0.0.0'
end

override 'flight-silo', version: VERSION

build_version VERSION
build_iteration 2

dependency 'preparation'
dependency 'flight-silo'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Persistent cloud storage for ephemeral instances'

exclude '**.git'
exclude '**.gitkeep'
exclude '**/bundler/git'

runtime_dependency 'flight-runway'
runtime_dependency 'flight-ruby-system-2.0'

# Updates the version in the libexec file
path = File.expand_path('../../opt/flight/libexec/commands/silo', __dir__)
original = File.read(path)
updated = original.sub(/^: VERSION: [[:graph:]]+$/, ": VERSION: #{VERSION}")
                  .sub(/^: SYNOPSIS:.*$/, ": SYNOPSIS: #{description}")
File.write(path, updated) unless original == updated

extra_package_file 'opt/flight/libexec/commands/silo'

config_file "/opt/flight/opt/silo/etc/config.yml"

package :rpm do
  vendor 'Alces Flight Ltd'
end

package :deb do
  vendor 'Alces Flight Ltd'
end
