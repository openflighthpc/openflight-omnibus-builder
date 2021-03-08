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
Vagrant.configure("2") do |config|
  code_path = ENV['FLIGHT_CODE'] || "#{ENV['HOME']}/code"

  config.vm.define "centos7", primary: true do |build|
    build.vm.box = "bento/centos-7"
    build.vm.provision "shell", path: "vagrant/provision.sh"
    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
  end

  config.vm.define "centos7-test", autostart: false do |build|
    build.vm.box = "bento/centos-7"
    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
    build.vm.network "forwarded_port", guest: 80, host: 7070
    build.vm.network "forwarded_port", guest: 443, host: 7443
  end

  config.vm.define "centos8", autostart: false do |build|
    build.vm.box = 'bento/centos-8'
    build.vm.provision "shell", path: "vagrant/provision.sh"
    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
  end

  config.vm.define "centos8-test", autostart: false do |build|
    build.vm.box = 'bento/centos-8'
    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
    build.vm.network "forwarded_port", guest: 80, host: 8070
    build.vm.network "forwarded_port", guest: 443, host: 8443
  end

  config.vm.define "ubuntu1804", autostart: false do |build|
    build.vm.box = 'ubuntu/bionic64'
    build.vm.provision "shell", path: "vagrant/provision.sh"
    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
  end

  config.vm.define "ubuntu1804-test", autostart: false do |build|
    build.vm.box = 'ubuntu/bionic64'
    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
    build.vm.network "forwarded_port", guest: 80, host: 9070
    build.vm.network "forwarded_port", guest: 443, host: 9443
  end

  config.vm.define "ubuntu2004", autostart: false do |build|
    build.vm.box = 'ubuntu/focal64'
    build.vm.provision "shell", path: "vagrant/provision.sh"
    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
  end

  config.vm.define "ubuntu2004-test", autostart: false do |build|
    build.vm.box = 'ubuntu/focal64'
    build.vm.provision "shell" do |s|
      s.path = "vagrant/provision.sh"
      s.args = ["test"]
    end
    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
    build.vm.network "forwarded_port", guest: 80, host: 10070
    build.vm.network "forwarded_port", guest: 443, host: 10443
  end
end
