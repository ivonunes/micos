#!/bin/sh -e

cd $WORK_DIR
cd $(ls -d *)

make mrproper
make defconfig

sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"${OS_NAME}\"/" .config

make bzImage -j $(grep ^processor /proc/cpuinfo |wc -l)
make headers_install
