#!/bin/bash
REPO="https://github.com/openflighthpc/slurm"
TARGET="$(cd "$(dirname "$0")" && pwd)/pkg"

if [ "$1" == "--non-flight" ]; then
  nonflight=true
  shift
fi

if [ -z "$1" ]; then
  cat <<EOF
Usage: $0 [--non-flight] <version|'latest'>

Specify <version> to build:

  17.11
  18.08
  19.05
  20.02
  20.11
  21.08
  22.05
  23.02 (latest)
EOF
  exit 1
fi

VERSION=$1
case $VERSION in
  17.11)
    if [ -z "$nonflight" ]; then
      TAG="flight-slurm-17-11-13-2-flight2"
      REL="flight-slurm-17.11.13-2.flight2"
    else
      TAG="slurm-17-11-13-2-flight1"
      REL="slurm-17.11.13-2.flight1"
    fi
    libssh2=true
    ;;
  18.08)
    if [ -z "$nonflight" ]; then
      TAG="flight-slurm-18-08-9-1-flight2"
      REL="flight-slurm-18.08.9.flight2"
    else
      TAG="slurm-18-08-9-1-flight1"
      REL="slurm-18.08.9.flight1"
    fi
    libssh2=true
    ;;
  19.05)
    if [ -z "$nonflight" ]; then
      TAG="flight-slurm-19-05-7-1-flight1"
      REL="flight-slurm-19.05.7.flight1"
    else
      TAG="slurm-19-05-7-1-flight1"
      REL="slurm-19.05.7.flight1"
    fi
    ;;
  20.02)
    if [ -z "$nonflight" ]; then
      TAG="flight-slurm-20-02-3-1-flight3"
      REL="flight-slurm-20.02.3.flight3"
    else
      TAG="slurm-20-02-3-1-flight3"
      REL="slurm-20.02.3.flight3"
    fi
    ;;
  20.11)
    BUILD_FLAGS=(--with slurmrestd -D "_with_nvml --with-nvml=/usr/local/cuda-11.7")
    BUILD_DEPS="json-c-devel http-parser-devel jansson-devel doxygen"
    if [ -z "$nonflight" ]; then
      TAG="flight-slurm-20-11-7-1-flight1"
      REL="flight-slurm-20.11.7.flight1"
    else
      TAG="slurm-20-11-7-1-flight1"
      REL="slurm-20.11.7.flight1"
    fi
    libjwt=true
    nvml=true
    ;;
  21.08)
    BUILD_FLAGS=(--with slurmrestd -D "_with_nvml --with-nvml=/usr/local/cuda-11.7")
    BUILD_DEPS="json-c-devel http-parser-devel jansson-devel doxygen"
    if [ -z "$nonflight" ]; then
      TAG="flight-slurm-21-08-8-1-flight1"
      REL="flight-slurm-21.08.8.flight1"
    else
      TAG="slurm-21-08-8-1-flight1"
      REL="slurm-21.08.8.flight1"
    fi
    libjwt=true
    nvml=true
    ;;
  22.05)
    BUILD_FLAGS=(--with slurmrestd -D "_with_nvml --with-nvml=/usr/local/cuda-11.7")
    BUILD_DEPS="json-c-devel http-parser-devel jansson-devel doxygen"
    if [ -z "$nonflight" ]; then
      TAG="flight-slurm-22-05-6-1-flight1"
      REL="flight-slurm-22.05.6.flight1"
    else
      TAG="slurm-22-05-6-1-flight1"
      REL="slurm-22.05.6.flight1"
    fi
    libjwt=true
    pmix=true
    nvml=true
    ;;
  23.02|latest)
    BUILD_FLAGS=(--with slurmrestd -D "_with_nvml --with-nvml=/usr/local/cuda-11.7")
    BUILD_DEPS="json-c-devel http-parser-devel jansson-devel doxygen"
    if [ -z "$nonflight" ]; then
      TAG="flight-slurm-23-02-1-1-flight1"
      REL="flight-slurm-23.02.1.flight1"
    else
      TAG="slurm-23-02-1-1-flight1"
      REL="slurm-23.02.1.flight1"
    fi
    libjwt=true
    pmix=true
    nvml=true
    ;;
  *)
    echo "$0: unrecognized Slurm version: $VERSION"
    exit 1
  ;;
