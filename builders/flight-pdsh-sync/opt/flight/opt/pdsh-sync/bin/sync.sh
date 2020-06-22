#!/bin/bash
#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
#
# This file is part of Flight Service.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Service is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Service. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight Service, please visit:
# https://github.com/openflighthpc/openflight-omnibus-builder/blob/master/builders/flight-pdsh-sync/README.md
# ==============================================================================
set -e

clean_up() {
  :
}
trap clean_up EXIT

build_genders_file() {
    /opt/flight/bin/flight asset list \
        | awk '
            BEGIN { FS="\t"; OFS="\t" }
            {
                if (length($5) > 0) {
                    printf "%s\t%s,all\n",$1,$5
                } else {
                    printf "%s\tall\n",$1
                }
            }
        '
}

save_genders_file() {
    build_genders_file > genders
}

compress_genders_file() {
    if type nodeattr >/dev/null 2>&1 ; then
        nodeattr -f genders --compress > genders.compressed
        mv genders.compressed genders
    fi
}

install_genders_file() {
    pdcp -g all -F ./genders ./genders "${flight_ROOT}"/etc/genders
}

main() {
    echo "Building genders file"
    save_genders_file
    echo "Compressing genders file"
    compress_genders_file
    echo "Genders file saved to $(pwd)/genders"
    if type nodeattr >/dev/null 2>&1 ; then
        echo "Copying genders file to $(nodeattr -f ./genders -q all)"
    else
        echo "Copying genders file"
    fi
    install_genders_file
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
