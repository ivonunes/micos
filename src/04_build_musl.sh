#!/bin/sh

. ./.config

cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

cd work/musl
cd $(ls -d *)

mkdir -p musl_installed
cd musl_installed
MUSL_INSTALLED=$(pwd)

cd ..

./configure --prefix=/usr
make -j $(grep ^processor /proc/cpuinfo |wc -l)
make DESTDIR="$MUSL_INSTALLED" install-headers -j $(grep ^processor /proc/cpuinfo |wc -l)
make DESTDIR="$MUSL_INSTALLED" install -j $(grep ^processor /proc/cpuinfo |wc -l)

cd ../../..
