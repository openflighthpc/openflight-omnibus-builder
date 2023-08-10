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
CODE_PATH = ENV['FLIGHT_CODE'] || "#{ENV['HOME']}/code"
VAGRANT_PATH = File.join(CODE_PATH, 'openflight-omnibus-builder')

# Set up reusable key for all nodes so we can `pdsh` builder commands.
# Requires `~/.ssh/openflight-omnibus-builder.key` key to exist.
SSH_PRV_KEY_PATH = File.expand_path('~/.ssh/openflight-omnibus-builder.key')
SSH_PUB_KEY_PATH = "#{SSH_PRV_KEY_PATH}.pub"
if !File.file?(SSH_PRV_KEY_PATH) || !File.file?(SSH_PUB_KEY_PATH)
  $stderr.puts <<-EOF
  You need to create a passwordless SSH key-pair and save them to
  ~/.ssh/openflight-omnibus-builder.key
  ~/.ssh/openflight-omnibus-builder.key.pub
  EOF
  exit 1
end

Vagrant.configure("2") do |config|

  # Insert openflight-omnibus-builder key into each node
  config.ssh.forward_agent = false
  config.ssh.insert_key = false
  config.ssh.private_key_path = [
    "~/.vagrant.d/insecure_private_key",
    SSH_PRV_KEY_PATH
  ].compact.select { |k| File.file?(File.expand_path(k)) }

  config.vm.provision 'shell', privileged: false do |s|
    if !SSH_PRV_KEY_PATH.nil? && !File.file?(SSH_PRV_KEY_PATH) || !File.file?(SSH_PUB_KEY_PATH)
      s.inline = <<-SHELL
        echo "No SSH key found. Things are broken, as this should have been caught earlier in the Vagrant process.
        exit 0
      SHELL
    else
      ssh_prv_key = File.read(SSH_PRV_KEY_PATH)
      ssh_pub_key = File.readlines(SSH_PUB_KEY_PATH).first.strip
      s.inline = <<-SHELL
        if grep -sq "#{ssh_pub_key}" /home/$USER/.ssh/authorized_keys; then
          echo "SSH keys already provisioned."
          exit 0;
        fi
        echo "Provisioning SSH key."
        mkdir -p /home/$USER/.ssh/
        touch /home/$USER/.ssh/authorized_keys
        echo "#{ssh_pub_key}" >> /home/$USER/.ssh/authorized_keys
        sed -i -s '/vagrant insecure public key/d' /home/$USER/.ssh/authorized_keys
        echo #{ssh_pub_key} > /home/$USER/.ssh/id_rsa.pub
        chmod 644 /home/$USER/.ssh/id_rsa.pub
        echo "#{ssh_prv_key}" > /home/$USER/.ssh/id_rsa
        chmod 600 /home/$USER/.ssh/id_rsa
        exit 0
      SHELL
    end
  end

  config.vm.define "centos7", primary: true do |build|
    build.vm.box = "bento/centos-7"
    build.vm.network "private_network", ip: "172.17.177.5"

    build.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end

    setup_shared_folders(build)

    build.vm.provision "shell", path: "vagrant/provision.sh"
  end

  config.vm.define "centos7-test", autostart: false do |build|
    build.vm.box = "bento/centos-7"

    build.vm.provision "shell" do |s|
      s.path = "vagrant/provision.sh"
      s.args = ["test"]
    end

    setup_shared_folders(build)
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

    setup_shared_folders(build)

    build.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end
  end

  config.vm.define "centos8-test", autostart: false do |build|
    build.vm.box = 'bento/centos-8'

    build.vm.provision "shell" do |s|
      s.path = "vagrant/provision.sh"
      s.args = ["test"]
    end

    setup_shared_folders(build)
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

    build.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end

    build.vbguest.auto_update = false

    build.vm.provision "shell", path: "vagrant/provision.sh"
    build.vm.network "private_network", ip: "172.17.177.3"

    setup_shared_folders(build)
  end

  config.vm.define 'centos9s-test', autostart: false do |build|
    build.vm.box = 'generic/centos9s'

    build.vbguest.auto_update = false

    build.vm.provision "shell" do |s|
      s.path = "vagrant/provision.sh"
      s.args = ["test"]
    end

    setup_shared_folders(build)
  end

  config.vm.define 'ubuntu2204', autostart: false do |build|
    build.vm.box = 'ubuntu/jammy64'

    config.vbguest.auto_update = false

    build.vm.provision 'shell', path: 'vagrant/provision.sh'
    build.vm.network "private_network", ip: "172.17.177.4"

    setup_shared_folders(build)
  end

  config.vm.define 'ubuntu2204-test', autostart: false do |build|
    build.vm.box = 'ubuntu/jammy64'

    build.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end

    config.vbguest.auto_update = false

    build.vm.provision "shell" do |s|
      s.path = "vagrant/provision.sh"
      s.args = ["test"]
    end

    setup_shared_folders(build)
  end
end

def setup_shared_folders(build)
  if File.directory?(VAGRANT_PATH)
    build.vm.synced_folder VAGRANT_PATH, "/vagrant"
  end

  if File.directory?(CODE_PATH)
    build.vm.synced_folder CODE_PATH, "/code"
  end
end
