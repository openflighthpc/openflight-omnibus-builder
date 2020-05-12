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
    CENTOS_VER=$(rpm --eval '%{centos_ver}')

    yum install -y -e0 git rpm-build cmake
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
    source /etc/profile.d/rvm.sh
    rvm install 2.7
    gem install bundler:1.17.3
    gem install bundler:2.1.4
    usermod -a -G rvm vagrant

    yum install -y -e0 createrepo

    # required for building flight-desktop-restapi
    yum install -y -e0 pam-devel

    if [[ $CENTOS_VER == 8 ]] ; then
      yum install python3-pip python3-devel python2-devel
      pip3 install awscli --upgrade --user
    else
      yum install -y -e0 awscli
    fi
  elif which apt &>/dev/null; then
    apt-get update
    apt-get -y install ruby ruby-dev libffi-dev gcc make autoconf fakeroot

    # required for building flight-desktop-restapi
    apt-get -y install libpam0g-dev

    gem install bundler:1.17.3
    gem install bundler:2.1.4
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
fi

install_guest_additions_if_necessary
