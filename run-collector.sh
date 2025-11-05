#!/bin/bash -e
#
# amount of time to let the collector run
DURATION=${DURATION:-"24h"}

# offset for starting collector
DELAY_START=${DELAY_START:-"1800"}

# provide a unique ID for each collector
export RUN_ID=$$

sleep $(((RANDOM % ${DELAY_START}) + 1))
exec timeout --preserve-status ${DURATION} $@
