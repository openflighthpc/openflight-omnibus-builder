#==============================================================================
# Copyright (C) 2021-present Alces Flight Ltd.
#
# This file is part of Flight NodeJS
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
# For more information on Flight NodeJS, please visit:
# https://github.com/openflighthpc/openflight-omnibus-builder/builders/flight-nodejs
#===============================================================================

HEADER = <<~HEADER
#==============================================================================
# Copyright (C) 2021-present Alces Flight Ltd.
#
# This file is part of Flight NodeJS
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
# For more information on Flight NodeJS, please visit:
# https://github.com/openflighthpc/openflight-omnibus-builder/builders/flight-nodejs
#===============================================================================
HEADER

name 'flight-python'
default_version '0.0.0'

dependency 'python'
license 'EPL-2.0'
license_file 'LICENSE.txt'

build do
  # Check that flight-python has not been installed or previously built.
  # NOTE: this is done when the software file is loaded

  if %w(python3 python pip3 pip).any? {|f| File.exists?(File.join("/opt/flight/bin", f))}
    raise <<~ERROR
      flight-python can not be built when existing version has been installed!
      Please remove the system version before continuing
    ERROR
  end

  # Create the shims within /opt/flight/opt/python/bin
  block do
    FileUtils.mkdir_p File.join(install_dir, 'bin')
    ['pip', 'python'].each do |file|
      src = File.join(install_dir, "embedded/bin/#{file}3")
      [file, "#{file}3"].each do |bin|
        FileUtils.ln_sf src, File.join(install_dir, 'bin', bin)
      end
    end
  end
end
