#!/bin/sh -e

SOURCE_URL=http://busybox.net/downloads/busybox-${PACKAGE_VERSION}.tar.bz2
ARCHIVE_FILE=${SOURCE_URL##*/}

cd $SOURCE_DIR

if [ ! -s $ARCHIVE_FILE ]; then
  wget -c $SOURCE_URL
fi

tar -xvf $ARCHIVE_FILE -C $WORK_DIR
