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

exit 1

#set -e

## Required so action-api can locate the `flight` entry point.
## PATH="${flight_ROOT}/bin:${PATH}"
## Required to support initializers.
#export USER=$(whoami)
## Required to correctly handle output parsing.
#if [ -f /etc/locale.conf ]; then
#  . /etc/locale.conf
#fi
#export LANG=${LANG:-en_US.UTF-8}

## Set the address, log path, var dir, and pid file path
#addr=tcp://127.0.0.1:917
#log_file="${flight_ROOT}"/var/log/action-api/puma.log
#mkdir -p $(dirname "${log_file}")
#var_dir="${flight_ROOT}"/var/action-api
#mkdir -p "${var_dir}"
#pidfile=$(mktemp /tmp/flight-deletable.XXXXXXXX.pid)
#rm "${pidfile}"

## NOTE: The underlining puma command needs to be contained with a wrapper script
##       This allows puma's STDOUT and STDERR to be redirected to a log file.
##
##       Previously --redirect-std* flags where passed directly to puma. These
##       work fine if the web process starts correctly. However any config errors
##       will cause puma to crash before applying the redirects. This in effect
##       suppresses all configuration errors.
##
## PS:   The bin/start script is packager specific and therefore contained within
##       the builder repo; not the upstream source.
##
## PPS:  Standard redirects do not work with tool_bg as it gets passed to the
##       underlining setsid command; not puma.
#tool_bg bash "${flight_ROOT}"/opt/action-api/bin/start "$addr" "$log_file" "$pidfile"

## Wait up to 10ish seconds for puma to start
#pid=''
#for _ in `seq 1 20`; do
#  sleep 0.5
#  pid=$(ps -ax | grep $addr | grep "\spuma\s" | awk '{ print $1 }')
#  if [ -n "$pid" ]; then
#    break
#  fi
#done

## Report back the pid or error
#if [ -n "$pid" ]; then
#  # Wait a second to ensure puma is still running
#  sleep 1
#  kill -0 "$pid" 2>/dev/null
#  if [ "$?" -ne 0 ]; then
#    echo Failed to start action-api >&2
#    exit 2
#  fi

#  tool_set pid=$pid
#else
#  echo Failed to start action-api >&2
#  exit 1
#fi
