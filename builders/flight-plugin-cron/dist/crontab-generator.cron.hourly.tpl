#!/bin/bash
################################################################################
##
## OpenFlight - Cron configuration
## Copyright (c) 2020 Alces Flight Ltd
##
################################################################################
# Run OpenFlight crontab generator
/opt/flight/libexec/cron/crontab-generator "%TARGET%"
