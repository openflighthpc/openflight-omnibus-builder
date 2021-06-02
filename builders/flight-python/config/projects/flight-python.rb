#==============================================================================
# Copyright (C) 2021-present Alces Flight Ltd.
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
name 'flight-python'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/openflight-omnibus-builder/blob/master/builders/flight-python/README.md'
friendly_name 'Flight NodeJS'

install_dir '/opt/flight/opt/python'

VERSION = '3.9.5'
override 'flight-python', version: VERSION

build_version VERSION
build_iteration 1

dependency 'preparation'
dependency 'python'
dependency 'version-manifest'

override 'python', version: VERSION

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Python3 platform for Flight tools.'

require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end

exclude '**/.git'
exclude '**/.gitkeep'

# NOTE: The "flight-python-system-*" track the MAJOR.MINOR release of python
#       This allows packages to hard specify the require minor versions without
#       using upper/lower bounds.
PYTHON_SYSTEM = VERSION.sub(/\.\d+\Z/, '')

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority ":flight-python-system-#{PYTHON_SYSTEM}"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section "::flight-python-system-#{PYTHON_SYSTEM}"
end
