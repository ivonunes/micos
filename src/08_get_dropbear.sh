#!/bin/sh -e

. ./.config

ARCHIVE_FILE=${DROPBEAR_SOURCE_URL##*/}

cd source
if [ ! -s $ARCHIVE_FILE ]; then
  wget -c $DROPBEAR_SOURCE_URL
fi

mkdir -p ../work/dropbear
tar -xvf $ARCHIVE_FILE -C ../work/dropbear
cd ..
