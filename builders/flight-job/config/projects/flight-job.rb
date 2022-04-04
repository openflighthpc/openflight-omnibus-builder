#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
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
name 'flight-job'
maintainer 'Alces Flight Ltd'
homepage 'https://github.com/openflighthpc/flight-job'
friendly_name 'Flight Job'

install_dir '/opt/flight/opt/job'

VERSION = '2.8.0'
override 'flight-job', version: ENV.fetch('ALPHA', VERSION)

build_version(ENV.key?('ALPHA') ? VERSION.sub(/(-\w+)?\Z/, '-alpha') : VERSION)
build_iteration 1

dependency 'preparation'
dependency 'flight-job'
dependency 'version-manifest'

license 'EPL-2.0'
license_file 'LICENSE.txt'

description 'Generate and submit jobs from predefined templates'

exclude '**/.git'
exclude '**/.gitkeep'
exclude '**/bundler/git'

runtime_dependency 'flight-ruby-system-2.0'
runtime_dependency 'flight-runway'
runtime_dependency 'flight-jq'

config_file '/opt/flight/etc/job.yaml'
config_file '/opt/flight/libexec/job/slurm/sbatch-wrapper.sh'

# Moves the correct howto version into place
howto_src = File.expand_path("../../contrib/howto/#{VERSION.sub(/\.\d+(-\w.*)?\Z/, '')}", __dir__)
howto_dst = File.expand_path("../../opt/flight/usr/share/howto/flight-job.md", __dir__)
raise "Could not locate: #{howto_src}" unless File.exists? howto_src
FileUtils.mkdir_p File.dirname(howto_dst)
FileUtils.rm_f howto_dst
FileUtils.cp howto_src, howto_dst

# Updates the version in the libexec file
path = File.expand_path('../../opt/flight/libexec/commands/job', __dir__)
original = File.read(path)
updated = original.sub(/^: VERSION: [[:graph:]]+$/, ": VERSION: #{VERSION}")
                  .sub(/^: SYNOPSIS:.*$/, ": SYNOPSIS: #{description}")
File.write(path, updated) unless original == updated

require 'find'
Find.find('opt') do |o|
  extra_package_file(o) if File.file?(o)
end

package :rpm do
  vendor 'Alces Flight Ltd'
  # repurposed 'priority' field to set RPM recommends/provides
  # provides are prefixed with `:`
  priority "flight-howto-system-1.0"
end

package :deb do
  vendor 'Alces Flight Ltd'
  # repurposed 'section' field to set DEB recommends/provides
  # entire section is prefixed with `:` to trigger handling
  # provides are further prefixed with `:`
  section ":flight-howto-system-1.0"
end
