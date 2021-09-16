#==============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
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
#==============================================================================

if [ -r "$flight_ROOT"/etc/pdsh.rc ]; then
  source "$flight_ROOT"/etc/pdsh.rc
fi

case ${flight_PDSH_priority:-embedded} in
  embedded)
    export PATH="$flight_ROOT"/opt/pdsh/bin:$PATH
    ;;
  disabled)
    # NOOP
    ;;
  *) # "system" is the canonical trigger term here
    export PATH=$PATH:"$flight_ROOT"/opt/pdsh/bin
    ;;
esac

unset $(declare | grep ^flight_PDSH | cut -f1 -d= | xargs)

if [ -n "$flight_DEFINES_paths" ]; then
  flight_DEFINES_paths="$flight_DEFINES_paths $flight_ROOT/opt/pdsh/bin"
fi
