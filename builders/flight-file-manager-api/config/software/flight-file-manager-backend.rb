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
name 'flight-file-manager-backend'
default_version '0.0.0'

source git: 'https://github.com/openflighthpc/flight-file-manager'

dependency 'enforce-flight-nodejs'

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  block do
    FileUtils.mkdir_p File.join(install_dir,  'backend')
  end

  # Moves the shared project into place
  ['LICENSE.txt'].each do |file|
    copy file, File.expand_path("#{install_dir}/backend/#{file}/..")
  end

  # Moves the project into place
  [
    'package.json', 'yarn.lock', 'src', 'lib',
    'LICENSE.txt',
    #'README.md',
  ].each do |file|
    copy File.join('backend', file), File.expand_path("#{install_dir}/backend/#{file}/..")
  end

  # Build cloudcmd and then remove the unwanted files.
  command "cd #{install_dir}/backend/lib/cloudcmd " \
          "&& /opt/flight/bin/yarn install " \
          "&& /opt/flight/bin/yarn run build", env: env
  %w(bin client css dist-dev docker html test).each do |path|
    delete File.expand_path("#{install_dir}/backend/lib/cloudcmd/#{path}")
  end

  command "cd #{install_dir}/backend && /opt/flight/bin/yarn install --production", env: env

  # Remove various development files from 'node_modules'
  # NOTE: An explicit list is maintained to prevent directories being deleted by mistake
  #       This list may need updating if new dependencies are added
  block do
    [
      "#{install_dir}/backend/node_modules/@cloudcmd/fileop/dist-dev",
      "#{install_dir}/backend/node_modules/console-io/dist-dev",
      "#{install_dir}/backend/node_modules/deepword/dist-dev",
      "#{install_dir}/backend/node_modules/dword/dist-dev",
      "#{install_dir}/backend/node_modules/edward/dist-dev",
      "#{install_dir}/backend/node_modules/monaco-editor/dev",
      "#{install_dir}/backend/node_modules/restafary/dist-dev",

      # This is the only source file with any considerable size
      # Edward still functions without it
      "#{install_dir}/backend/node_modules/edward/modules/ace-builds/src"
    ].each { |dir| FileUtils.rm_rf dir }
  end

  block do
    # Remove some git submodule files in some dependencies.  If these are left
    # in, the build caching mechanism used by omnibus breaks which in turn
    # breaks the build of this software.
    %w(spec stone).each do |dir|
      path = File.join(install_dir, "backend/node_modules/dropbox/generator", dir, ".git")
      FileUtils.rm_rf(path)
    end
  end
end
