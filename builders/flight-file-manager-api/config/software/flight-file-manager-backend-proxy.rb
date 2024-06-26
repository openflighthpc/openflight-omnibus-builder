#==============================================================================
# Copyright (C) 2024-present Alces Flight Ltd.
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
name 'flight-file-manager-backend-proxy'
default_version '0.0.0'

source git: 'https://github.com/openflighthpc/flight-file-manager'

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  block do
    FileUtils.mkdir_p File.join(install_dir, 'backend-proxy')
  end

  # Moves the shared project into place
  ['LICENSE.txt'].each do |file|
    copy file, File.expand_path("#{install_dir}/backend-proxy/#{file}/..")
  end

  # Moves the project into place
  [ 'README.md', 'go.mod', 'main.go' ].each do |file|
    copy File.join('backend-proxy', file), File.expand_path("#{install_dir}/backend-proxy/#{file}/..")
  end

  # Build backend-proxy and then remove the unwanted files.
  command "cd #{install_dir}/backend-proxy " \
          "&& go build", env: env
  %w(go.mod main.go).each do |path|
    delete File.expand_path("#{install_dir}/backend-proxy/#{path}")
  end
end
