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

DEPENDENCIES=("aws" "createrepo")
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

TARGET_PREFIX="repo.openflighthpc.org/openflight-vault/centos"

case $ARCH in
  aarch64|x86_64)
    echo Updating for arch: $ARCH
    ;;
  *)
    echo "No arch specified; specify '-a aarch64' or '-a x86_64'."
    exit 1
    ;;
esac

case $DIST in
  7|8)
    echo Updating for distro: EL$DIST
    ;;
  *)
    echo "No dist specified; specify '-d 7' or '-d 8'."
    exit 1
    ;;
esac

TARGET_DIR="/tmp/${TARGET_PREFIX}/${DIST}"
TARGET_PREFIX="${TARGET_PREFIX}/${DIST}"

# make sure we're operating on the latest data in the target bucket
mkdir -p $TARGET_DIR
aws --region "${REGION}" s3 sync --delete "s3://${TARGET_PREFIX}" $TARGET_DIR

UPDATE=""
if [ -e "$TARGET_DIR/$arch/repodata/repomd.xml" ]; then
  UPDATE="--update "
fi
createrepo -v $UPDATE --deltas $TARGET_DIR/$ARCH/

# sync the repo state back to s3
aws --region "${REGION}" s3 sync --delete $TARGET_DIR s3://$TARGET_PREFIX --acl public-read
