#!/bin/sh -e

cd $WORK_DIR
cd $(ls -d *)

make install
rm -f _install/linuxrc
rsync -a _install/ $ROOTFS_DIR/
