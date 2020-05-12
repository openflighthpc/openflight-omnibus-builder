#!/bin/bash
cd "$(dirname "$0")" 
rpmbuild -bb mongodb-release.spec
mkdir -p pkg
mv $HOME/rpmbuild/RPMS/noarch/mongodb-release-*.noarch.rpm pkg