esac

mkdir -p $HOME/flight-slurm
cd $HOME/flight-slurm

if grep -q 'release 8' /etc/redhat-release; then
  distro="rhel8"
  case $VERSION in
    17.11|18.08)
      echo "$0: Slurm version not currently available for EL8: $VERSION"
      exit 1
    ;;
  esac
else
  distro="rhel7"
fi

# Install dependencies
sudo yum groupinstall -y "Development Tools"
sudo yum install -y epel-release
if [ "$distro" == "rhel7" ]; then
  sudo yum install -y munge-devel munge-libs pam-devel \
       readline-devel perl-devel lua-devel hwloc-devel \
       numactl-devel hdf5-devel lz4-devel freeipmi-devel \
       rrdtool-devel gtk2-devel libcurl-devel mariadb-devel \
       man2html python2 python3 $BUILD_DEPS
  if [ "$libssh2" ]; then
    # This is needed for Slurm 18.08 or 17.11.
    sudo yum install -y libssh2-devel
  fi
  if [ "$libjwt" ]; then
    if ! rpm -qa libjwt-devel | grep -q '^libjwt-devel-1.12.1'; then
      # This is needed for Slurm 20.11+
      rpmbuild --rebuild ${TARGET}/../dist/libjwt-1.12.1-0.el7.src.rpm
      sudo yum install -y ~/rpmbuild/RPMS/x86_64/libjwt-devel-1.12.1-0.el7.x86_64.rpm \
           ~/rpmbuild/RPMS/x86_64/libjwt-1.12.1-0.el7.x86_64.rpm
      build_libjwt=true
    fi
  fi
  if [ "$pmix" ]; then
    if ! rpm -qa pmix-devel | grep -q '^pmix-devel-4.1.2'; then
      # This is needed for Slurm 22.05+
      # Build deps:
      sudo yum install -y epel-rpm-macros pandoc
      # Build it:
      rpmbuild --rebuild ${TARGET}/../dist/pmix-4.1.2-2.fc37.src.rpm
      sudo yum install -y ~/rpmbuild/RPMS/x86_64/pmix-4.1.2-2.el7.x86_64.rpm \
           ~/rpmbuild/RPMS/x86_64/pmix-devel-4.1.2-2.el7.x86_64.rpm \
           ~/rpmbuild/RPMS/x86_64/pmix-tools-4.1.2-2.el7.x86_64.rpm
      built_pmix=true
    fi
  else
    sudo yum install -y pmix-devel
  fi
  if [ "$nvml" ]; then
    sudo yum install -y https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-nvml-devel-11-7-11.7.50-1.x86_64.rpm
  fi
elif [ "$distro" == "rhel8" ]; then
  sudo yum config-manager --set-enabled powertools
  sudo yum config-manager --set-enabled PowerTools
  sudo yum install -y munge-devel munge-libs pam-devel \
       readline-devel perl-devel lua-devel hwloc-devel \
       numactl-devel hdf5-devel lz4-devel freeipmi-devel \
       rrdtool-devel gtk2-devel libcurl-devel mariadb-devel \
       man2html python3 python2 $BUILD_DEPS
  sudo yum install -y pmix-devel
  if ! rpm -qa pmix-devel | grep -q '^pmix-devel'; then
    if [ ! -f pmix-2.1.1-1.el8.src.rpm ]; then
      wget http://vault.centos.org/8.1.1911/AppStream/Source/SPackages/pmix-2.1.1-1.el8.src.rpm
    fi
    sudo yum install -y environment-modules libevent-devel
    rpmbuild --rebuild pmix-2.1.1-1.el8.src.rpm
    sudo yum install -y ~/rpmbuild/RPMS/x86_64/pmix-devel-2.1.1-1.el8.x86_64.rpm
  fi

  if [ "$libssh2" ]; then
    # This is needed for Slurm 18.08 or 17.11.
    if ! rpm -qa libssh2-devel | grep -q '^libssh2-devel'; then
      if [ ! -f libssh2-1.8.0-3.el7.src.rpm ]; then
        wget http://vault.centos.org/7.7.1908/os/Source/SPackages/libssh2-1.8.0-3.el7.src.rpm
      fi
      rpmbuild --rebuild libssh2-1.8.0-3.el7.src.rpm
      sudo yum install -y ~/rpmbuild/RPMS/x86_64/libssh2-1.8.0-3.el8.x86_64.rpm ~/rpmbuild/RPMS/x86_64/libssh2-devel-1.8.0-3.el8.x86_64.rpm
    fi
  fi

  if [ "$libjwt" ]; then
    # This is needed for Slurm 20.11.
    sudo yum install -y check-devel
    rpmbuild --rebuild ${TARGET}/../dist/libjwt-1.12.1-0.el7.src.rpm
    sudo yum install -y ~/rpmbuild/RPMS/x86_64/libjwt-devel-1.12.1-0.el8.x86_64.rpm \
         ~/rpmbuild/RPMS/x86_64/libjwt-1.12.1-0.el8.x86_64.rpm
  fi

  if [ "$nvml" ]; then
    sudo yum install -y https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-nvml-devel-11-7-11.7.50-1.x86_64.rpm
  fi
