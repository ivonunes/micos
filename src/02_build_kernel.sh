#!/bin/sh -e

. ./.config

cd work/kernel

cd $(ls -d *)

make mrproper
make defconfig

sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"${DISTRO_NAME}\"/" .config

make bzImage -j $(grep ^processor /proc/cpuinfo |wc -l)
make headers_install

cd ../../..
