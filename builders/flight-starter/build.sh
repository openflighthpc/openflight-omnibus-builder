#!/bin/bash
cd "$(dirname "$0")"
d="$(pwd)"
mkdir -p pkg

NOW=2021.8
NEXT=2021.9
VERSION=${NOW}.0~rc2
TAG=$(echo "$VERSION" | sed "s/~/-/g")
REL=1

if [ -f /etc/redhat-release ]; then
  echo "Building RPM package..."
  cd rpm
  rpmbuild -bb flight-starter.spec \
           --define "_flight_pkg_version $VERSION" \
           --define "_flight_pkg_tag $TAG" \
           --define "_flight_pkg_rel $REL" \
           --define "_flight_pkg_now $NOW" \
           --define "_flight_pkg_next $NEXT"
  cd ..
  mv $HOME/rpmbuild/RPMS/noarch/flight-starter-*.noarch.rpm pkg
  mv $HOME/rpmbuild/RPMS/noarch/flight-plugin-*-starter-*.noarch.rpm pkg
elif [ -f /etc/lsb-release ]; then
  echo "Building DEB package..."

  mkdir -p $HOME/flight-starter

  pushd $HOME/flight-starter
  rm -rf ${VERSION}.tar.gz flight-starter-${VERSION}
  rm -rf \
     flight-starter_${VERSION}-${REL} \
     flight-starter-banner_${VERSION}-${REL} \
     flight-plugin-system-starter_${VERSION}-${REL} \
     flight-plugin-manual-starter_${VERSION}-${REL}
  mkdir -p flight-starter_${VERSION}-${REL}/DEBIAN
  mkdir -p flight-starter-banner_${VERSION}-${REL}/DEBIAN
  mkdir -p flight-plugin-system-starter_${VERSION}-${REL}/DEBIAN
  mkdir -p flight-plugin-manual-starter_${VERSION}-${REL}/DEBIAN
  sed -e "s/%VERSION%/$VERSION/g" \
      -e "s/%REL%/$REL/g" \
      $d/deb/control.tpl > \
      $HOME/flight-starter/flight-starter_${VERSION}-${REL}/DEBIAN/control
  sed -e "s/%VERSION%/$VERSION/g" \
      -e "s/%REL%/$REL/g" \
      $d/deb/flight-plugin-system-starter.control.tpl > \
      $HOME/flight-starter/flight-plugin-system-starter_${VERSION}-${REL}/DEBIAN/control
  cp $d/deb/flight-plugin-system-starter.postinst \
     $HOME/flight-starter/flight-plugin-system-starter_${VERSION}-${REL}/DEBIAN/postinst
     chmod 755 $HOME/flight-starter/flight-plugin-system-starter_${VERSION}-${REL}/DEBIAN/postinst
  cp $d/deb/flight-plugin-system-starter.postrm \
     $HOME/flight-starter/flight-plugin-system-starter_${VERSION}-${REL}/DEBIAN/postrm
     chmod 755 $HOME/flight-starter/flight-plugin-system-starter_${VERSION}-${REL}/DEBIAN/postrm

  sed -e "s/%VERSION%/$VERSION/g" \
      -e "s/%REL%/$REL/g" \
      $d/deb/flight-plugin-manual-starter.control.tpl > \
      $HOME/flight-starter/flight-plugin-manual-starter_${VERSION}-${REL}/DEBIAN/control
  sed -e "s/%VERSION%/$VERSION/g" \
      -e "s/%REL%/$REL/g" \
      -e "s/%NOW%/$NOW/g" \
      -e "s/%NEXT%/$NEXT/g" \
      $d/deb/flight-starter-banner.control.tpl > \
      $HOME/flight-starter/flight-starter-banner_${VERSION}-${REL}/DEBIAN/control

  wget https://github.com/openflighthpc/flight-starter/archive/${TAG}.tar.gz
  tar xzf ${TAG}.tar.gz
  mv flight-starter-${TAG}/dist/* flight-starter_${VERSION}-${REL}

  # flight-starter-banner
  for a in /opt/flight/etc/flight-starter.rc \
           /opt/flight/etc/flight-starter.cshrc \
           /opt/flight/etc/banner/banner.erb \
           /opt/flight/etc/banner/banner.txt \
           /opt/flight/etc/banner/banner.yml \
           /opt/flight/libexec/flight-starter/banner; do
    mkdir -p flight-starter-banner_${VERSION}-${REL}/$(dirname "$a")
    mv flight-starter_${VERSION}-${REL}/$a flight-starter-banner_${VERSION}-${REL}/$a
  done

  # flight-plugin-system-starter
  mv flight-starter_${VERSION}-${REL}/etc \
     flight-plugin-system-starter_${VERSION}-${REL}/etc
  # Relocate login script for tcsh - refs:
  # https://github.com/openflighthpc/openflight-omnibus-builder/issues/29
  mkdir -p flight-plugin-system-starter_${VERSION}-${REL}/etc/csh/login.d
  mv flight-plugin-system-starter_${VERSION}-${REL}/etc/profile.d/zz-flight-starter.csh \
     flight-plugin-system-starter_${VERSION}-${REL}/etc/csh/login.d

  # flight-plugin-manual-starter
  mkdir -p flight-plugin-manual-starter_${VERSION}-${REL}/opt/flight/etc/plugin/xdg
  mkdir -p flight-plugin-manual-starter_${VERSION}-${REL}/opt/flight/etc/plugin/profile.d
  mkdir -p flight-plugin-manual-starter_${VERSION}-${REL}/opt/flight/etc/plugin/csh/login.d
  cp -v flight-plugin-system-starter_${VERSION}-${REL}/etc/profile.d/zz-flight-starter.sh \
     flight-plugin-manual-starter_${VERSION}-${REL}/opt/flight/etc/plugin/profile.d/flight-starter.sh
  cp -v flight-plugin-system-starter_${VERSION}-${REL}/etc/csh/login.d/zz-flight-starter.csh \
     flight-plugin-manual-starter_${VERSION}-${REL}/opt/flight/etc/plugin/csh/login.d/flight-starter.csh
  cp -v flight-plugin-system-starter_${VERSION}-${REL}/etc/xdg/* \
     flight-plugin-manual-starter_${VERSION}-${REL}/opt/flight/etc/plugin/xdg

  fakeroot dpkg-deb --build flight-starter_${VERSION}-${REL}
  fakeroot dpkg-deb --build flight-starter-banner_${VERSION}-${REL}
  fakeroot dpkg-deb --build flight-plugin-system-starter_${VERSION}-${REL}
  fakeroot dpkg-deb --build flight-plugin-manual-starter_${VERSION}-${REL}
  popd

  mv $HOME/flight-starter/*.deb pkg
else
  echo "Couldn't determine type of package to build."
fi
