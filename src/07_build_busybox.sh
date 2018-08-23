#!/bin/sh -e

. ./.config

cd work/musl
cd $(ls -d *)
cd musl_installed
MUSL_INSTALLED=$(pwd)
cd ../../../..

cd work/busybox
cd $(ls -d *)

make distclean
make defconfig

MUSL_INSTALLED_ESCAPED=$(echo \"$MUSL_INSTALLED\" |sed 's/\//\\\//g')
sed -i "s/.*CONFIG_SYSROOT.*/CONFIG_SYSROOT=$MUSL_INSTALLED_ESCAPED/" .config
sed -i "s/.*CONFIG_INETD.*/CONFIG_INETD=n/" .config

make busybox -j $(grep ^processor /proc/cpuinfo |wc -l)
make install

cd ../../..
