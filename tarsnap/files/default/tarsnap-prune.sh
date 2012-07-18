#!/bin/bash

# Remove old backups

# Number of backups to keep
backup_count=10

set -e
. "$(dirname "$0")/tarsnap-env.sh"

archives="$("$tarsnapdir/tarsnap-list.sh")"
first_date="$(date --date="$backup_count days ago" +'%Y-%m-%d')"

echo "$archives" | while read archive
do
    name="$(echo "$archive" | cut -f1)"
    date="$(echo "$archive" | cut -f2)"
    if [[ "$date" < "$first_date" ]]
    then
        echo "Deleting $name"
        $tarsnap --keyfile "$read_key" -d -f "$name"
    fi
done
