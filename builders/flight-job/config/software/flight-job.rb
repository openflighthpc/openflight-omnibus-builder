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
require 'ostruct'

name 'flight-job'
default_version '0.0.0'

source git: 'https://github.com/openflighthpc/flight-job'

dependency 'flight-runway'
whitelist_file Regexp.new("vendor/ruby/.*\.so$")

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Moves the project into place
  [
    'Gemfile', 'Gemfile.lock', 'bin', 'lib', 'LICENSE.txt', 'README.md'
  ].each do |file|
    copy file, File.expand_path("#{install_dir}/#{file}/..")
  end

  # Defines the context the reference template will be rendered in
  context = OpenStruct.new(
    program: <<~CONF,
      config :program_name,         default: ENV.fetch('FLIGHT_PROGRAM_NAME', 'flight job')
      config :program_application,  default: '#{project.friendly_name}'
      config :program_description,  default: '#{project.description}'
    CONF
    templates_dir: <<~CONF
      config :templates_dir, default: '/opt/flight/usr/share/job/templates'
    CONF
  ).instance_exec { self.binding }

  # Renders the reference into the project directory
  # NOTE: I believe this caches the rendered file TBC
  rendered_path = 'etc/config.reference.rendered'
  block do
    template = File.read(File.join(project_dir, 'etc/config.reference')).gsub(/^#<%/, '<%')
    reference = ERB.new(template, nil, '-').result(context)
    File.write(File.join(project_dir, rendered_path), reference)
  end

  # Installs the rendered reference config
  mkdir File.expand_path('etc', install_dir)
  copy rendered_path, File.expand_path('etc/config.reference', install_dir)

  # Installs the gems to the shared `vendor/share`
  flags = [
    "--without development test",
    '--path vendor'
  ].join(' ')
  command "cd #{install_dir} && /opt/flight/bin/bundle install #{flags}", env: env
end
