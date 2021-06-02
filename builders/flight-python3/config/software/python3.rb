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
name 'python3'
default_version '0.0.0'

license 'Python-2.0'
license_file 'LICENSE'

version("3.9.5") { source sha256: "e0fbd5b6e1ee242524430dee3c91baf4cbbaba4a72dd1674b90fda87b713c7ab" }

source url: "https://www.python.org/ftp/python/#{version}/Python-#{version}.tgz"

dependency "zlib"
dependency "openssl"
dependency 'ncurses'
dependency 'libffi'
dependency 'sqlite'

relative_path "Python-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path())

  # Exactly how python3 is compiled depends on the which *-devel
  # packages are installed on the build system. The openflight-omnibus-builder
  # installs various packages as part of the provisioning script (including zlib-devel).
  # At the time of writing, the build *appears* to have the required dependencies.
  # Caution should be taken when making changes to how the VM is provisioned.
  #
  # The './configure --help' output contains various option flags to control the
  # build. The --with-libs options *looks* to be the appropriate flag to force
  # python to compile with zlib and openssl, however it './configure'
  # to error (for reasons ¯\_(ツ)_/¯):
  #
  # ./configure --with-libs='libz'
  # ...
  # Fatal: You must get working getaddrinfo() function.
  #        or you can specify "--disable-ipv6".
  configure env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env

  # Python3 does not provide a mechanism to exclude readline from the dynamic link libraries
  # The majority of python applications are unlikely to require it, so it has been removed
  # Consider compiling 'readline' if required
  delete File.join(install_dir, "embedded/lib/python#{version.sub(/\.\d+\Z/, '')}/lib-dynload/readline.*")
end
