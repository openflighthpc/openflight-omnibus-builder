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

install_dir '/opt/flight/opt/env'

VERSION = '1.4.1-rc1'
override 'flight-env', version: VERSION

build_version VERSION
build_iteration 1

dependency 'preparation'
dependency 'flight-env'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Manage and access HPC application ecosystems'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

ENV_SYSTEM = '1.0'
runtime_dependency 'flight-runway'
runtime_dependency 'flight-ruby-system-2.0'
runtime_dependency 'flight-env-types'

# Moves the correct howto version into place
howto_src = File.expand_path("../../contrib/howto/#{VERSION.sub(/\.\d+(-\w.*)?\Z/, '')}", __dir__)
howto_relative = "opt/flight/usr/share/howto/flight-env.md"
howto_dst = File.expand_path("../../#{howto_relative}", __dir__)
raise "Could not locate: #{howto_src}" unless File.exists? howto_src
FileUtils.mkdir_p File.dirname(howto_dst)
FileUtils.rm_f howto_dst
FileUtils.cp howto_src, howto_dst

if ohai['platform_family'] == 'rhel'
  # vim-common provides xxd a dependency required by Gridware
  # Homebrew requires: perl-ExtUtils-MakeMaker & patch
  %w(
    wget libuuid-devel zlib-devel uuid gcc-c++ sqlite-devel
    cmake openssl-devel git vim-common bzip2 gzip unzip tar
    make perl-ExtUtils-MakeMaker patch
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
  # Homebrew requires: patch & perl-modules (for ExtUtils::MakeMaker)
  %w(
    wget uuid-dev zlib1g-dev uuid g++ libsqlite3-dev
    cmake libssl-dev git vim-common bzip2 gzip unzip tar
    python3 python3-setuptools pkg-config perl-modules patch
  ).each do |dep|
    runtime_dependency dep
  end
end

%w(
  opt/flight/libexec/commands/env
  opt/flight/etc/env.rc
  opt/flight/etc/env.cshrc
  opt/flight/etc/profile.d/10-env.csh
  opt/flight/etc/profile.d/10-env.sh
  opt/flight/etc/banner/tips.d/10-env.rc
).each do |f|
  extra_package_file f
end
extra_package_file howto_relative

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority "flight-howto-system-1.0 :flight-env-system-#{ENV_SYSTEM}"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section "::flight-env-system-#{ENV_SYSTEM} flight-howto-system-1.0"
end
