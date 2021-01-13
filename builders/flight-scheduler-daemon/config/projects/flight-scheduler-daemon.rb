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
name 'flight-scheduler-daemon'
maintainer 'Alces Flight Ltd'
homepage "https://github.com/openflighthpc/flight-scheduler-daemon"
friendly_name 'Flight Scheduler Daemon'

install_dir '/opt/flight/opt/scheduler-daemon'

VERSION = '0.7.0-rc1'
override 'flight-scheduler-daemon', version: VERSION

build_version VERSION
build_iteration 2

dependency 'preparation'
dependency 'flight-scheduler-daemon'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Run the flight scheduler execution daemon'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

runtime_dependency 'flight-ruby-system-2.0'
runtime_dependency 'flight-runway'
runtime_dependency 'flight-scheduler'
runtime_dependency 'flight-service'
runtime_dependency 'flight-service-system-1.0'
runtime_dependency 'lshw'

config_file '/opt/flight/opt/scheduler-daemon/etc/flight-scheduler-daemon.yaml'

require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end

package :rpm do
  vendor 'Alces Flight Ltd'
end

package :deb do
  vendor 'Alces Flight Ltd'
end
