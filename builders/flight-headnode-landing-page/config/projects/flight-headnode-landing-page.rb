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
name 'flight-headnode-landing-page'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/openflight-omnibus-builders/builders/flight-headnode-landing-page'
friendly_name 'Headnode content for landing page'

install_dir '/opt/flight/opt/www/landing-page/default'

VERSION = '2.0.1'
LOGIN_VERSION = '1.0.0'
override 'flight-headnode-landing-page', version: ENV.fetch('ALPHA', VERSION)
override 'flight-webapp-components', version: ENV.fetch('ALPHA_login', LOGIN_VERSION)

if ENV.key?('ALPHA') || ENV.key?('ALPHA_login')
  build_version VERSION.sub(/(-\w+)?\Z/, '-alpha')
else
  build_version VERSION
end
build_iteration 1

dependency 'preparation'
dependency 'flight-headnode-landing-page'
dependency 'flight-webapp-components'
dependency 'version-manifest'

if ohai['platform_family'] == 'rhel'
  conflict 'flight-www < 1.3.0'
elsif ohai['platform_family'] == 'debian'
  conflict 'flight-www (<< 1.3.0)'
else
  raise "Unrecognised platform: #{ohai['platform_family']}"
end

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'A headnode landing page for use in Flight HPC environments'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

runtime_dependency 'flight-landing-page-system-2.0'
BRANDING_SYSTEMS = (0..0).map { |i| ":flight-landing-page-branding-system-2.#{i}" }.join(' ')

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority ":flight-landing-page-content #{BRANDING_SYSTEMS}"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section "::flight-landing-page-content #{BRANDING_SYSTEMS}"
end
