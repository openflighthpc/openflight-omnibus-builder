#!/bin/bash
#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
#
# This file is part of OpenFlight Omnibus Builder.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# This project is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with this project. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on OpenFlight Omnibus Builder, please visit:
# https://github.com/openflighthpc/openflight-omnibus-builder
#===============================================================================
# Updates vault repo
set -e
if [ ! -z "${DEBUG}" ]; then
  set -x
fi

DEPENDENCIES=("aws" "dpkg-scanpackages")
REGION="eu-west-1"

for dep in "${DEPENDENCIES[@]}"
do
  if [ ! $(which ${dep}) ]; then
      echo "${dep} must be available."
      exit 1
  fi
done

while getopts "s:t:a:d:" opt; do
  case $opt in
    a) ARCH=$OPTARG ;;
    d) DIST=$OPTARG ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

TARGET_PREFIX="repo.openflighthpc.org/openflight-vault/ubuntu"

case $ARCH in
  amd64)
    echo Updating for arch: $ARCH
    ARCH=binary-$ARCH
    ;;
  *)
    echo "No arch specified; specify '-a amd64'."
    exit 1
    ;;
esac

case $DIST in
  bionic)
    echo Updating for distro: $DIST
    ;;
  *)
    echo "No dist specified; specify '-d bionic'." # or '-d focal'."
    exit 1
    ;;
esac

TOPLEVEL_DIR="/tmp/${TARGET_PREFIX}"

TARGET_DIR="/tmp/${TARGET_PREFIX}/dists/${DIST}"
TARGET_PREFIX="${TARGET_PREFIX}/dists/${DIST}"

# make sure we're operating on the latest data in the target bucket
mkdir -p $TARGET_DIR
aws --region "${REGION}" s3 sync --delete "s3://${TARGET_PREFIX}" $TARGET_DIR

mkdir -pv $TARGET_DIR/main/$ARCH/
# create a list of packages, allowing multiple versions
cd $TOPLEVEL_DIR
dpkg-scanpackages -m dists/$DIST/main/$ARCH > dists/$DIST/main/$ARCH/Packages
cat dists/$DIST/main/$ARCH/Packages | gzip -9c > dists/$DIST/main/$ARCH/Packages.gz
cd -

# Create distro release file
cd $TARGET_DIR
cat << EOF > Release
Origin: OpenFlightHPC
Label: OpenFlightHPC Vault Packages
Codename: $DIST
Architectures: $(echo "$ARCH" |sed 's/binary-//g')
Components: main
Description: OpenFlightHPC Vault Packages for Ubuntu $DIST
$(apt-ftparchive release .)
EOF

# GPG signing
rm -f InRelease && gpg --default-key openflighthpc --clearsign -o InRelease Release

# Back to original directory
cd -

# sync the repo state back to s3
aws --region "${REGION}" s3 sync --delete $TARGET_DIR s3://$TARGET_PREFIX --acl public-read
