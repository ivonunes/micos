#!/bin/sh -e

cd $WORK_DIR
cd $(ls -d *)

mkdir -p $ROOTFS_DIR/usr/include
rm -rf $ROOTFS_DIR/usr/include/linux
cp -r usr/include/linux/ $ROOTFS_DIR/usr/include/linux
rm -rf $ROOTFS_DIR/usr/include/asm
cp -r usr/include/asm/ $ROOTFS_DIR/usr/include/asm
rm -rf $ROOTFS_DIR/usr/include/asm-generic
cp -r usr/include/asm-generic/ $ROOTFS_DIR/usr/include/asm-generic
rm -rf $ROOTFS_DIR/usr/include/mtd
cp -r usr/include/mtd/ $ROOTFS_DIR/usr/include/mtd

cp arch/x86/boot/bzImage $ROOTFS_DIR/.kernel
