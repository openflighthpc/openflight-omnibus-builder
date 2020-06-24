################################################################################
##
## Flight GL
## Copyright (c) 2020-present Alces Flight Ltd
##
################################################################################
if ( ! $?flight_GL_root ) then
   setenv flight_GL_root "${flight_ROOT}"/opt/gl
endif

if ($?flight_DEFINES) then
  setenv flight_DEFINES "${flight_DEFINES} flight_GL_root"
endif
