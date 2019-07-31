#!/bin/sh -e

VERSION_YEAR="$(echo $PACKAGE_VERSION | cut -d'.' -f1)"
VERSION_BUILD="$(echo $PACKAGE_VERSION | cut -d'.' -f2)"
SOURCE_URL=https://matt.ucc.asn.au/dropbear/releases/dropbear-${VERSION_YEAR}.${VERSION_BUILD}.tar.bz2
ARCHIVE_FILE=${SOURCE_URL##*/}

cd $SOURCE_DIR

if [ ! -s $ARCHIVE_FILE ]; then
  wget -c $SOURCE_URL
fi

tar -xvf $ARCHIVE_FILE -C $WORK_DIR
