#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
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
name 'flight-directory'
default_version '0.0.0'

source git: 'https://github.com/openflighthpc/flight-directory'

dependency 'flight-directory-requirements'

license 'EPL-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do
  mkdir File.expand_path("#{install_dir}/lib")

  delete 'directory/cli/src/test_*'
  delete 'directory/cli/src/conftest.py'
  delete 'directory/cli/src/appliance_cli'
  copy 'directory/cli/src', File.expand_path("#{install_dir}/lib/directory")

  delete 'share/appliance_cli/src/test*'
  delete 'share/appliance_cli/src/shared_fixtures.py'
  copy 'share/appliance_cli/src', File.expand_path("#{install_dir}/lib/appliance_cli")

  copy 'directory/libexec', File.expand_path("#{install_dir}/libexec")
  #move File.expand_path("#{install_dir}/lib/directory/directory"), File.expand_path("#{install_dir}/libexec")

  delete 'lib/pip-delete-this-directory.txt'

  appliance_config_py = "#{install_dir}/lib/appliance_cli/config.py"
  dir_config_py = "#{install_dir}/lib/directory/config.py"
  seds = [
    {
      file: appliance_config_py,
      find: "appliance_dir = .*",
      replace: "appliance_dir = '#{install_dir}'"
    },
    {
      file: appliance_config_py,
      find: "userware_root = .*",
      replace: "userware_root = '/opt/flight'"
    },
    {
      file: appliance_config_py,
      find: "'APPLIANCE_CONFIG': .*",
      replace: "'APPLIANCE_CONFIG': '/opt/flight/etc/directory/base.conf',"
    },
    {
      file: appliance_config_py,
      find: "'SANDBOX_HISTORY': .*",
      replace: "'SANDBOX_HISTORY': '/opt/flight/var/cache/directory/history.txt',"
    },
    {
      file: dir_config_py,
      find: "'DIRECTORY_USER_CONFIG': .*",
      replace: "'DIRECTORY_USER_CONFIG': '/opt/flight/etc/directory/user-ops.conf',"
    },
    {
      file: dir_config_py,
      find: "'DIRECTORY_RECORD': .*",
      replace: "'DIRECTORY_RECORD': '/opt/flight/var/log/directory/record.log',"
    },
    {
      file: dir_config_py,
      find: "'DIRECTORY_LOG': .*",
      replace: "'DIRECTORY_LOG': '/opt/flight/var/log/directory/access.log',"
    },
  ]

  seds.each do |h|
    command %(sed -i -e "s|#{h[:find]}|#{h[:replace]}|g" #{h[:file]})
  end

  hooks_dir = "/opt/flight/etc/directory/hooks"
  mkdir hooks_dir
  block do
    Dir.glob(File.join(File.dirname(__FILE__), '..', '..', 'dist', 'bin', '*')).each do |path|
      FileUtils.cp_r path, "#{install_dir}/bin"
      FileUtils.chmod(0700, File.join("#{install_dir}/bin", File.basename(path)))
    end

    Dir.glob(File.join(File.dirname(__FILE__), '..', '..', 'dist', 'hooks', '*')).each do |path|
      FileUtils.cp_r path, hooks_dir
      FileUtils.chmod(0700, File.join(hooks_dir, File.basename(path)))
    end
  end
end
