#!/bin/sh

. ./.config

ARCHIVE_FILE=${KERNEL_SOURCE_URL##*/}

cd source
if [ ! -s $ARCHIVE_FILE ]; then
  wget -c $KERNEL_SOURCE_URL
fi

mkdir -p ../work/kernel
tar -xvf $ARCHIVE_FILE -C ../work/kernel
cd ..
