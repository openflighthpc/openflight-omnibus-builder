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
name 'flight-action-api-power'
maintainer 'Alces Flight Ltd'
homepage "https://github.com/openflighthpc/flight-action-api"
friendly_name 'Flight Action API power actions'

install_dir '/opt/flight/opt/action-api'

VERSION = '1.4.0'
override 'flight-action-api-power', version: VERSION

build_version VERSION
build_iteration 1

dependency 'preparation'
dependency 'flight-action-api-power'

text_manifest_path File.join(install_dir, "version-manifest.power-actions.txt")
json_manifest_path File.join(install_dir, "version-manifest.power-actions.json")

license 'EPL-2.0'
license_file 'LICENSE.txt'
license_file_path 'LICENSE.power-actions'

description 'Power actions for Flight Action API'

exclude '**/.git'
exclude '**/.gitkeep'

runtime_dependency 'flight-action-api'

package :rpm do
  vendor 'Alces Flight Ltd'
end

package :deb do
  vendor 'Alces Flight Ltd'
end
