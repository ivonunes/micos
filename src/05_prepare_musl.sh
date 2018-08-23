#!/bin/sh -e

INITIAL_DIR=$(pwd)

cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

cd work/musl
cd $(ls -d *)

cd musl_installed/usr/include

unlink linux 2>/dev/null
ln -s $WORK_KERNEL_DIR/usr/include/linux linux

unlink asm 2>/dev/null
ln -s $WORK_KERNEL_DIR/usr/include/asm asm

unlink asm-generic 2>/dev/null
ln -s $WORK_KERNEL_DIR/usr/include/asm-generic asm-generic

unlink mtd 2>/dev/null
ln -s $WORK_KERNEL_DIR/usr/include/mtd mtd

cd $INITIAL_DIR
