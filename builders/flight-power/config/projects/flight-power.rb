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
name 'flight-power'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-power'
friendly_name 'Flight Power'

install_dir '/opt/flight/opt/power'

VERSION = '1.1.0'
override 'flight-power', version: VERSION

build_version VERSION
build_iteration 1

dependency 'preparation'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Execute power actions on flight clusters'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

runtime_dependency 'flight-action'

# Moves the correct howto version into place
howto_src = File.expand_path("../../contrib/howto/#{VERSION.sub(/\.\d+(\.[abcr].*)?\Z/, '')}", __dir__)
howto_relative = "opt/flight/usr/share/howto/flight-power.md"
howto_dst = File.expand_path("../../#{howto_relative}", __dir__)
raise "Could not locate: #{howto_src}" unless File.exists? howto_src
FileUtils.mkdir_p File.dirname(howto_dst)
FileUtils.rm_f howto_dst
FileUtils.cp howto_src, howto_dst

%w(
  opt/flight/etc/banner/tips.d/40-power.rc
  opt/flight/libexec/commands/power
).each do |f|
  extra_package_file f
end
extra_package_file howto_relative

# Update the version numbering in files
File.expand_path('../../opt/flight/libexec/commands/power', __dir__).tap do |path|
  content = File.read path
  content.sub!(/: VERSION:.*/, ": VERSION: #{VERSION}")
  File.write path, content
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

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority "flight-howto-system-1.0"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section ":flight-howto-system-1.0"
end
