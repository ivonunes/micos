#!/bin/sh

set -e

cd $WORK_DIR
cd $(ls -d *)

./configure --prefix=/usr
make -j $(grep ^processor /proc/cpuinfo |wc -l)
