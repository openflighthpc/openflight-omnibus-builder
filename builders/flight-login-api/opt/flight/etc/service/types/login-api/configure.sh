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
echo "Configuring"

flight_ROOT="${flight_ROOT:-/opt/flight}"
env_file="$flight_ROOT/etc/service/env/login-api"

for a in "$@"; do
  IFS="=" read k v <<< "${a}"
  case $k in
    cookieDomain)
      if cat "$env_file" | grep 'flight_LOGIN_API_sso_cookie_domain' ; then
        sed -i "s/flight_LOGIN_API_sso_cookie_domain=.*/flight_LOGIN_API_sso_cookie_domain=$v/g" "$env_file"
      else
        echo "flight_LOGIN_API_sso_cookie_domain=$v" >> "$env_file"
      fi
      ;;
    *)
      echo "Unrecognised key: $k"
    ;;
  esac
done
