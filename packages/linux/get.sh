#!/bin/sh

SOURCE_URL=https://www.kernel.org/pub/linux/kernel/v4.x/linux-${PACKAGE_VERSION}.tar.xz
ARCHIVE_FILE=${SOURCE_URL##*/}

cd $SOURCE_DIR

if [ ! -s $ARCHIVE_FILE ]; then
  wget -c $SOURCE_URL
fi

tar -xvf $ARCHIVE_FILE -C $WORK_DIR
