#!/bin/bash
if which yum &>/dev/null; then
  CENTOS_VER=$(rpm --eval '%{centos_ver}')
  if [[ $CENTOS_VER == 8 ]] ; then
    cd "$(dirname "$0")"
    mkdir -p pkg

    rpmbuild --rebuild apg-2.3.0b-24.el7.src.rpm
    mv $HOME/rpmbuild/RPMS/*/apg-2.3.0b-*.rpm pkg
  else
    echo "$0: not required/supported on CentOS 7"
  fi
elif [ -f /etc/lsb-release ]; then
  cd "$(dirname "$0")"
  mkdir -p pkg
  cd pkg
  wget https://downloads.sourceforge.net/project/virtualgl/2.6.3/virtualgl_2.6.3_amd64.deb
else
  echo "$0: unable to determine distro"
fi
