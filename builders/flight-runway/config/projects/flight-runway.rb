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

VERSION = '1.1.0'
override 'flight-runway', version: VERSION

build_version VERSION
build_iteration 3

dependency 'preparation'
dependency 'flight-runway'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Integrated platform for Flight tools.'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

RUBY_SYSTEM = '2.0'

RUBY_VERSION = '2.7.1'
override :ruby, version: RUBY_VERSION
BUNDLER_VERSION = '2.1.4'
override :bundler, version: BUNDLER_VERSION
override :rubygems, version: '3.1.2'

# This override is required to provide improved parity with the
# version of `openssl` available in RHEL8 (1.1.1c at the time of
# writing).
if ohai['platform_family'] == 'rhel'
  rhel_rel = ohai['platform_version'].split('.').first.to_i
  if rhel_rel == 8
    override :openssl, version: '1.1.1d'
  end
elsif ohai['platform_family'] == 'debian'
  override :openssl, version: '1.1.1d'
end

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
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority ":flight-ruby-system-#{RUBY_SYSTEM} :flight-ruby-#{RUBY_VERSION.split('.')[0..1].join('.')} :flight-bundler-#{BUNDLER_VERSION}"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section "::flight-ruby-system-#{RUBY_SYSTEM} :flight-ruby-#{RUBY_VERSION.split('.')[0..1].join('.')} :flight-bundler-#{BUNDLER_VERSION}"
end
