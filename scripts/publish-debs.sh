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
# Publishes built debs to an s3-backed deb repo
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
    s) SOURCE_DIR=$OPTARG ;;
    t) TARGET_PREFIX=$OPTARG ;;
    a) ARCH=$OPTARG ;;
    d) DIST=$OPTARG ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [ -z "${SOURCE_DIR}" ]; then
  echo "Source directory must be specified."
  exit 1
fi

if [ -z "${TARGET_PREFIX}" ]; then
  echo "Target bucket prefix must be specified."
  exit 1
fi

# distribution targets
DIST_TARGETS="bionic focal"
if [[ "$DIST_TARGETS" != *"$DIST"* ]] ; then
    # Prompt for user input of target distribution
    echo "Unknown distribution: $DIST"
    echo "Distribution should be one of: $DIST_TARGETS"
    echo "This is expected for noarch RPMs which don't include distribution in release tag"
    echo
    read -p "Which distribution target to use? ($DIST_TARGETS) " dist
    if [[ "$DIST_TARGETS" != *"$dist"* ]] ; then
        echo "$dist is invalid, exiting..."
        exit 1
    elif [[ "$dist" == "" ]] ; then
        echo "No answer provided, exiting..."
        exit 1
    else
        DIST=$dist
    fi
fi

TARGET_DIR="/tmp/${TARGET_PREFIX}/dist/${DIST}"
TARGET_PREFIX="${TARGET_PREFIX}/dist/${DIST}"

# make sure we're operating on the latest data in the target bucket
mkdir -p $TARGET_DIR
aws --region "${REGION}" s3 sync "s3://${TARGET_PREFIX}" $TARGET_DIR

# copy the deb in and update the repo
NOARCH_TARGETS="binary-amd64"

if [ "$ARCH" == "all" ] ; then
    for arch in $NOARCH_TARGETS ; do
        mkdir -pv $TARGET_DIR/main/$arch
        cp -rv $SOURCE_DIR/*.deb $TARGET_DIR/main/$arch
        # create a list of packages, allowing multiple versions
        cd $TARGET_DIR/main/$arch/
        dpkg-scanpackages -m . /dev/null |gzip -9c > Packages.gz
    done
else
    mkdir -pv $TARGET_DIR/main/$ARCH/
    cp -rv $SOURCE_DIR/*.deb $TARGET_DIR/main/$ARCH/
    # create a list of packages, allowing multiple versions
    cd $TARGET_DIR/main/$ARCH/
    dpkg-scanpackages -m . /dev/null |gzip -9c > Packages.gz
fi

# sync the repo state back to s3
aws --region "${REGION}" s3 sync --delete $TARGET_DIR s3://$TARGET_PREFIX --acl public-read

# Notify slack
if [ "$ARCH" == "noarch" ] ; then ARCH="x86_64" ; fi
export PACKAGE=$(echo "$DEB" |sed 's/.*\///g')
export REPO=$(echo "$TARGET_PREFIX" |sed 's/.*org\///g')
export PACKAGE_URL=https://$TARGET_PREFIX/main/$ARCH/$PACKAGE
$SCRIPT_DIR/slack-update.sh
