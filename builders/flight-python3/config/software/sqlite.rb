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
name 'sqlite'
default_version '3.35.5'

major, minor, bug = version.split('.')
expanded_version = "#{major}#{minor.ljust(3, '0')}#{bug.ljust(3, '0')}"

# I know, this looks weird, but SQLite has a "public domain" license.
# According to SPDX the license type is "blessing".
# https://spdx.org/licenses/blessing.html
license 'blessing'
license_file 'tea/license.terms'

version("3.35.5") { source sha256: "f52b72a5c319c3e516ed7a92e123139a6e87af08a2dc43d7757724f6132e6db0" }

# NOTE: TBC if this link will continue working post 2021, it will be fine for now
source url: "https://sqlite.org/2021/sqlite-autoconf-#{expanded_version}.tar.gz"

relative_path "sqlite-autoconf-#{expanded_version}"

build do
  env = with_standard_compiler_flags(with_embedded_path())
  configure ' --enable-threadsafe --disable-readline',  env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
