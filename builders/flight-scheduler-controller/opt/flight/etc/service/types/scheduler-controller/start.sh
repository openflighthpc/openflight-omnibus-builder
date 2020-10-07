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
set -e

# Required to support initializers.
export USER=$(whoami)
# Required to correctly handle output parsing.
if [ -f /etc/locale.conf ]; then
  . /etc/locale.conf
fi
export LANG=${LANG:-en_US.UTF-8}

# Move to the source code dirctory
cd "$flight_ROOT"/opt/scheduler-controller

# Set the address, log path, var dir, and pid file path
addr=http://127.0.0.1:918
log_file="${flight_ROOT}"/var/log/scheduler-controller/falcon.log

# The wrapper script which redirects falcon's logs and allows logrotate to
# reopen the file descriptors. The first argument must be the log path, all
# subsequent arguments are directly passed to falcon
tool_bg "${flight_ROOT}"/bin/ruby \
  "${flight_ROOT}"/opt/scheduler-controller/bin/start \
  "$log_file" --threaded -n 2 -b "$addr"

# Wait up to 10ish seconds for falcon to start
pid=''
for _ in `seq 1 20`; do
  sleep 0.5
  pid=$(ps -ax | grep $addr | grep "falcon" | awk '{ print $1 }')
  if [ -n "$pid" ]; then
    break
  fi
done

# Report back the pid or error
if [ -n "$pid" ]; then
  # Wait a second to ensure falcon is still running
  sleep 1
  kill -0 "$pid" 2>/dev/null
  if [ "$?" -ne 0 ]; then
    echo Failed to start scheduler-controller >&2
    exit 2
  fi

  tool_set pid=$pid
else
  echo Failed to start scheduler-controller >&2
  exit 1
fi
