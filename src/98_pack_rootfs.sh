#!/bin/sh -e

cd work || exit 1

rm -f rootfs.cpio.gz

cd rootfs
find . |cpio -R root:root -H newc -o |gzip -9 >../rootfs.cpio.gz

cd ../..

