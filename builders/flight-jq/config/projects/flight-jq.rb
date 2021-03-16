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
name 'flight-jq'
maintainer 'Alces Flight Ltd'
# homepage 'https://github.com/openflighthpc/openflight-omnibus-builder/blob/master/builders/flight-jq/README.md'
homepage 'https://github.com/openflighthpc/openflight-omnibus-builder'
friendly_name 'Flight Runway'

install_dir '/opt/flight/opt/jq'

VERSION = '1.6'
override 'flight-jq', version: VERSION

build_version VERSION
build_iteration 1

dependency 'preparation'
dependency 'flight-jq'
dependency 'version-manifest'

license 'MIT'
license_file 'LICENSE.txt'

description 'Flight build of the jq JSON processor'

strip_build true

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'
exclude '**/lib/*.a'
exclude '**/lib/*.la'

