#!/bin/bash
set -e

clean_up() {
  #rm -rf "${CERT_DIR}"
  :
}
trap clean_up EXIT

# XXX Move this somewhere else.  Perhaps a flight-pdsh-sync package.
#
#

build_genders_file() {
    # /opt/flight/bin/flight asset list \
    ./bin/asset list  \
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
    nodeattr -f genders --compress
}

install_genders_file() {
    :
    # pdcp -g all genders /etc/genders
}


main() {
    # asset_flight_asset
    # save_genders_file
    # compress_genders_file
    # install_genders_file
    build_genders_file
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
