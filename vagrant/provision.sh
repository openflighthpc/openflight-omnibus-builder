#!/bin/bash
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
install_guest_additions_if_necessary() {
  if ! lsmod | grep -q 'vboxsf '; then
    if which apt &>/dev/null; then
      apt update
      apt -y install virtualbox-guest-dkms
      cat <<EOF 1>&2

***********************************
     GUEST ADDITIONS INSTALLED
***********************************

This machine will now be shutdown. Please "vagrant up" this machine
again to ensure that shared folders are correctly mounted.

EOF
      shutdown -h now
    else
      cat <<EOF 1>&2

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   GUEST ADDITIONS NOT INSTALLED
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

This machine does not have guest additions.

Shared folders will not be correctly mounted.

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

EOF
    fi
  fi
}

install_rvm() {
    if ! gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB; then
      command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
      command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
    fi
    if ! curl -sSL https://get.rvm.io | bash -s stable; then
      if ! gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB; then
        command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
        command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
      fi
      curl -sSL https://get.rvm.io | bash -s stable
      if [ $? -gt 0 ]; then
        cat <<EOF 1>&2

!!!!!!!!!!!!!!!!!!!!!!!
   RVM NOT INSTALLED
!!!!!!!!!!!!!!!!!!!!!!!

FSR, unable to install RVM. :-(

EOF
        exit 1
      fi
    fi
}

install_go() {
  # Flight File Manager API has a reverse proxy written in Go. It requires Go
  # 1.22 to be installed.

  # Remove any previous Go installation
  rm -rf /usr/local/go

  # Fetch Go 1.22 release
  cd /tmp
  wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz

  # Extract Go 1.22 to /usr/local
  tar -C /usr/local -xzf /tmp/go1.22.2.linux-amd64.tar.gz

  # Include Go binary in PATH
  echo 'export PATH=$PATH:/usr/local/go/bin' >>/home/vagrant/.bash_profile
}

install_ruby_and_bundler() {
  # Only checking for Ruby 2.7's existence in CentOS 9/Ubuntu 22 because it's a bit more
  # involved to install it there than just `rvm install 2.7`

  if which yum &>/dev/null; then
    CENTOS_VER=$(rpm --eval '%{centos_ver}')
    if [[ $CENTOS_VER == 9 ]] && [[ $(rvm list) != *ruby-2.7.* ]] ; then
      dnf install perl
      cd /tmp
      wget https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1t/openssl-1.1.1t.tar.gz
      tar -xvxf /tmp/openssl-1.1.1t.tar.gz
      cd /tmp/openssl-1.1.1t/
      ./config --prefix=/opt/openssl-1.1.1t --openssldir=/opt/openssl-1.1.1t shared zlib
      make; make test; make install
      rm -rf /opt/openssl-1.1.1t/certs
      ln -s /etc/ssl/certs /opt/openssl-1.1.1t
      wget http://curl.haxx.se/ca/cacert.pem -O /tmp/cacert.pem
      mv /tmp/cacert.pem /home/vagrant/cacert.pem
      export SSL_CERT_FILE=/home/vagrant/cacert.pem
      echo 'export SSL_CERT_FILE=/home/vagrant/cacert.pem' >>/home/vagrant/.bash_profile
      rvm install 2.7 --with-openssl-dir=/opt/openssl-1.1.1t/
    else
      rvm install 2.7
    fi
  elif which apt &>/dev/null; then
    if [[ $(openssl version -v) != "OpenSSL 1*" ]] ; then
      apt-get install make
      cd /tmp
      wget https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1t/openssl-1.1.1t.tar.gz
      tar -xvxf /tmp/openssl-1.1.1t.tar.gz
      cd /tmp/openssl-1.1.1t/
      ./config --prefix=/opt/openssl-1.1.1t --openssldir=/opt/openssl-1.1.1t shared zlib
      make; make test; make install
      rm -rf /opt/openssl-1.1.1t/certs
      ln -s /etc/ssl/certs /opt/openssl-1.1.1t
      wget http://curl.haxx.se/ca/cacert.pem -O /tmp/cacert.pem
      mv /tmp/cacert.pem /home/vagrant/cacert.pem
      export SSL_CERT_FILE=/home/vagrant/cacert.pem
      echo 'export SSL_CERT_FILE=/home/vagrant/cacert.pem' >>/home/vagrant/.bash_profile
      rvm install 2.7 --with-openssl-dir=/opt/openssl-1.1.1t/
    fi
  fi

  gem install bundler:1.17.3
  gem install bundler:2.1.4
  usermod -a -G rvm vagrant
}

if [ "$1" != "test" ]; then
  if which yum &>/dev/null; then
    CENTOS_VER=$(rpm --eval '%{centos_ver}')

    if [[ $CENTOS_VER == 8 ]] && ! dnf makecache ; then
      # Centos 8 has now reached EOL and no longer receives development resources
      # from the official CentOS proect. We should be using the `vault.centos.org`
      # mirrors instead of the official ones.
      sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
      sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
    fi

    yum install -y -e0 git rpm-build cmake wget
    install_rvm
    source /etc/profile.d/rvm.sh
    install_ruby_and_bundler

    # required for building genders as part of flight-pdsh
    yum install -y -e0 flex

    yum install -y -e0 createrepo

    # required for building flight-desktop-restapi
    yum install -y -e0 pam-devel

    # required for building flight-certbot
    yum install -y -e0 python3-pip
    su vagrant -c 'pip3 install pipenv --user'

    if [[ $CENTOS_VER == 8 ]] || [[ $CENTOS_VER == 9 ]]; then
      yum install -y python3-devel python2-devel
      su vagrant -c 'pip3 install awscli --upgrade --user'
    else
      yum install -y -e0 awscli

      # NOTE: The default centos7 box does not have it's locale setup correctly
      #       This causes python3 CLI application (aka pipenv) to break in weird and
      #       wonderful ways. Reinstalling glibc-common fixes this issue
      #
      #       This is a bug in the individual boxes, not the builder/pipenv. Doing
      #       something similar for the other distros may or may not be required
      yum reinstall -y -e0 glibc-common
    fi
  elif which apt &>/dev/null; then
    apt-get update
    apt-get -y install ruby ruby-dev libffi-dev gcc make autoconf fakeroot awscli dpkg-dev libz-dev wget

    apt-get -y install gnupg2
    install_rvm
    source /etc/profile.d/rvm.sh
    install_ruby_and_bundler

    # required for building flight-desktop-restapi
    apt-get -y install libpam0g-dev

    # required for building flight-directory
    apt-get -y install libssl-dev

    # required for building genders as part of flight-pdsh
    apt-get -y install flex byacc

    # required for building flight-certbot
    apt-get -y install python3-pip
    su vagrant -c 'pip3 install pipenv --user'
  fi

  mkdir /opt/flight
  chown vagrant /opt/flight
  hn=$(hostname -s)
  if [ "$hn" != "localhost" ]; then
    hostname openflight-builder-${hn}
  else
    hostname openflight-builder
  fi
  hostname -s > /etc/hostname

  install_go

  cd /opt
  git clone https://github.com/openflighthpc/openflight-repo
  cd openflight-repo
  bundle install --path=vendor
  cat <<'EOF' >> /etc/profile.d/openflight-repo.sh
  repo() {
    /vagrant/scripts/repo "$@"
  }
EOF

fi


install_guest_additions_if_necessary
