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
name 'flight-repoman'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-repoman'
friendly_name 'Flight Repository Manager'

install_dir '/opt/flight/opt/repoman'

VERSION = '1.0.0'
override 'flight-repoman', version: VERSION

build_version VERSION
build_iteration 1

dependency 'preparation'
dependency 'flight-repoman'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Assist with the configuration of custom and mirror repositories'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

REPOMAN_SYSTEM = '1.0'
runtime_dependency 'flight-runway'
runtime_dependency 'flight-ruby-system-2.0'
runtime_dependency 'flight-repoman-repolists'

if ohai['platform_family'] == 'rhel'
  runtime_dependency 'yum-utils'
  runtime_dependency 'createrepo'
  runtime_dependency 'wget'
elsif ohai['platform_family'] == 'debian'
  raise "Debian build not yet supported"
end

%w(
  opt/flight/libexec/commands/repoman
).each do |f|
  extra_package_file f
end

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority ":flight-repoman-system=#{REPOMAN_SYSTEM}"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section "::flight-repoman-system=#{REPOMAN_SYSTEM}"
end
