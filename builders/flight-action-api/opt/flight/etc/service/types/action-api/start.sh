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

# Required so action-api can locate the `flight` entry point.
# PATH="${flight_ROOT}/bin:${PATH}"
# Required to support initializers.
export USER=$(whoami)
# Required to correctly handle output parsing.
if [ -f /etc/locale.conf ]; then
  . /etc/locale.conf
fi
export LANG=${LANG:-en_US.UTF-8}

var_dir="${flight_ROOT}"/var/action-api
mkdir -p "${var_dir}"

log_file="${flight_ROOT}"/var/log/action-api/puma.log
mkdir -p $(dirname "${log_file}")

pidfile=$(mktemp /tmp/flight-deletable.XXXXXXXX.pid)
rm "${pidfile}"

addr=tcp://127.0.0.1:915
tool_bg "${flight_ROOT}"/bin/ruby \
  "${flight_ROOT}"/opt/action-api/bin/puma --bind $addr \
    --pidfile $pidfile \
    --environment production \
    --redirect-stdout "${log_file}" \
    --redirect-stderr "${log_file}" \
    --redirect-append \
    --dir "${flight_ROOT}"/opt/action-api

# Wait up to 10ish seconds for puma to start
pid=''
for _ in `seq 1 20`; do
  sleep 0.5
  pid=$(ps -ax | grep $addr | grep "\spuma\s" | awk '{ print $1 }')
  if [ -n "$pid" ]; then
    break
  fi
done

# Report back the pid or error
if [ -n "$pid" ]; then
  tool_set pid=$pid
else
  echo Failed to start action-api >&2
  exit 1
fi
