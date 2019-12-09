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
# Publishes built RPMs to an s3-backed RPM repo.
set -e
if [ ! -z "${DEBUG}" ]; then
  set -x
fi

DEPENDENCIES=("aws" "createrepo")
REGION="eu-west-1"

for dep in "${DEPENDENCIES[@]}"
do
  if [ ! $(which ${dep}) ]; then
      echo "${dep} must be available."
      exit 1
  fi
done

while getopts "s:t:a:" opt; do
  case $opt in
    s) SOURCE_DIR=$OPTARG ;;
    t) TARGET_PREFIX=$OPTARG ;;
    a) ARCH=$OPTARG ;;
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

TARGET_DIR="/tmp/${TARGET_PREFIX}"

# make sure we're operating on the latest data in the target bucket
mkdir -p $TARGET_DIR
aws --region "${REGION}" s3 sync "s3://${TARGET_PREFIX}" $TARGET_DIR

# copy the RPM in and update the repo
NOARCH_TARGETS="x86_64 aarch64"

if [ "$ARCH" == "noarch" ] ; then
    for arch in $NOARCH_TARGETS ; do
        mkdir -pv $TARGET_DIR/$arch
        cp -rv $SOURCE_DIR/*.rpm $TARGET_DIR/$arch
        UPDATE=""
        if [ -e "$TARGET_DIR/$arch/repodata/repomd.xml" ]; then
          UPDATE="--update "
        fi
        createrepo -v $UPDATE --deltas $TARGET_DIR/$arch/
    done
else
    mkdir -pv $TARGET_DIR/$ARCH/
    cp -rv $SOURCE_DIR/*.rpm $TARGET_DIR/$ARCH/
    UPDATE=""
    if [ -e "$TARGET_DIR/$ARCH/repodata/repomd.xml" ]; then
      UPDATE="--update "
    fi
    createrepo -v $UPDATE --deltas $TARGET_DIR/$ARCH/
fi

# sync the repo state back to s3
aws --region "${REGION}" s3 sync $TARGET_DIR s3://$TARGET_PREFIX
