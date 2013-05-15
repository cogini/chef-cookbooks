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


# Directories to backup
DIRS="<%= node[:tarsnap][:dirs].join(' ') %>"

# Number of daily backups to keep
DAILY=7

# Number of weekly backups to keep
WEEKLY=4
# Which day to do weekly backups on
# 1-7, Monday = 1
WEEKLY_DAY=1

# Number of monthly backups to keep
MONTHLY=3
# Which day to do monthly backups on
# 01-31 (leading 0 is important)
MONTHLY_DAY=01

# Path to tarsnap
#TARSNAP="/home/tdb/tarsnap/tarsnap.pl"
TARSNAP="/usr/local/bin/tarsnap"

DIR="$(cd "$(dirname "$0")"; pwd)"
KEY="$DIR/$(hostname -s)-tarsnap.key"
CACHE_DIR="$DIR/cachedir"

# end of config
