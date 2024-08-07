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

VERSION = '2.1.0'
CERT_VERSION = '0.6.2'

override 'flight-www', version: ENV.fetch('ALPHA', VERSION)
override 'flight-cert', version: ENV.fetch('ALPHA_cert', CERT_VERSION)
override :nginx, version: '1.27.0'
override 'flight-landing-page', version: '2.0.2'

if ENV.key?('ALPHA') || ENV.key?('ALPHA_cert')
  build_version VERSION.sub(/(-\w+)?\Z/, '-alpha')
else
  build_version VERSION
end
build_iteration 1

dependency 'preparation'
dependency 'enforce-flight-runway'
dependency 'flight-www'
dependency 'flight-landing-page'
dependency 'flight-cert'
dependency 'version-manifest'

replace 'flight-landing-page'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'A web server for use in Flight HPC environments'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

# NOTE: The 1.1 system adds the /downloads location
WWW_SYSTEMS = (0..1).map { |i| ":flight-www-system-1.#{i}" }.join(' ')

# * 1.1 added config-packs.
# * 1.2 added support for consistent chrome/branding.
# * 1.3 added support for bookmarks
# * 2.0 marks the web suite overhaul
LANDING_PAGE_SYSTEMS = (0..0).map { |i| ":flight-landing-page-system-2.#{i}" }.join(' ')

runtime_dependency 'flight-plugin-cron'
runtime_dependency 'flight-runway'
runtime_dependency 'flight-ruby-system-2.0'
runtime_dependency 'flight-service'
runtime_dependency 'flight-service-system-1.0'
runtime_dependency 'flight-certbot'
runtime_dependency 'flight-landing-page-content'

require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end
extra_package_file('/opt/flight/etc/www/nginx.conf')

config_file '/opt/flight/etc/cert.yaml'

# Update the version numbering in files
File.expand_path('../../opt/flight/libexec/commands/www', __dir__).tap do |path|
  content = File.read path
  content.sub!(/: VERSION:.*/, ": VERSION: #{VERSION}")
  File.write path, content
end

if ohai['platform_family'] == 'rhel'
  runtime_dependency 'flight-service >= 1.3.0'
elsif ohai['platform_family'] == 'debian'
  runtime_dependency 'flight-service (>= 1.3.0)'
else
  raise "Unrecognised platform: #{ohai['platform_family']}"
end

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority "#{WWW_SYSTEMS} #{LANDING_PAGE_SYSTEMS}"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section ":#{WWW_SYSTEMS} #{LANDING_PAGE_SYSTEMS}"
end
