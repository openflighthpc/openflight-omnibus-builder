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
name 'flight-websockify'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/openflight-omnibus-builder/builders/flight-websockify'
friendly_name 'Flight Certbot'

install_dir '/opt/flight/opt/websockify'

VERSION = '1.0.0'
PYTHON_SYSTEM = '3.8'
override 'flight-websockify', version: VERSION
override 'enforce-flight-python', version: PYTHON_SYSTEM

build_version VERSION
build_iteration 2

override 'sqlite3', version: '3.32.3.0'

dependency 'preparation'
dependency 'enforce-flight-python'
dependency 'flight-websockify'
dependency 'version-manifest'

runtime_dependency "flight-python-system-#{PYTHON_SYSTEM}"

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Alternative openFlightHPC build of websockify'

strip_build true

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'
exclude '**/__pycache__'
exclude '**/lib/python3.8/test'
exclude '**/lib/python3.8/config-3.8-x86_64-linux-gnu'
exclude '**/lib/*.a'
exclude '**/lib/*.la'

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
elsif ohai['platform_family'] == 'debian'
  package :deb do
    vendor 'Alces Flight Ltd'
  end
end
