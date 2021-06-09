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

# Update the session secret if unset
env_file=/opt/flight/etc/service/env/console-api
mkdir -p $(dirname "${env_file}")
var_name="flight_CONSOLE_API_session_secret"
if [ -f "${env_file}" ] && grep -q "^${var_name}=" "${env_file}" ; then
    # The secret has previously been generated.  We continue to use it.
    :
else
    secret=$( date +%s.%N | sha256sum | cut -c 1-40 )
    echo "${var_name}=${secret}" >> "${env_file}"
    chmod 0400 "${env_file}"
fi

# Generate a private key if required
priv_key=/opt/flight/etc/console-api/id_rsa
pub_key="$priv_key".pub
if [ ! -f "$priv_key" ]; then
  mkdir -p $(dirname "$priv_key")
  ssh-keygen -b 4096 -t rsa -f "$priv_key" -q -N "" -C "Flight Console API Key"

  # Ensure any existing public key is removed
  rm -f "$pub_key"
fi

# Generate the public key if required
if [ ! -f "$pub_key" ]; then
  mkdir -p $(dirname "$pub_key")
  ssh-keygen -y -f "$priv_key" > "$pub_key"
fi

# The following has been added for "best practice" but is not technically
# required at the time of writing
/opt/flight/bin/flight service configure --force >/dev/null 2>&1
