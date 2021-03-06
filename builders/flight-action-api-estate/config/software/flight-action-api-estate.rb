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
name 'flight-action-api-estate'
default_version '0.0.0'

source git: 'https://github.com/openflighthpc/flight-action-api'

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  block do
    libexec_dir = File.expand_path(File.join(install_dir, 'libexec'))

    # Moves the project into place
    [
      'estate-change', 'estate-grow', 'estate-shrink', 'estate-show'
    ].each do |action|
      FileUtils.mkdir_p File.join(libexec_dir, action)
      copy File.join('libexec', action), libexec_dir
    end

    # Move the helper scripts into place
    helpers_dir = File.join(libexec_dir, 'helpers')
    FileUtils.mkdir_p helpers_dir
    [
      'aws-machine-type-definitions.sh',
      'azure-machine-type-definitions.sh',
      'basic-machine-type-definitions.sh'
    ].each do |script|
      copy File.join('libexec/helpers', script), helpers_dir
    end
  end
end
