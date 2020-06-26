#!/bin/bash
cd "$(dirname "$0")"
d="$(pwd)"
mkdir -p pkg

NAME=flight-service-systemd
VERSION=1.0.0
REL=1

if [ -f /etc/redhat-release ]; then
  echo "Building RPM package..."
  cd rpm
  rpmbuild -bb ${NAME}.spec \
           --define "_flight_pkg_version $VERSION" \
           --define "_flight_pkg_rel $REL"
  cd ..
  mv $HOME/rpmbuild/RPMS/noarch/${NAME}-*.noarch.rpm pkg
elif [ -f /etc/lsb-release ]; then
  echo "Building DEB package..."

  mkdir -p $HOME/${NAME}

  pushd $HOME/${NAME}
  rm -rf ${NAME}-${VERSION}
  mkdir -p ${NAME}-${VERSION}
  mkdir -p ${NAME}_${VERSION}-$REL/DEBIAN
  sed -e "s/%VERSION%/$VERSION/g" \
      -e "s/%REL%/$REL/g" \
      $d/deb/control.tpl > \
      $HOME/${NAME}/${NAME}_${VERSION}-$REL/DEBIAN/control

  pushd ${NAME}-${VERSION}-$REL
  wget https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/LICENSE.txt
  wget https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/${NAME}/dist/flight-service.service
  mkdir -p lib/systemd/system
  mv flight-service.service lib/systemd/system
  mkdir -p usr/share/doc/${NAME}
  mv LICENSE.txt usr/share/doc/${NAME}
  popd

  fakeroot dpkg-deb --build ${NAME}_${VERSION}-$REL
  popd

  mv $HOME/${NAME}/*.deb pkg
else
  echo "Couldn't determine type of package to build."
fi
