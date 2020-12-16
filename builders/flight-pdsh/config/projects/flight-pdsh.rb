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
name 'flight-pdsh'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/openflight-omnibus-builder/blob/master/builders/flight-pdsh/README.md'
friendly_name 'Flight pdsh'

install_dir '/opt/flight/opt/pdsh'

VERSION = '2.34'
override 'pdsh', version: VERSION
override 'readline', version: '6.0'

build_version VERSION
build_iteration 4

dependency 'preparation'
dependency "genders"
dependency "pdsh"
dependency 'version-manifest'

license 'GPL-3.0'
license_file 'LICENSE.package.txt'

description 'A high performance, parallel remote shell utility.'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

extra_package_file "opt/flight/etc/flight-config-map.d/pdsh.yaml"
%w(dshbak nodeattr pdcp pdsh rpdcp).each do |f|
  extra_package_file "opt/flight/opt/pdsh/bin/#{f}"
end
extra_package_file "opt/flight/etc/genders"
%w(sh csh).each do |ext|
  extra_package_file "opt/flight/etc/profile.d/90-pdsh.#{ext}"
end

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  # priority ""
  priority "flight-starter"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  # section ""
  section ":flight-starter"
end
