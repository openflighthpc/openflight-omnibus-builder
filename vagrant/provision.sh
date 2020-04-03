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

if [ "$1" != "test" ]; then
  if which yum &>/dev/null; then
    yum install -y -e0 git rpm-build cmake
    gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    source /etc/profile.d/rvm.sh
    rvm install 2.6
    gem install bundler:1.17.2
    usermod -a -G rvm vagrant

    # For libpcap compile (flight-metal)
    yum install -y -e0 flex

    yum install -y -e0 createrepo awscli

    # Install nvm so that we can install nodejs so that we can build
    # flight-desktop-client.
    # nvm is intended to be installed per-user not globally.
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | sudo -u vagrant bash
    sudo -i -u vagrant nvm install 12.16.1

    # Install yarn.
    curl --silent --show-error --location https://rpm.nodesource.com/setup_10.x | bash -
    curl --silent --show-error --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
    rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
    yum install -y yarn

  elif which apt &>/dev/null; then
    apt update
    apt -y install ruby ruby-dev libffi-dev gcc make autoconf fakeroot
    gem install bundler -v '< 2'
  fi

  mkdir /opt/flight
  chown vagrant /opt/flight
  hn=$(hostname -s)
  if [ "$hostname" != "localhost" ]; then
    hostname openflight-builder-${hn}
  else
    hostname openflight-builder
  fi
  hostname -s > /etc/hostname
fi

install_guest_additions_if_necessary
