#!/bin/bash
cd "$(dirname "$0")"
d="$(pwd)"
mkdir -p pkg

build() {
  TYPE=$1
  NAME=flight-plugin-${TYPE}-${PLUGIN}
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
        $d/deb/$NAME.control.tpl > \
        $HOME/${NAME}/${NAME}_${VERSION}-$REL/DEBIAN/control

    pushd ${NAME}_${VERSION}-$REL
    wget https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/LICENSE.txt
    wget https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/flight-plugin-${PLUGIN}/dist/openflight-logrotate
    case $TYPE in
      system)
        mkdir -p etc/logrotate.d
        mv openflight-logrotate etc/logrotate.d/openflight
        ;;
      manual)
        mkdir -p opt/flight/etc/plugin/logrotate.d
        mv openflight-logrotate opt/flight/etc/plugin/logrotate.d/openflight
        ;;
      *)
        echo "Couldn't determine plugin type to build."
        ;;
    esac
    mkdir -p usr/share/doc/${NAME}
    mv LICENSE.txt usr/share/doc/${NAME}
    popd

    fakeroot dpkg-deb --build ${NAME}_${VERSION}-$REL
    popd

    mv $HOME/${NAME}/*.deb pkg
  else
    echo "Couldn't determine type of package to build."
  fi
}

PLUGIN=logrotate
VERSION=1.0.0
REL=1

build system
build manual
