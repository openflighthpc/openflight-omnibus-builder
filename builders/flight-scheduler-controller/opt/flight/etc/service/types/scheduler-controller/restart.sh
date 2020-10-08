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

# Get the source directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# NOTE: The PID is determined via the supervisor.ipc socket
bash "$DIR"/stop.sh

# Wait up to 10ish seconds for falcon to stop
app_root="$flight_ROOT/opt/scheduler-controller"
for _ in `seq 1 20`; do
  "$flight_ROOT"/bin/ruby "$app_root"/bin/get-falcon-pid.rb "$app_root"/supervisor.ipc
  state=$?
  if [ "$state" -ne 0 ]; then
    break
  fi
done

if [ "$state" -eq 0 ]; then
  echo Failed to stop scheduler-controller
  exit 1
fi

bash "$DIR"/start.sh
