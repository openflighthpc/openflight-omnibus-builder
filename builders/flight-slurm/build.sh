#!/bin/bash
VERSION="slurm-19.05.5"
REPO="https://github.com/openflighthpc/slurm"
DIRECTORY="flight-${VERSION}"
TARBALL="${DIRECTORY}.tar.bz2"

cd "$(dirname "$0")"

# Install dependencies
sudo yum groupinstall -y "Development Tools"
sudo yum install -y epel-release
sudo yum install -y munge-devel munge-libs \
     pam-devel readline-devel perl-devel lua-devel \
     hwloc-devel numactl-devel pmix-devel hdf5-devel \
     lz4-devel freeipmi-devel rrdtool-devel gtk2-devel \
     libcurl-devel libssh2-devel mariadb-devel man2html

# Create tarball
git clone $REPO --branch $VERSION --depth 1 --single-branch $DIRECTORY
tar --exclude='.git' -cvjSf $TARBALL $DIRECTORY

# Build RPMs
rpmbuild --define '_prefix /opt/flight/opt/slurm' \
         --define '_slurm_sysconfdir %{_prefix}/etc' \
         --define '_defaultdocdir %{_prefix}/doc' \
         --define '_localstatedir %{_prefix}/var' \
         --define '_sharedstatedir %{_prefix}/var/lib' \
         -ta $TARBALL \
         --with hwloc \
         --with mysql \
         --with hdf5 \
         --with lua \
         --with numa \
         --with x11 \
         --without debug \
         --with pmix

mkdir -p pkg
mv $HOME/rpmbuild/RPMS/*/flight-slurm-*.rpm pkg
