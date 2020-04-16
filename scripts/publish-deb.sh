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
# Publishes a specified deb to an s3-backed deb repo
set -e
if [ ! -z "${DEBUG}" ]; then
  set -x
fi

export SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ -z "$1" ]; then
  echo "Usage: $0 <deb>"
  exit 1
elif [ ! -f "$1" ]; then
  echo "$0: not found: $1"
  exit 1
fi

if ! aws s3 ls &>/dev/null; then
  echo "$0: unable to access S3; check credentials?"
  exit 1
fi

# Check Slack notifications configured
$SCRIPT_DIR/slack-check.sh

export DEB="$1"
SOURCE_DIR=$(mktemp -d /tmp/publish-rpm.XXXXXX)
ARCH="binary-$(dpkg-deb -I $DEB  |grep '^ Architecture' |awk '{print $2}')"
# Use current VMs distribution as it doesn't look like there's a way of determining distribution from the package itself
DIST="$(lsb_release -cs)"
echo "Using this system's distribution for package: $DIST"
cp $DEB $SOURCE_DIR
$SCRIPT_DIR/publish-debs.sh -s "$SOURCE_DIR" -t "repo.openflighthpc.org/openflight-dev/ubuntu" -d $DIST -a "$ARCH"
rm -rf $SOURCE_DIR
