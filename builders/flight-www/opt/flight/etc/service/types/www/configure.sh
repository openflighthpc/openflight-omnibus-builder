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

echo "Configuring"
mkdir -p "${flight_SERVICE_etc}"
>"${flight_SERVICE_etc}/example.rc"
for a in "$@"; do
  IFS="=" read k v <<< "${a}"
  echo "www_$k=\"$v\"" >> "${flight_SERVICE_etc}/www.rc"
  case $k in
    port)
      # XXX - test?
      sed -i "${flight_ROOT}"/etc/www/http.d/base-http.conf \
          -e "s/^\s*listen\s.*;/listen ${v} default;/g"
    ;;
    https_port)
      if [ -f "${flight_ROOT}"/etc/www/http.d/https.conf.disabled ] ; then
          sed -i "${flight_ROOT}"/etc/www/http.d/https.conf.disabled \
              -e "s/^\s*listen\s.*;/listen ${v} ssl default;/g"
      fi
    ;;
    *)
      echo "Unrecognised key: $k"
    ;;
  esac
done
