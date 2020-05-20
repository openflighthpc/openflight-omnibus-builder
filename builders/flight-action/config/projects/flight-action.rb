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
name 'flight-action'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/action-client-ruby'
friendly_name 'Flight Action'

install_dir '/opt/flight/opt/action'

VERSION = '0.3.3'
override 'flight-action', version: VERSION

build_version VERSION
build_iteration 1

dependency 'preparation'
dependency 'flight-action'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Execute predefined actions on flight clusters'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

runtime_dependency 'flight-runway'
runtime_dependency 'flight-ruby-system-2.0'

if ohai['platform_family'] == 'rhel'
  # XXX Perhaps this should be changed to a recommends.
  runtime_dependency 'awscli'
elsif ohai['platform_family'] == 'debian'
end

%w(
  opt/flight/etc/banner/tips.d/40-power.rc
  opt/flight/libexec/commands/action
  opt/flight/libexec/commands/power
  opt/flight/opt/action/bin/action
).each do |f|
  extra_package_file f
end

if ohai['platform_family'] == 'rhel'
  rhel_rel = ohai['platform_version'].split('.').first.to_i
  if rhel_rel == 8
    package :rpm do
      vendor 'Alces Flight Ltd'
    end
  else
    package :rpm do
      vendor 'Alces Flight Ltd'
    end
  end
end

package :deb do
  vendor 'Alces Flight Ltd'
end