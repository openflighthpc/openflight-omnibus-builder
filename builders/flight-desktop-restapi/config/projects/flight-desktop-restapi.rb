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
GIT_REPO = 'openflighthpc/flight-desktop-restapi'

name 'flight-desktop-restapi'
maintainer 'Alces Flight Ltd'
homepage "https://github.com/#{GIT_REPO}"
friendly_name 'Flight Desktop RestAPI'

install_dir '/opt/flight/opt/desktop-restapi'

# Sets the version numbering
require 'net/http'
VERSION = '1.0.0'
CLI_VERSION = Net::HTTP.get_response(
  URI.parse("https://raw.githubusercontent.com/#{GIT_REPO}/#{VERSION}/.cli-version")
).tap { |r| raise 'Failed to get cli version' unless r.code == '200' }
 .body
 .chomp
MAX_CLI_VERSION = "#{CLI_VERSION.split.first.to_i + 1}.0.0"

build_version VERSION
build_iteration 0

override 'flight-desktop-restapi', version: VERSION

dependency 'preparation'
dependency 'version-manifest'

dependency 'flight-desktop-restapi'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Manage interactive GUI desktop sessions'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

runtime_dependency "flight-runway"
# NOTE: This syntax matches the RPM version syntax and may need tweaking for other distros
runtime_dependency "flight-desktop >= #{CLI_VERSION}, flight-desktop < #{MAX_CLI_VERSION}"
runtime_dependency 'flight-service-www'

require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends
  #priority 'apg python-websockify xorg-x11-apps netpbm-progs'
end
