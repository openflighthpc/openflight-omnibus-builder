#!/bin/bash
#==============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
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
# Promotes an deb from one repo to another (e.g. dev -> prod)
set -e
if [ ! -z "${DEBUG}" ]; then
  set -x
fi

DEPENDENCIES=("aws" "dpkg-scanpackages")
REGION="eu-west-1"

while getopts "s:t:r:d:" opt; do
  case $opt in
    r) DEB_MATCH=$OPTARG ;;
    s) SOURCE_PREFIX=$OPTARG ;;
    t) TARGET_PREFIX=$OPTARG ;;
    d) DIST=$OPTARG ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

for dep in "${DEPENDENCIES[@]}"
do
  if [ ! $(which ${dep}) ]; then
      echo "${dep} must be available."
      exit 1
  fi
done

if [ -z "${DEB_MATCH}" ]; then
  echo "Deb match string must be specified."
  exit 1
fi

if [ -z "${SOURCE_PREFIX}" ]; then
  echo "Source bucket prefix must be specified."
  exit 1
fi

if [ -z "${TARGET_PREFIX}" ]; then
  echo "Target bucket prefix must be specified."
  exit 1
fi

# distribution targets
DIST_TARGETS="bionic focal"

if [[ "$DIST_TARGETS" != *"$DIST"* ]] ; then
    echo "Unknown distribution: $DIST"
    echo "Distribution should be one of: $DIST_TARGETS"
    exit 1
fi

TOPLEVEL_DIR="/tmp/${TARGET_PREFIX}"
TOPLEVEL_PREFIX="${TARGET_PREFIX}"

SOURCE_PREFIX="${SOURCE_PREFIX}/dists/$DIST"
TARGET_PREFIX="${TARGET_PREFIX}/dists/$DIST"

SOURCE_DIR="/tmp/${SOURCE_PREFIX}"
TARGET_DIR="/tmp/${TARGET_PREFIX}"

# make sure we're operating on the latest data in the source bucket
mkdir -p $SOURCE_DIR
aws --region "${REGION}" s3 sync "s3://${SOURCE_PREFIX}" $SOURCE_DIR

# make sure we're operating on the latest data in the target bucket
mkdir -p $TARGET_DIR
aws --region "${REGION}" s3 sync "s3://${TARGET_PREFIX}" $TARGET_DIR

# copy the deb in and update the repo
NOARCH_TARGETS="binary-amd64"
bash -c "mkdir -pv $TARGET_DIR/main/{${NOARCH_TARGETS/ /,}}/"
shopt -s nullglob

# Locate deb
matches="$(find $SOURCE_DIR -path "*$DEB_MATCH*")"
shopt -u nullglob

# Exit if no matches found
if [ -z "$matches" ]; then
  echo "No match found: $SOURCE_DIR/main/{${NOARCH_TARGETS/ /,}}/${DEB_MATCH}*"
  exit 1
fi

# Exit if more than one match found
if [[ $(echo "$matches" |wc -l) -gt 1 ]] ; then
    echo "More than one match found: "
    echo "$matches"
    echo
    echo "Please refine the argument to match more specifically, this can be done by ensuring that version number, build date, architecture and parent directory are included in the argument:"
    echo "    binary-amd64/flight-starter-banner_2020.2.1-1.deb"
    exit 1
fi

echo "Match: $matches"

ARCH="binary-$(dpkg-deb -I $matches |grep '^ Architecture' |awk '{print $2}')"

# Push to all architectures if noarch rpm
if [ "$ARCH" == "binary-noarch" ] ; then
    for arch in $NOARCH_TARGETS ; do
        mkdir -pv $TARGET_DIR/main/$arch
        cp -rv ${matches} $TARGET_DIR/main/$arch
        # create a list of packages, allowing multiple versions
        cd $TOPLEVEL_DIR
        dpkg-scanpackages -m dists/$DIST/main/$arch > dists/$DIST/main/$arch/Packages
        cat dists/$DIST/main/$arch/Packages | gzip -9c > dists/$DIST/main/$arch/Packages.gz
        cd -
    done
else
    mkdir -pv $TARGET_DIR/main/$ARCH/
    cp -rv ${matches} $TARGET_DIR/main/$ARCH/
    # create a list of packages, allowing multiple versions
    cd $TOPLEVEL_DIR
    dpkg-scanpackages -m dists/$DIST/main/$ARCH > dists/$DIST/main/$ARCH/Packages
    cat dists/$DIST/main/$ARCH/Packages | gzip -9c > dists/$DIST/main/$ARCH/Packages.gz
    cd -
fi

# Create distro release file
cd $TARGET_DIR
cat << EOF > Release
Origin: OpenFlightHPC
Label: OpenFlightHPC Production Packages
Codename: $DIST
Architectures: $(echo "$ARCH" |sed 's/binary-//g')
Components: main
Description: OpenFlightHPC Production Packages for Ubuntu $DIST
$(apt-ftparchive release .)
EOF

# GPG signing
rm -f InRelease && gpg --default-key openflighthpc --clearsign -o InRelease Release

# Back to original directory
cd -

# sync the repo state back to s3
aws --region "${REGION}" s3 sync --delete $TARGET_DIR s3://$TARGET_PREFIX --acl public-read

# Notify slack
if [ "$ARCH" == "noarch" ] ; then ARCH="binary-amd64" ; fi
export PACKAGE=$(echo "$matches" |sed 's/.*\///g')
export REPO=$(echo "$TARGET_PREFIX" |sed 's/.*org\///g')
export PACKAGE_URL=https://$TARGET_PREFIX/main/$ARCH/$PACKAGE
$SCRIPT_DIR/slack-update.sh