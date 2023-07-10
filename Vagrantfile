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
  vagrant_path = File.join(code_path, 'openflight-omnibus-builder')

  config.vm.define "centos7", primary: true do |build|
    build.vm.box = "bento/centos-7"
    build.vm.network "private_network", ip: "172.17.177.1"

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
  end

  config.vm.define "centos8", autostart: false do |build|
    build.vm.box = 'bento/centos-8'
    # Versions greater than this suffer from a "Ruby file operations on NFS
    # mounts" issue.  See https://bugzilla.redhat.com/show_bug.cgi?id=1840284.

    build.vbguest.auto_update = false

    # Centos 8 has now reached EOL and no longer receives development resources
    # from the official CentOS proect. We should be using the `vault.centos.org`
    # mirrors instead of the official ones.
    build.vbguest.installer_hooks[:before_install] =
      [
        'cd /etc/yum.repos.d/',
        "sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*",
        "sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*"
      ]

    build.vm.box_version = '202010.22.0'
    build.vm.provision "shell", path: "vagrant/provision.sh"
    build.vm.network "private_network", ip: "172.17.177.2"

    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
    build.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end
  end

  config.vm.define "centos8-test", autostart: false do |build|
    build.vm.box = 'bento/centos-8'
    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
  end

  config.vm.define 'centos9s', autostart: false do |build|
    build.vm.box = 'generic/centos9s'

    # These _might_ become necessary again in the future.
    # As of 27-04-2023, they are not.
    #
    #build.vbguest.auto_update = false
    #build.vbguest.installer_hooks[:before_start] = [
    #  "sudo dnf -y install libXmu libXext libXt libX11",
    #  #"sudo dnf -y upgrade --refresh",
    #  "sudo dnf -y install kernel-devel"
    #]

    build.vbguest.auto_update = false

    build.vm.provision "shell", path: "vagrant/provision.sh"
    build.vm.network "private_network", ip: "172.17.177.3"

    if File.directory?(vagrant_path)
      build.vm.synced_folder vagrant_path, "/vagrant"
    end

    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
  end

  config.vm.define 'ubuntu2204', autostart: false do |build|
    build.vm.box = 'ubuntu/jammy64'

    config.vbguest.auto_update = false

    build.vm.provision 'shell', path: 'vagrant/provision.sh'
    build.vm.network "private_network", ip: "172.17.177.4"

    if File.directory?(vagrant_path)
      build.vm.synced_folder vagrant_path, "/vagrant"
    end

    if File.directory?(code_path)
      build.vm.synced_folder code_path, "/code"
    end
  end
end
