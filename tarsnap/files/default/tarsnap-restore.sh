#!/bin/sh

# Restore a backup

# Name of backup
BACKUP_NAME=$1

# Directory path in archive to restore
DIR=$2

set -e

CURDIR=$PWD
BINDIR=`dirname $0`
cd $BINDIR; BINDIR=$PWD; cd $CURDIR

TARSNAP_DIR=$BINDIR
KEYFILE=$TARSNAP_DIR/tarsnap.key
CACHEDIR=$TARSNAP_DIR/cachedir
TARSNAP=/usr/local/bin/tarsnap

tarsnap --keyfile $KEYFILE --cachedir $CACHEDIR -c -f $BACKUP_NAME $DIR

# tarsnap --keyfile $KEYFILE --cachedir $CACHEDIR --list-archives

