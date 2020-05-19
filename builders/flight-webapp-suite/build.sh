#!/bin/bash
cd "$(dirname "$0")" 
rpmbuild -bb flight-webapp-suite.spec
mkdir -p pkg
mv $HOME/rpmbuild/RPMS/noarch/flight-webapp-suite-*.noarch.rpm pkg
