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
echo "Stopping: $@"
pid=$(cat "$1")
if [ "$2" == "--force" ] ; then
    force=true
else
    force=false
fi
kill $pid

# Console API has a safe shutdown mechanism to give users a chance to finish
# up their console session / save work etc..  That safe shutdown has Console
# API wait 30 seconds (by default) before terminating its connections.
#
# If we are using the safe shutdown we wait for 32 seconds to give a chance
# for that to happen.
#
# If we are forcing the shutdown, we wait a couple of seconds and then force
# the shutdown if it hasn't already done so.
if [ "$force" == "true" ] ; then
    max_wait=4
else
    max_wait=64
fi
for _ in `seq 1 $max_wait`; do
    sleep 0.5
    if [ ! -f "${flight_ROOT}/var/run/console-api.pid" ]; then
        break
    fi
done

if [ -f "${flight_ROOT}/var/run/console-api.pid" -a "$force" == "true" ]; then
    # This second kill will circumvent the graceful shutdown and close the
    # connections immediately.
    kill $pid
fi
