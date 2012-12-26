#!/bin/bash

# Make backup to tarsnap

set -e
. "$(dirname "$0")/tarsnap-env.sh"

for dir in $(cat "$tarsnapdir/tarsnap-dirs")
do
    # Strip leading slash manually
    dir="${dir#/}"
    # Name of archive is like cogini-prod1_20120812-190027_opt-cogini
    archive="$(hostname)_$(date -u +%Y%m%d-%H%M%S)_$(echo "${dir}" | tr / -)"

    nice $tarsnap --keyfile $write_key -c -C / --one-file-system --exclude access.log -f "$archive" "$dir"
done

"$tarsnapdir/tarsnap-prune.sh"

$tarsnap --keyfile $read_key --print-stats
