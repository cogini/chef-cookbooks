#!/bin/bash

# Make backup to tarsnap

set -e
. "$(dirname "$0")/tarsnap-env.sh"

for dir in $(cat "$tarsnapdir/tarsnap-dirs")
do
    archive="$(hostname)_$(date -u +%Y%m%d-%H%M%S)_$(echo "${dir:1}" | tr / -)"
    nice $tarsnap --keyfile $write_key -c -C / --one-file-system -f "$archive" "$dir"
done

"$tarsnapdir/tarsnap-prune.sh"

$tarsnap --keyfile $read_key --print-stats
