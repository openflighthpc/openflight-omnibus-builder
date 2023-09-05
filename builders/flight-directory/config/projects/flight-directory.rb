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
name 'flight-directory'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-directory'
friendly_name 'Flight Directory'

install_dir '/opt/flight/opt/directory'

VERSION = '1.1.4'
override 'flight-directory', version: VERSION

build_version VERSION
build_iteration 1

PYTHON_SYSTEM = '3.8'
override 'sqlite3', version: '3.32.3.0'
override 'enforce-flight-python', version: PYTHON_SYSTEM
override 'flight-directory-requirements', python_system: PYTHON_SYSTEM

dependency 'preparation'
dependency 'enforce-flight-python'
dependency 'flight-directory'
dependency 'version-manifest'

runtime_dependency "flight-python-system-#{PYTHON_SYSTEM}"

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

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Simple interactive access to user and group management via IPA'

strip_build true

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'
exclude '**/__pycache__'
exclude '**/lib/python3.8/test'
exclude '**/lib/python3.8/config-3.8-x86_64-linux-gnu'
exclude '**/lib/*.a'
exclude '**/lib/*.la'

# Updates the version in the libexec file
cmd_path = File.expand_path('../../opt/flight/libexec/commands/directory', __dir__)
cmd = File.read(cmd_path)
          .sub(/^: VERSION: [[:graph:]]+$/, ": VERSION: #{VERSION}")
File.write cmd_path, cmd

require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end

Find.find(File.expand_path('../../dist/hooks', __dir__)) do |o|
  f = "/opt/flight/etc/directory/hooks/#{File.basename(o)}"
  if File.file?(o)
    extra_package_file(f)
    config_file(f)
  end
end

config_file '/opt/flight/etc/directory/base.conf'
config_file '/opt/flight/etc/directory/user-ops.conf'
config_file '/opt/flight/var/log/directory/record.log'
config_file '/opt/flight/var/cache/directory/history.txt'

if ohai['platform_family'] == 'rhel'
  runtime_dependency 'ipa-client'
  runtime_dependency 'krb5-workstation'
elsif ohai['platform_family'] == 'debian'
  runtime_dependency 'freeipa-client'
  runtime_dependency 'krb5-user'
end

package :rpm do
  vendor 'Alces Flight Ltd'
end

package :deb do
  vendor 'Alces Flight Ltd'
end
