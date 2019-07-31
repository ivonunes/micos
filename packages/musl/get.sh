#!/bin/sh -e

SOURCE_URL=https://www.musl-libc.org/releases/musl-${PACKAGE_VERSION}.tar.gz
ARCHIVE_FILE=${SOURCE_URL##*/}

cd $SOURCE_DIR

if [ ! -s $ARCHIVE_FILE ]; then
  wget -c $SOURCE_URL
fi

tar -xvf $ARCHIVE_FILE -C $WORK_DIR
