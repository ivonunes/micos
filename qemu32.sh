#!/bin/sh

. ./.config

qemu-system-i386 -m 64M \
  -cdrom build.iso

