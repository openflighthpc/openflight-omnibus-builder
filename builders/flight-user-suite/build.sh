#!/bin/bash
cd "$(dirname "$0")" 
rpmbuild -bb flight-user-suite.spec
mkdir -p pkg
mv $HOME/rpmbuild/RPMS/noarch/flight-user-suite-*.noarch.rpm pkg
