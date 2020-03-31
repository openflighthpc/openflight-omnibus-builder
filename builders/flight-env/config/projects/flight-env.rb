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
name 'flight-env'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-env'
friendly_name 'Flight Environment'

install_dir '/opt/flight/opt/flight-env'

build_version '1.4.0-rc3'
build_iteration 1

dependency 'preparation'
dependency 'flight-env'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Manage and access HPC application environments'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

runtime_dependency 'flight-runway'

if ohai['platform_family'] == 'rhel'
  # vim-common provides xxd a dependency required by Gridware
  %w(
    wget libuuid-devel zlib-devel uuid gcc-c++ sqlite-devel
    cmake openssl-devel git vim-common bzip2 gzip unzip tar
  ).each do |dep|
    runtime_dependency dep
  end

  rhel_rel = ohai['platform_version'].split('.').first.to_i
  if rhel_rel == 8
    # lua-posix, lua-devel, python3 required by EasyBuild
    runtime_dependency 'lua-posix'
    runtime_dependency 'lua-devel'
    runtime_dependency 'python3'
  elsif rhel_rel == 7
    # python-setuptools, ncurses-static required by EasyBuild
    runtime_dependency 'python-setuptools'
    runtime_dependency 'ncurses-static'
  else
    raise "Unable to determine platform_version: #{ohai['platform_version']}"
  end
elsif ohai['platform_family'] == 'debian'
  # ohai['platform_version'] => '18.04'
  %w(
    wget uuid-dev zlib1g-dev uuid g++ libsqlite3-dev
    cmake libssl-dev git vim-common bzip2 gzip unzip tar
    python3 python3-setuptools pkg-config
  ).each do |dep|
    runtime_dependency dep
  end
end

%w(
  opt/flight/libexec/commands/env
  opt/flight/etc/flight-env.rc
  opt/flight/etc/flight-env.cshrc
  opt/flight/etc/profile.d/10-flenv.csh
  opt/flight/etc/profile.d/10-flenv.sh
  opt/flight/etc/banner/tips.d/10-flenv.rc
).each do |f|
  extra_package_file f
end

package :rpm do
  vendor 'Alces Flight Ltd'
end
