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
name 'flight-nodejs'
default_version '0.0.0'

dependency 'nodejs'
dependency 'yarn'

license 'EPL-2.0'
license_file 'LICENSE.txt'

Dir.mktmpdir do |tmpdir|
  source path: tmpdir
end

build do
  block do
    FileUtils.mkdir_p '/opt/flight/bin'
    Dir.glob(File.join(File.dirname(__FILE__), '..', '..', 'dist', 'bin', '*')).each do |path|
      FileUtils.cp_r path, '/opt/flight/bin'
      FileUtils.chmod(0755, File.join('/opt/flight/bin', File.basename(path)))
    end
  end
end
