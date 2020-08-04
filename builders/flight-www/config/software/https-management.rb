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
name 'https-management'
default_version '1.0.0'

dependency 'enforce-flight-runway'

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  block do
    # Install to a subdirectory so our Gemfile doesn't clash with the one from
    # landing-page.
    install_dir = "#{install_dir()}/https"
    FileUtils.mkdir_p install_dir

    # Moves the project into place.  NOTE: the funky way to locate the sources
    # as the source files live with the builder and are not yet an upstream
    # project.
    [
      'Gemfile', 'Gemfile.lock', 'bin', 'lib',
      # 'LICENSE.txt', 'README.md'
    ].each do |file|
      src = File.join(File.expand_path('../../include/', __dir__), file)
      copy src, File.expand_path("#{install_dir}/#{file}/..")
    end

    # Installs the gems
    flags = [
      "--without development test",
      '--path vendor'
    ].join(' ')
    command "cd #{install_dir} && /opt/flight/bin/bundle install #{flags}", env: env
  end
end