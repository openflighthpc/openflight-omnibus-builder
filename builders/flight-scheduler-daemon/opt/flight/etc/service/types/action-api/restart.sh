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

# Prevent PIDFILE conflicts via a temporary directory
TMP_DIR=$(mktemp -d flight-scheduler-daemon.restart.XXXXXXXX)
pushd "$TMP_DIR" >/dev/null

# Setup the trap directory to be remove
function cleanup() {
  popd >/dev/null
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# Setup the non-managed PIDFILE
echo "$1" > flight-scheduler-daemon.pid

# Creates the log directory
LOG_DIR="$flight_ROOT"/var/log/scheduler-daemon
mkdir -p "$LOG_DIR"

# Restart the daemon
export FLIGHT_SCHEDULER_DAEMON_PORT=919
"$flight_ROOT"/bin/flexec ruby \
  "$flight_ROOT"/opt/scheduler-daemon/bin/flight-scheduler-daemon.rb \
  restart --log_output --log_dir "$LOG_DIR"

# Set the PID in the managed file
tool_set pid=$(cat flight-scheduler-daemon.pid)
