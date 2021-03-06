################################################################################
##
## Flight Environment
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
flenv() {
  local op tmpf rc flight_ENV_eval
  if [ -x $flight_ENV_root/bin/flenv ]; then
    export FLIGHT_PROGRAM_NAME=${FLIGHT_PROGRAM_NAME:-flenv}
    op="$1"
    case $op in
      activate|deactivate|switch)
        tmpf=$(mktemp -t flenv.XXXXXXXX)
        flight_ENV_eval=true flexec ruby $flight_ENV_root/bin/flenv "$@" > $tmpf
        rc=$?
        if [ $rc -gt 0 ]; then
          cat $tmpf
          unset FLIGHT_PROGRAM_NAME
          return $rc
        else
          source $tmpf
        fi
        rm -f $tmpf
        ;;
      *)
        flexec ruby $flight_ENV_root/bin/flenv "$@"
        ;;
    esac
  fi
  unset FLIGHT_PROGRAM_NAME
}
export -f flenv

if [ -f ${flight_ROOT}/etc/env.rc ]; then
  . ${flight_ROOT}/etc/env.rc
fi
export flight_ENV_root=${flight_ENV_root:-${flight_ROOT}/opt/env}
export flight_ENV_shell=bash

flight_env() {
  export FLIGHT_PROGRAM_NAME="flight env"
  flenv "$@"
}
export -f flight_env

if [ -z "${flight_ENV_active}" ] && \
    (
        shopt -q login_shell || \
            [ "${-#*i}" != "$-" ] || \
            [ "${flight_SYSTEM_start}" == "true" ]
    ); then
  # Activate default environment
  flight_ENV_default="$(flenv show-default --empty-if-unset)"
  if [ "$flight_ENV_default" ]; then
    # Fix prompt -- the logic in the usual place (`/etc/bashrc`) is
    # such that if PS1 is overridden somewhere in `/etc/profile.d`
    # then it's not overridden later in `/etc/bashrc`, so we fix it
    # here in case it's not yet been set.
    [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
    flenv activate "${flight_ENV_default}"
  fi
  unset flight_ENV_default
fi

flight_env_exit() {
  if [ "${flight_ENV_active}" ]; then
    flenv deactivate
  fi
}
export -f flight_env_exit

if [ "${flight_DEFINES}" ]; then
  flight_DEFINES+=(flenv flight_env flight_env_exit flight_ENV_root flight_ENV_shell)
  flight_DEFINES_exits+=(flight_env_exit)
fi
