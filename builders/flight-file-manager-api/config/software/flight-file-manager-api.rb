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
name 'flight-file-manager-api'
default_version '0.0.0'

source git: 'https://github.com/openflighthpc/flight-file-manager'

dependency 'enforce-flight-runway'

whitelist_file Regexp.new("vendor/ruby/.*\.so$")

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Moves the shared project into place
  ['LICENSE.txt'].each do |file|
    copy file, File.expand_path("#{install_dir}/#{file}/..")
  end

  block do
    FileUtils.mkdir_p File.join(install_dir,  'etc')
  end

  # Moves the api project into place
  # XXX: Add an api specific README.md to the upstream sources
  [
    'Gemfile', 'Gemfile.lock', 'bin', 'config',
    'app', 'lib', 'README.md', 'app.rb', 'config.ru'
  ].each do |file|
    copy File.join('api', file), File.expand_path("#{install_dir}/#{file}/..")
  end

  # Copy the un-modified reference config in place
  copy 'api/etc/file-manager-api.yaml', File.join(install_dir, 'etc/file-manager-api.yaml.reference')

  # Move the config into the core location
  src_config = File.join project_dir, 'api/etc/file-manager-api.yaml'
  dst_config = '/opt/flight/etc/file-manager-api.yaml'
  block do
    # Remove the original config
    FileUtils.mkdir_p File.dirname(dst_config)
    FileUtils.rm_f dst_config

    # Update the relative path expansion note
    config = File.read(src_config).gsub(/#>>path<<.*(\n#.*)*(?=\n#--)/, <<~MSG.chomp)
      # The path maybe absolute or relative. All relative paths are expanded from:
      # /opt/flight
    MSG

    # Write the updated config
    File.write(dst_config, config)
  end
  project.extra_package_file dst_config

  # Move the libexec script into place
  src_libexec = File.join project_dir, 'api/libexec/cloudcmd.sh'
  dst_libexec = '/opt/flight/libexec/file-manager-api/cloudcmd.sh'
  block do
    # Remove the existing file
    FileUtils.mkdir_p File.dirname(dst_libexec)
    FileUtils.rm_f dst_libexec

    # Copy the file into place
    FileUtils.cp src_libexec, dst_libexec
  end
  project.extra_package_file dst_libexec

  # Installs the gems to the shared `vendor/share`
  flags = [
    '--with default',
    "--without development test",
    '--path vendor'
  ].join(' ')
  command "cd #{install_dir} && /opt/flight/bin/bundle install #{flags}", env: env
end
