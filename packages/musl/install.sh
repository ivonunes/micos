#!/bin/sh -e

cd $WORK_DIR
cd $(ls -d *)

mkdir -p _install
cd _install
MUSL_INSTALL=$(pwd)
cd ..

make DESTDIR="$MUSL_INSTALL" install-headers -j $(grep ^processor /proc/cpuinfo |wc -l) || :
make DESTDIR="$MUSL_INSTALL" install -j $(grep ^processor /proc/cpuinfo |wc -l) || :

cd _install/usr/include
rm -rf linux
rm -rf asm
rm -rf asm-generic
rm -rf mtd
cd ../../..

rsync -a _install/ $ROOTFS_DIR/
