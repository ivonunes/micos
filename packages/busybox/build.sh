#!/bin/sh -e

cd $WORK_DIR
cd $(ls -d *)

make distclean
make defconfig

ROOTFS_ESCAPED=$(echo \"$ROOTFS_DIR\" |sed 's/\//\\\//g')
sed -i "s/.*CONFIG_SYSROOT.*/CONFIG_SYSROOT=$ROOTFS_ESCAPED/" .config
sed -i "s/.*CONFIG_INETD.*/CONFIG_INETD=n/" .config

make busybox -j $(grep ^processor /proc/cpuinfo |wc -l)
