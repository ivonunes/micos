#!/bin/sh -e

. ./.config

ARCHIVE_FILE="${MUSL_SOURCE_URL##*/}"

cd source
if [ ! -s $ARCHIVE_FILE ]; then
  wget -c $MUSL_SOURCE_URL
fi

mkdir -p ../work/musl
tar -xvf $ARCHIVE_FILE -C ../work/musl
cd ..
