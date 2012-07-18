#!/bin/bash

# Register this machine with tarsnap service and generate key

TARSNAP_USER=noc@cogini.com
#MACHINE=cogini-www
MACHINE=$(hostname)

set -e

CURDIR=$PWD
BINDIR=`dirname $0`
cd $BINDIR; BINDIR=$PWD; cd $CURDIR

TARSNAP_DIR=$BINDIR
KEYFILE=$TARSNAP_DIR/tarsnap.key
WRITE_KEYFILE=$TARSNAP_DIR/tarsnap-write.key
CACHEDIR=$TARSNAP_DIR/cachedir
TARSNAP_KEYGEN=/usr/local/bin/tarsnap-keygen
TARSNAP_KEYMGMT=/usr/local/bin/tarsnap-keymgmt

$TARSNAP_KEYGEN --keyfile $KEYFILE --user $TARSNAP_USER --machine $MACHINE

# Generate key with only write permissions
$TARSNAP_KEYMGMT --outkeyfile $WRITE_KEYFILE -w $KEYFILE

