#!/bin/bash
VERSION="slurm-17.11+bug_8073+rpmupdates"
REPO="https://github.com/openflighthpc/slurm"
DIRECTORY="flight-${VERSION}"
TARBALL="${DIRECTORY}.tar.bz2"

cd "$(dirname "$0")" 

# Install dependencies
sudo yum groupinstall -y "Development Tools"
sudo yum install -y mysql-devel munge-devel munge-libs 

# Create tarball
git clone $REPO --branch $VERSION --single-branch $DIRECTORY
tar --exclude='.git' -cvjSf $TARBALL $DIRECTORY

# Update RPM build configuration
if [ -e ~/.rpmmacros] ; then
    echo "Backing up existing rpmmacros file"
    mv -vf ~/.rpmmacros ~/.rpmmacros.omnibus-bup-$(date +%F_%H-%M)
fi
cp .rpmmacros ~/.rpmmacros

# Build RPMs
rpmbuild -ta $TARBALL
mkdir -p pkg
mv $HOME/rpmbuild/RPMS/*/flight-slurm-*.rpm pkg
