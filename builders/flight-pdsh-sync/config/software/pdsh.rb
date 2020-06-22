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
name "pdsh"

license "GPLv2"
license_file "COPYING"
skip_transitive_dependency_licensing true

default_version "2.34"

version("2.34") do
  source sha256: "b47b3e4662736ef44b6fe86e3d380f95e591863e69163aa0592e9f9f618521e9"
end

source url: "https://github.com/chaos/pdsh/releases/download/pdsh-#{version}/pdsh-#{version}.tar.gz"

relative_path "pdsh-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  configure_options = ["--with-ssh",
                       "--with-genders",
                       "--with-opt-dir=#{install_dir}/embedded",
  ]
  configure(*configure_options, env: env)
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
