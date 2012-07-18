#!/bin/bash

# Setup environment

set -e

tarsnapdir="$(dirname "$0")"
cd "$tarsnapdir"
tarsnapdir="$PWD"

write_key="$tarsnapdir/$(hostname -s)-tarsnap-write.key"
read_key="$tarsnapdir/$(hostname -s)-tarsnap.key"
cachedir="$tarsnapdir/cachedir"

tarsnap="/usr/local/bin/tarsnap --cachedir $cachedir"
