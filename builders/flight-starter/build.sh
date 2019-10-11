#!/bin/bash
cd "$(dirname "$0")" 
rpmbuild -bb flight-starter.spec
mkdir -p pkg
mv $HOME/rpmbuild/RPMS/noarch/flight-starter-*.noarch.rpm pkg
