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
name 'flight-hunter'
default_version '0.3.0'

source git: 'https://github.com/openflighthpc/flight-hunter'

dependency 'enforce-flight-runway'
whitelist_file Regexp.new("vendor/ruby/.*\.so$")

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  require 'yaml'
  require 'fileutils'
  env = with_standard_compiler_flags(with_embedded_path)

  # Moves the project into place
  [
    'Gemfile', 'Gemfile.lock', 'bin', 'data', 'etc', 'lib', 'libexec',
    'LICENSE.txt', 'README.md', 'underware.gemspec'
  ].each do |file|
    copy file, File.expand_path("#{install_dir}/#{file}/..")
  end

  # Installs the gems to the shared `vendor/share`
  flags = [
    "--without development test",
    '--path vendor'
  ].join(' ')
  command "cd #{install_dir} && /opt/flight/bin/bundle install #{flags}", env: env

  block do
    config = {
      'port' => 8888,
      'autorun_mode' => 'hunt',
      'auth_key' => 'flight-hunter'
    }
    File.write(
      File.expand_path("#{install_dir}/etc/config.yml"),
      config.to_yaml
    )
  end
end
