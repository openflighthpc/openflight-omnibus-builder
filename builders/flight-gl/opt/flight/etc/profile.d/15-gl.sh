################################################################################
##
## Flight GL
## Copyright (c) 2020-present Alces Flight Ltd
##
################################################################################
if [ -f ${flight_ROOT}/etc/gl.rc ]; then
  . ${flight_ROOT}/etc/gl.rc
fi
export flight_GL_root="${flight_GL_root:-${flight_ROOT}/opt/gl}"

flgl() {
  local op
  if [ -x "${flight_GL_root}"/bin/gl ]; then
    export FLIGHT_PROGRAM_NAME=${FLIGHT_PROGRAM_NAME:-flgl}
    op="$1"
    case $op in
      start|stop)
        source "${flight_GL_root}"/bin/gl "$@"
        ;;
      *)
        "${flight_GL_root}"/bin/gl "$@"
        ;;
    esac
  fi
  unset FLIGHT_PROGRAM_NAME

}
export -f flgl

flight_gl() {
  export FLIGHT_PROGRAM_NAME="flight gl"
  flgl "$@"
}
export -f flight_gl
