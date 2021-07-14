#!/bin/bash
#==============================================================================
# Copyright (C) 2021-present Alces Flight Ltd.
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


pid_file="$1"
if [ -z "$pid_file" ]; then
  echo "The pid_file argument has not been provided!" >&2
  exit 1
fi
if [ -z "$flight_ROOT" ]; then
  echo "flight_ROOT has not been set!" >&2
  exit 1
fi
if [ -z "$PUMA_LOG_FILE" ]; then
  echo "PUMA_LOG_FILE has not been set!" >&2
  exit 1
fi

# Ensure the log directory exists
mkdir -p $(dirname "$PUMA_LOG_FILE")

# Restarts the puma worker processes
"${flight_ROOT}"/bin/flexec ruby ${flight_ROOT}/opt/action-api/bin/pumactl restart \
  --pidfile $1 \
  --config-file ${flight_ROOT}/opt/action-api/config/puma.rb \
  >>"$PUMA_LOG_FILE" 2>&1

# Sleeps two seconds and ensure puma is still running
sleep 2
kill -0 "$(cat "$pid_file")" 2>/dev/null
if [ "$?" -ne 0]; then
  echo Failed to reload action-api >&2
  exit 2
fi

# Ensures the PID remains set (it hasn't changed)
tool_set pid=$(cat "$pid_file")
