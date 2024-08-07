#!/bin/bash
cd "$(dirname "$0")"
d="$(pwd)"
mkdir -p pkg

NAME=flight-env-types
VERSION=1.0.9
TAG=$(echo "$VERSION" | sed "s/~/-/g")
REL=1

if [ -f /etc/redhat-release ]; then
  echo "Building RPM package..."
  cd rpm
  rm -f $HOME/rpmbuild/SOURCES/${VERSION}.tar.gz
  rpmbuild -bb ${NAME}.spec \
           --define "_flight_pkg_version $VERSION" \
           --define "_flight_pkg_tag $TAG" \
           --define "_flight_pkg_rel $REL"
  cd ..
  mv $HOME/rpmbuild/RPMS/noarch/${NAME}-*.noarch.rpm pkg
elif [ -f /etc/lsb-release ]; then
  echo "Building DEB package..."

  mkdir -p $HOME/${NAME}

  pushd $HOME/${NAME}
  rm -rf ${NAME}-${VERSION} ${VERSION}.tar.gz
  rm -rf ${NAME}_${VERSION}-${REL}
  wget https://github.com/openflighthpc/${NAME}/archive/${VERSION}.tar.gz
  tar xzf ${VERSION}.tar.gz
  mkdir -p ${NAME}_${VERSION}-$REL/DEBIAN
  sed -e "s/%VERSION%/$VERSION/g" \
      -e "s/%REL%/$REL/g" \
      $d/deb/control.tpl > \
      $HOME/${NAME}/${NAME}_${VERSION}-$REL/DEBIAN/control

  pushd ${NAME}_${VERSION}-$REL
  rm -f ../${NAME}-${VERSION}/*.md
  mkdir -p usr/share/doc/${NAME}
  mv ../${NAME}-${VERSION}/LICENSE.txt usr/share/doc/${NAME}
  mkdir -p opt/flight/usr/lib/env/types
  mv ../${NAME}-${VERSION}/* opt/flight/usr/lib/env/types
  popd

  fakeroot dpkg-deb --build ${NAME}_${VERSION}-$REL
  popd

  mv $HOME/${NAME}/*.deb pkg
else
  echo "Couldn't determine type of package to build."
fi
