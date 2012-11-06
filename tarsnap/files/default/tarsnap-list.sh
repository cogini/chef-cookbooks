#!/bin/bash

# List available backups

set -e
. "$(dirname "$0")/tarsnap-env.sh"

$tarsnap --keyfile $read_key --list-archives -v
