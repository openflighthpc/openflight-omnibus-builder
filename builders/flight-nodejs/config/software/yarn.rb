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
name 'yarn'
default_version '0.0.0'

source url: "https://github.com/yarnpkg/yarn/releases/download/v#{version}/yarn-v#{version}.tar.gz"

version '1.22.4' do
  source sha256: 'bc5316aa110b2f564a71a3d6e235be55b98714660870c5b6b2d2d3f12587fb58'
end

version '1.22.17' do
  source sha256: '267982c61119a055ba2b23d9cf90b02d3d16c202c03cb0c3a53b9633eae37249'
end

license 'BSD-2-Clause'
license_file 'LICENSE'
skip_transitive_dependency_licensing true

relative_path "yarn-v#{version}"

build do
  block do
    Dir.glob(File.join(project_dir, '*')).each do |path|
      FileUtils.cp_r path, install_dir
    end
  end
end
