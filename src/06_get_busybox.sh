#!/bin/sh -e

. ./.config

ARCHIVE_FILE=${BUSYBOX_SOURCE_URL##*/}

cd source
if [ ! -s $ARCHIVE_FILE ]; then
  wget -c $BUSYBOX_SOURCE_URL
fi

mkdir -p ../work/busybox
tar -xvf $ARCHIVE_FILE -C ../work/busybox
cd ..
