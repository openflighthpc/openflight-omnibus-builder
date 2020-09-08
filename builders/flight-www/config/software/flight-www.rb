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
name 'flight-www'
default_version '1.0.0'

dependency 'zlib'
dependency 'nginx'

license 'EPL-2.0'
license_file 'LICENSE.EPL-2.0'
skip_transitive_dependency_licensing true

build do
  etc_dir = File.expand_path(File.join(install_dir, '..', '..', 'etc', 'www'))
  block do
    tpl = File.read(
      File.expand_path(File.join(__FILE__, '../../../dist/nginx.conf.tpl'))
    )
    if ohai['platform_family'] == 'rhel'
      conf = tpl.sub('%GROUP%', '')
    else
      conf = tpl.sub('%GROUP%', 'nogroup')
    end
    File.write(File.join(build_dir, 'nginx.conf'), conf)
  end

  mkdir etc_dir
  copy File.join(build_dir, 'nginx.conf'), File.join(etc_dir, 'nginx.conf')
end
