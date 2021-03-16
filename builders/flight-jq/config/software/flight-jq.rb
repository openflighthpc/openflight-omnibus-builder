#==============================================================================
# Copyright (C) 2021-present Alces Flight Ltd.
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

name "flight-jq"

license "MIT"
skip_transitive_dependency_licensing true

default_version "1.6"

version("1.6") { source sha256: "af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44" }

source url: "https://github.com/stedolan/jq/releases/download/jq-#{version}/jq-linux64"

relative_path "jq-#{version}"

build do
  copy 'jq-linux64', File.join(install_dir, 'bin/jq')
  block { FileUtils.chmod '+x', File.join(install_dir, 'bin/jq') }
end
