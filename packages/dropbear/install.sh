#!/bin/sh -e

cd $WORK_DIR
cd $(ls -d *)

make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" DESTDIR=$ROOTFS_DIR install
