#!/bin/bash
cd "$(dirname "$0")" 
rpmbuild -bb flight-web-suite.spec
mkdir -p pkg
mv $HOME/rpmbuild/RPMS/noarch/flight-web-suite-*.noarch.rpm pkg
