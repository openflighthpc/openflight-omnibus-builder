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


# Ensure flight_ROOT is set
if [ -z "$flight_ROOT" ]; then
  echo "flight_ROOT has not been set!" >&2
  exit 1
fi

PID_FILE="$1"
OLD_PID="$(cat "$PID_FILE" | tr -d "\n")"

${flight_ROOT}/etc/service/types/action-api/stop.sh "$PID_FILE"

if [ -n "$OLD_PID" ] ; then
  # Wait up to 10ish seconds for puma to stop
  state=1
  for _ in `seq 1 20`; do
    sleep 0.5
    kill -0 "$OLD_PID" 2>/dev/null
    state=$?
    if [ "$state" -ne 0 ]; then
      break
    fi
  done

  if [ "$state" -eq 0 ]; then
    echo Failed to stop action-api
    exit 1
  fi
fi

${flight_ROOT}/etc/service/types/action-api/start.sh
