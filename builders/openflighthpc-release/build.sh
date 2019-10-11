#!/bin/bash
cd "$(dirname "$0")" 
rpmbuild -bb openflighthpc-release.spec
mkdir -p pkg
mv $HOME/rpmbuild/RPMS/noarch/openflighthpc-release-*.noarch.rpm pkg