fi

# Create tarball
if [ -d "$REL" ]; then
  if [ -d "$REL.old" ]; then
    rm -rf "$REL.old"
  fi
  mv $REL $REL.old
fi
git clone $REPO --branch $TAG --depth 1 --single-branch $REL

if [[ $distro == 'rhel8' ]] ; then
    ## Fix dlopen bug/error as explained here https://bugs.schedmd.com/show_bug.cgi?id=2443
    sed -i '1i%global _hardened_ldflags "-Wl,-z,lazy"' $REL/slurm.spec
    sed -i '1i%global _hardened_cflags "-Wl,-z,lazy"' $REL/slurm.spec
    sed -i '1i%undefine _hardened_build' $REL/slurm.spec
fi

tar --exclude='.git' -cjSf $REL.tar.bz2 $REL

mkdir -p "$TARGET"

# Build RPMs
if [ -z "$nonflight" ]; then
  rpmbuild --define '_prefix /opt/flight/opt/slurm' \
           --define '_slurm_sysconfdir %{_prefix}/etc' \
           --define '_defaultdocdir %{_prefix}/doc' \
           --define '_localstatedir %{_prefix}/var' \
           --define '_sharedstatedir %{_prefix}/var/lib' \
           -ta $REL.tar.bz2 \
           "${BUILD_FLAGS[@]}" \
           --with hwloc \
           --with mysql \
           --with hdf5 \
           --with lua \
           --with numa \
           --with x11 \
           --without debug \
           --with pmix
  mv $HOME/rpmbuild/RPMS/*/flight-slurm-*.rpm "$TARGET"
else
  rpmbuild -ta $REL.tar.bz2 \
           "${BUILD_FLAGS[@]}" \
           --with hwloc \
           --with mysql \
           --with hdf5 \
           --with lua \
           --with numa \
           --with x11 \
           --without debug \
           --with pmix
  mv $HOME/rpmbuild/RPMS/*/slurm-*.rpm "$TARGET"
fi

if [ "$libssh2" ]; then
  # This is needed for Slurm 18.08 or 17.11.
  if [ "$distro" == "rhel8" ]; then
    mv $HOME/rpmbuild/RPMS/*/libssh2-1.8.0-3.el8.* "$TARGET"
  fi
fi

if [ "$build_libjwt" ]; then
  # This is needed for Slurm 20.11.
  if [ "$distro" == "rhel7" ]; then
    mv ~/rpmbuild/RPMS/x86_64/libjwt-1.12.1-0.el7.x86_64.rpm "$TARGET"
  elif [ "$distro" == "rhel8" ]; then
    mv ~/rpmbuild/RPMS/x86_64/libjwt-1.12.1-0.el8.x86_64.rpm "$TARGET"
  fi
fi

if [ "$built_pmix" ]; then
  # This is needed for Slurm 22.05.
  if [ "$distro" == "rhel7" ]; then
    mv ~/rpmbuild/RPMS/x86_64/pmix-*.rpm "$TARGET"
  fi
fi
