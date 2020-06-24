################################################################################
##
## Flight Environment
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
if ( -f ${flight_ROOT}/etc/env.cshrc ) then
  source ${flight_ROOT}/etc/env.cshrc
endif
if ( ! $?flight_ENV_root ) then
   setenv flight_ENV_root "${flight_ROOT}"/opt/env
endif
setenv flight_ENV_shell tcsh

set sourcechk=1
source ${flight_ENV_root}/etc/tcsh/flenv-fnwrapper.csh
unset sourcechk

set flight_ENV_cmd="${flight_ROOT}/bin/flexec ruby $flight_ENV_root/bin/flenv"

if ( ! $?flight_SYSTEM_start ) then
  set flight_SYSTEM_start=false
  set flight_SYSTEM_start_tmp=true
endif

if ( ! $?flight_ENV_active && ( $?loginsh || $?prompt || "$flight_SYSTEM_start" == "true" ) ) then
  # Activate default environment
  set flight_ENV_default=`flenv show-default --empty-if-unset`
  if ( "$flight_ENV_default" != "" ) then
    flenv activate "${flight_ENV_default}"
  endif
  unset flight_ENV_default
endif

if ($?flight_SYSTEM_start_tmp) then
  unset flight_SYSTEM_start
  unset flight_SYSTEM_start_tmp
endif

alias flight_env_exit 'if ( $?flight_ENV_active ) eval flenv deactivate'

if ($?flight_DEFINES) then
  setenv flight_DEFINES "${flight_DEFINES} flenv flight_env_exit flight_ENV_root flight_ENV_shell flight_ENV_eval_cmd flight_ENV_cmd"
  setenv flight_DEFINES_exits "${flight_DEFINES_exits} flight_env_exit"
endif
