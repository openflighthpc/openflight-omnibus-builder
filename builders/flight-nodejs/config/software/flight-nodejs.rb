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
name 'nodejs'
default_version '0.0.0'

source url: "https://nodejs.org/dist/v#{version}/node-v#{version}-linux-x64.tar.gz"

version '12.16.1' do
  source sha256: 'b2d9787da97d6c0d5cbf24c69fdbbf376b19089f921432c5a61aa323bc070bea'
end

version '12.16.3' do
  source sha256: '66518c31ea7735ae5a0bb8ea27edfee846702dbdc708fea6ad4a308d43ef5652'
end

license 'MIT'
license_file 'LICENSE'
skip_transitive_dependency_licensing true

relative_path "node-v#{version}-linux-x64"

build do
  block do
    Dir.glob(File.join(project_dir, '*')).each do |path|
      FileUtils.cp_r path, install_dir
    end
  end
end
