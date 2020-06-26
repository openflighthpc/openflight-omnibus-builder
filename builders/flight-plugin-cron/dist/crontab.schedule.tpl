#!/bin/bash
################################################################################
##
## OpenFlight - Cron configuration
## Copyright (c) 2020 Alces Flight Ltd
##
################################################################################
# Run OpenFlight %SCHEDULE% jobs
run-parts /opt/flight/etc/cron/%SCHEDULE%
