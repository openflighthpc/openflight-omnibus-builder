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
name "flight-console-webapp"
default_version "0.0.0"

source git: 'https://github.com/openflighthpc/flight-console-webapp'

dependency 'enforce-flight-nodejs'

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # There is an intermittent build issue where the "yarn install" fails.
  # The "ejs" transient dependency's postinstall script assumes that "node" is
  # on the PATH. Without the PATH modification below, this *should* cause the
  # build to fail each time "ejs" is installed, i.e., not used from cache.
  #
  # However there is a long running 'yarn' bug where it does not execute the
  # postinstall script. This means the build *may* succeed regardless.
  # https://github.com/yarnpkg/yarn/issues/5476
  env['PATH'] = "#{env['PATH']}:/opt/flight/bin"

  # These are only needed to build the software.  We don't want them in the
  # RPM.
  build_only = %w( package.json yarn.lock public src .env .nvmrc)

  build_only.each do |file|
    copy file, File.expand_path("#{install_dir}/#{file}/..")
  end

  [
    'LICENSE.txt', 'README.md'
  ].each do |file|
    copy file, File.expand_path("#{install_dir}/#{file}/..")
  end

  command "cd #{install_dir} && /opt/flight/bin/yarn install", env: env
  command "cd #{install_dir} && /opt/flight/bin/yarn run build", env: env

  build_only.each do |file|
    delete File.expand_path("#{install_dir}/#{file}")
  end

  block do
    config = { apiRootUrl: "/console/api" }
    File.write(
      File.join(install_dir, 'build', 'config.json'),
      config.to_json
    )
  end
end
