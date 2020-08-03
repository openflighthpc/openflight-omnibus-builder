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
    cp $d/deb/$NAME.postinst \
       $HOME/${NAME}/${NAME}_${VERSION}-$REL/DEBIAN/postinst
    chmod 755 $HOME/${NAME}/${NAME}_${VERSION}-$REL/DEBIAN/postinst
    cp $d/deb/$NAME.postrm \
       $HOME/${NAME}/${NAME}_${VERSION}-$REL/DEBIAN/postrm
    chmod 755 $HOME/${NAME}/${NAME}_${VERSION}-$REL/DEBIAN/postrm

    pushd ${NAME}_${VERSION}-$REL
    wget https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/LICENSE.txt
    for a in crontab-generator crontab.reboot crontab-generator.cron.hourly.tpl crontab.schedule.tpl; do
      wget https://raw.githubusercontent.com/openflighthpc/openflight-omnibus-builder/master/builders/flight-plugin-${PLUGIN}/dist/$a
    done

    case $TYPE in
      manual)
        mkdir -p opt/flight/libexec/cron
        mv crontab-generator opt/flight/libexec/cron
        chmod 750 opt/flight/libexec/cron/crontab-generator

        mkdir -p opt/flight/etc/cron.d
        mv crontab.reboot opt/flight/etc/cron.d/openflight-reboot
        mkdir -p opt/flight/etc/cron/reboot

        for a in hourly daily weekly monthly; do
          mkdir -p opt/flight/etc/cron/$a
          mkdir -p opt/flight/etc/plugin/cron.$a
          sed -e "s/%SCHEDULE%/$a/g" crontab.schedule.tpl > opt/flight/etc/plugin/cron.$a/openflight-$a
        done
        rm -f crontab.schedule.tpl

        mkdir -p opt/flight/etc/plugin/cron.d
        sed -e 's,%TARGET%,/opt/flight/etc/plugin/cron.d/openflight,g' crontab-generator.cron.hourly.tpl > opt/flight/etc/cron/hourly/crontab-generator
        chmod 750 opt/flight/etc/cron/hourly/crontab-generator
        rm -f crontab-generator.cron.hourly.tpl
        ;;
      system)
        mkdir -p opt/flight/libexec/cron
        mv crontab-generator opt/flight/libexec/cron
        chmod 750 opt/flight/libexec/cron/crontab-generator

        mkdir -p opt/flight/etc/cron.d
        mv crontab.reboot opt/flight/etc/cron.d/openflight-reboot
        mkdir -p opt/flight/etc/cron/reboot

        for a in hourly daily weekly monthly; do
          mkdir -p opt/flight/etc/cron/$a
          mkdir -p etc/cron.$a
          sed -e "s/%SCHEDULE%/$a/g" crontab.schedule.tpl > etc/cron.$a/openflight-$a
        done
        rm -f crontab.schedule.tpl

        sed -e 's,%TARGET%,/etc/cron.d/openflight,g' crontab-generator.cron.hourly.tpl > opt/flight/etc/cron/hourly/crontab-generator
        chmod 750 opt/flight/etc/cron/hourly/crontab-generator
        rm -f crontab-generator.cron.hourly.tpl
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

PLUGIN=cron
VERSION=1.0.0
REL=2

build system
build manual
