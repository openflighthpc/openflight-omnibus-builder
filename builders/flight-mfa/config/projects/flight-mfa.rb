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
name 'flight-mfa'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-mfa'
friendly_name 'Flight MFA'

install_dir '/opt/flight/opt/mfa'

VERSION = '1.0.1'
override 'flight-mfa', version: VERSION

build_version VERSION
build_iteration 2

dependency 'preparation'
dependency 'flight-mfa'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Manage multi-factor authentication configuration'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

MFA_SYSTEM = '1.0'
runtime_dependency 'flight-runway'

if ohai['platform_family'] == 'rhel'
  runtime_dependency 'google-authenticator'
  runtime_dependency 'qrencode'
elsif ohai['platform_family'] == 'debian'
  runtime_dependency 'google-authenticator'
  runtime_dependency 'qrencode'
end

# Updates the version in the libexec file
cmd_path = File.expand_path('../../opt/flight/libexec/commands/mfa', __dir__)
cmd = File.read(cmd_path)
          .sub(/^: VERSION: [[:graph:]]+$/, ": VERSION: #{VERSION}")
File.write cmd_path, cmd

# Includes the static files
require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority ":flight-mfa-system-#{MFA_SYSTEM}"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section "::flight-mfa-system-#{MFA_SYSTEM}"
end
