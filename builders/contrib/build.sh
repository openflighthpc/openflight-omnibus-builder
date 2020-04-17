#!/bin/bash
if which yum &>/dev/null; then
  CENTOS_VER=$(rpm --eval '%{centos_ver}')
  if [[ $CENTOS_VER == 8 ]] ; then
    cd "$(dirname "$0")"
    mkdir -p pkg

    rpmbuild --rebuild apg-2.3.0b-24.el7.src.rpm
    mv $HOME/rpmbuild/RPMS/*/apg-2.3.0b-*.rpm pkg
    rpmbuild --rebuild python-websockify-0.8.0-13.el7.src.rpm
    mv $HOME/rpmbuild/RPMS/noarch/python3-websockify-0.8.0-*.rpm pkg
  else
    echo "Not required/supported on CentOS 7"
  fi
else
  echo "Not required/supported on CentOS 7"
fi
