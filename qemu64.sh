#!/bin/sh

. ./.config

qemu-system-x86_64 -m 64M \
  -cdrom build.iso

