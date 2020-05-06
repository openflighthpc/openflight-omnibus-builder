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
echo "Starting"
mkdir -p "${flight_ROOT}"/var/run
mkdir -p "${flight_ROOT}"/var/log/console-api
cd "${flight_ROOT}"/opt/console-api

tool_bg "bin/start"
wait

# Wait up to 10ish seconds for the server to write its pid file.
pid=''
for _ in `seq 1 20`; do
  sleep 0.5
  if [ -f "${flight_ROOT}/var/run/console-api.pid" ]; then
    pid=$(cat "${flight_ROOT}/var/run/console-api.pid")
    if [ -n "$pid" ]; then
      break
    fi
  fi
done

echo "Done waiting for PID. pid=${pid}"

# Report back the pid or error
if [ -n "$pid" ]; then
  tool_set pid=$pid
  exit 0
else
  echo Failed to start console-api >&2
  exit 1
fi
