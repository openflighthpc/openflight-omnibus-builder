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
name 'flight-www'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/openflight-omnibus-builders/builders/flight-www'
friendly_name 'Flight web server service'

install_dir '/opt/flight/opt/www'

VERSION = '1.1.0-rc5'
override 'flight-www', version: VERSION

build_version VERSION
build_iteration '1'

dependency 'preparation'
dependency 'flight-www'
dependency 'flight-landing-page'
dependency 'https-management'
dependency 'version-manifest'

replace 'flight-landing-page'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'A web server for use in Flight HPC environments'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

override :nginx, version: '1.14.2'
override 'flight-landing-page', version: '0.0.6'

WWW_SYSTEM = '1.0'
runtime_dependency 'flight-plugin-cron'
runtime_dependency 'flight-runway'
runtime_dependency 'flight-ruby-system-2.0'
runtime_dependency 'flight-service'
runtime_dependency 'flight-service-system-1.0'
runtime_dependency 'flight-certbot'

require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end

config_file '/opt/flight/opt/www/landing-page/overridden'
config_file '/opt/flight/opt/www/landing-page/overridden/content'
config_file '/opt/flight/opt/www/landing-page/overridden/layouts'

# Update the version numbering in files
File.expand_path('../../opt/flight/libexec/commands/www', __dir__).tap do |path|
  content = File.read path
  content.sub!(/: VERSION:.*/, ": VERSION: #{VERSION}")
  File.write path, content
end
File.expand_path('../../lib/bin/https', __dir__).tap do |path|
  content = File.read path
  content.sub!(/VERSION=.*/, "VERSION='#{VERSION}'")
  File.write path, content
end

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority ":flight-www-system-#{WWW_SYSTEM}"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section "::flight-www-system-#{WWW_SYSTEM}"
end
