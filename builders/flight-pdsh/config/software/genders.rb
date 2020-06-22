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
name "genders"

license "GPLv2"
license_file "COPYING"
skip_transitive_dependency_licensing true

default_version "1.27.3"

version("1.27.3") do
  source sha256: "c176045a7dd125313d44abcb7968ded61826028fe906028a2967442426229894"
end

dashed_version = version.gsub(/\./, '-')
source url: "https://github.com/chaos/genders/archive/genders-#{dashed_version}.tar.gz"

relative_path "genders-genders-#{dashed_version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  configure_options = [
    "--with-java-extensions=no",
    "--with-perl-extensions=no",
    "--with-python-extensions=no",
    "--with-genders-file=/opt/flight/etc/genders",
  ]
  configure(*configure_options, env: env)
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end

