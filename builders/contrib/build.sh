#!/bin/bash
if which yum &>/dev/null; then
  CENTOS_VER=$(rpm --eval '%{centos_ver}')
  if [[ $CENTOS_VER == 8 ]] ; then
    cd "$(dirname "$0")"
    mkdir -p pkg

    rpmbuild --rebuild apg-2.3.0b-24.el7.src.rpm
    mv $HOME/rpmbuild/RPMS/*/apg-2.3.0b-*.rpm pkg

    # Grab xorg-x11-apps
    rm -f xorg-x11-apps-7.7-21.el8.x86_64.rpm
    wget http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/xorg-x11-apps-7.7-21.el8.x86_64.rpm
    x_expected=8f799cd2453e0737e4cf1027d237c5673df4f2b7bb75b2246bcbedf966f77f99
    x_actual=$(sha256sum xorg-x11-apps-7.7-21.el8.x86_64.rpm | cut -f1 -d ' ')
    if [ "$x_expected" == "$x_actual" ]; then
      mv -f xorg-x11-apps-7.7-21.el8.x86_64.rpm pkg/
    else
      cat <<-EOF
  The shasums of xog-x11-apps did not match!
  Expected: $x_expected
  Actual: $x_actual
EOF
    fi
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
