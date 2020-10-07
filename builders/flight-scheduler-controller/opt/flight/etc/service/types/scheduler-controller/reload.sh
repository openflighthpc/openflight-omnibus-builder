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

# Restarts the falcon worker processes
pid=$("$flight_ROOT"/opt/scheduler-controller/get-falcon-pid.rb "$flight_ROOT"/opt/scheduler-controller/supervisor.ipc)
kill -s SIGHUP "$pid"

# Sleeps two seconds and ensure falcon is still running
sleep 2
pid=$("$flight_ROOT"/opt/scheduler-controller/get-falcon-pid.rb "$flight_ROOT"/opt/scheduler-controller/supervisor.ipc)
if [ "$?" -ne 0]; then
  echo Failed to reload scheduler-controller >&2
  exit 2
fi

# Ensures the PID remains set (it hasn't changed)
tool_set pid="$pid"
