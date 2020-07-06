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
name 'flight-desktop'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-desktop'
friendly_name 'Flight Desktop'

install_dir '/opt/flight/opt/desktop'

VERSION = '1.3.0'
override 'flight-desktop', version: VERSION

build_version VERSION
build_iteration 2

dependency 'preparation'
dependency 'flight-desktop'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Manage interactive GUI desktop sessions'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

DESKTOP_SYSTEM = '1.0'
runtime_dependency 'flight-runway'
runtime_dependency 'flight-ruby-system-2.0'
runtime_dependency 'flight-desktop-types'

if ohai['platform_family'] == 'rhel'
  runtime_dependency 'tigervnc-server-minimal'
  runtime_dependency 'xorg-x11-xauth'
  runtime_dependency 'perl'
elsif ohai['platform_family'] == 'debian'
  runtime_dependency 'tigervnc-standalone-server'
  runtime_dependency 'xauth'
  runtime_dependency 'perl'
end

%w(
  opt/flight/libexec/commands/desktop
  opt/flight/etc/banner/tips.d/20-desktop.rc
).each do |f|
  extra_package_file f
end

if ohai['platform_family'] == 'rhel'
  rhel_rel = ohai['platform_version'].split('.').first.to_i
  if rhel_rel == 8
    package :rpm do
      vendor 'Alces Flight Ltd'
      # repurposed 'priority' field to set RPM recommends/provides
      # provides are prefixed with `:`
      # neither 'apg' or 'python-websockify' are available on RHEL8,
      # but we provide them in the openflight repos.
      # note: xorg-x11-apps is only available in PowerTools
      priority "xorg-x11-apps netpbm-progs apg python3-websockify :flight-desktop-system-#{DESKTOP_SYSTEM}"
    end
  else
    package :rpm do
      vendor 'Alces Flight Ltd'
      # repurposed 'priority' field to set RPM recommends/provides
      # provides are prefixed with `:`
      priority ":flight-desktop-system-#{DESKTOP_SYSTEM}"
    end
  end
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section ":netpbm x11-apps apg websockify :flight-desktop-system-#{DESKTOP_SYSTEM}"
end
