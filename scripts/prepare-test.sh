#!/bin/bash
if [ "$UID" != "0" ]; then
  echo "$0: must execute as root"
  exit 1
fi
if [ -f /etc/redhat-release ]; then
  if grep -q 'release 7' /etc/redhat-release; then
    DIST=7
  elif grep -q 'release 8' /etc/redhat-release; then
    DIST=8
  else
    echo "$0: unable to determine release"
    exit 1
  fi
  yum install -y epel-release
  yum install -y -e0 https://repo.openflighthpc.org/pub/centos/$DIST/openflighthpc-release-latest.noarch.rpm
  yum makecache
elif [ -f /etc/debian_version ]; then
  DIST="$(lsb_release -cs)"
  apt-key adv --fetch-keys https://repo.openflighthpc.org/openflighthpc-archive-key.asc
  apt-add-repository "deb https://repo.openflighthpc.org/openflight/ubuntu bionic main"
  apt-add-repository "deb https://repo.openflighthpc.org/openflight-dev/ubuntu bionic main"
else
  echo "$0: unable to determine distro"
fi
