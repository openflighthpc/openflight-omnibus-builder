#!/bin/bash
cd "$(dirname "$0")"
d="$(pwd)"
mkdir -p pkg

NOW=2020.2
NEXT=2020.3
VERSION=${NOW}.2
REL=1

if [ -f /etc/redhat-release ]; then
  echo "Building RPM package..."
  cd rpm
  rpmbuild -bb flight-starter.spec \
           --define "_flight_pkg_version $VERSION" \
           --define "_flight_pkg_rel $REL" \
           --define "_flight_pkg_now $NOW" \
           --define "_flight_pkg_next $NEXT"
  cd ..
  mv $HOME/rpmbuild/RPMS/noarch/flight-starter-*.noarch.rpm pkg
elif [ -f /etc/lsb-release ]; then
  echo "Building DEB package..."

  mkdir -p $HOME/flight-starter

  pushd $HOME/flight-starter
  rm -rf ${VERSION}.tar.gz flight-starter-${VERSION}
  rm -rf flight-starter_${VERSION}-1 flight-starter-banner_${VERSION}-1
  mkdir -p flight-starter_${VERSION}-1/DEBIAN
  mkdir -p flight-starter-banner_${VERSION}-1/DEBIAN
  sed -e "s/%VERSION%/$VERSION/g" \
      -e "s/%REL%/$REL/g" \
      $d/deb/control.tpl > \
      $HOME/flight-starter/flight-starter_${VERSION}-1/DEBIAN/control
  sed -e "s/%VERSION%/$VERSION/g" \
      -e "s/%REL%/$REL/g" \
      -e "s/%NOW%/$NOW/g" \
      -e "s/%NEXT%/$NEXT/g" \
      $d/deb/flight-starter-banner.control.tpl > \
      $HOME/flight-starter/flight-starter-banner_${VERSION}-1/DEBIAN/control

  wget https://github.com/openflighthpc/flight-starter/archive/${VERSION}.tar.gz
  tar xzf ${VERSION}.tar.gz
  mv flight-starter-${VERSION}/dist/* flight-starter_${VERSION}-1
  for a in /opt/flight/etc/flight-starter.rc \
           /opt/flight/etc/flight-starter.cshrc \
           /opt/flight/etc/banner/banner.erb \
           /opt/flight/etc/banner/banner.txt \
           /opt/flight/etc/banner/banner.yml \
           /opt/flight/libexec/flight-starter/banner; do
    mkdir -p flight-starter-banner_${VERSION}-1/$(dirname "$a")
    mv flight-starter_${VERSION}-1/$a flight-starter-banner_${VERSION}-1/$a
  done
  dpkg-deb --build flight-starter_${VERSION}-1
  dpkg-deb --build flight-starter-banner_${VERSION}-1
  popd

  mv $HOME/flight-starter/*.deb pkg
else
  echo "Couldn't determine type of package to build."
fi
