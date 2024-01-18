#==============================================================================
# Copyright (C) 2024-present Alces Flight Ltd.
#
# This file is part of Flight Profile.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Profile is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Profile. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight Profile, please visit:
# https://github.com/openflighthpc/flight-profile
#==============================================================================
(
  # Only show for users with sudo
  if ! sudo -l -n sudo >/dev/null 2>&1 ; then
    return
  fi

  # Don't show unless status is set to "on" for cluster.status
  if [[ ${flight_PROFILE_status:-'disabled'} != "enabled" ]] ; then
    return
  fi

  # Set formatting
  bold="$(tput bold)"
  clr="$(tput sgr0)"
  if [[ $TERM =~ "256color" ]]; then
    white="$(tput setaf 7)"
    bgblue="$(tput setab 68)"
    bgred="$(tput setab 210)"
    bgorange="$(tput setab 136)"
    bggreen="$(tput setab 64)"
  fi
  echo -e "CLUSTER PROFILE STATUS:\n"
  shopt -s nullglob

  # Profile info
  finished="$(grep -R exit_status ${flight_ROOT}/opt/profile/var/inventory/ |awk '{print $2}' |grep -v '^$')"
  completed_nodes="$(echo "$finished" |grep '^0$' |grep -v '^$' -c )"
  failed_nodes="$(echo "$finished" |grep -v '^0$' |grep -v '^$' -c )"
  applying_nodes="$(grep -Rc 'last_action: apply' ${flight_ROOT}/opt/profile/var/inventory/ || echo -e '0')"
  printf "  ${bold}${white}${bggreen}Completed:${clr}${bold}${white}${clr}\
    $completed_nodes\
    ${bold}${white}${bgorange}Applying:${clr}${bold}${white}${clr}\
    $applying_nodes\
    ${bold}${white}${bgred}Failed:${clr}${bold}${white}${clr}\
    $failed_nodes\n"
  shopt -u nullglob
  echo ""
)
