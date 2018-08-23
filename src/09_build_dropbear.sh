#!/bin/sh -e

. ./.config

cd work/musl
cd $(ls -d *)
cd musl_installed
MUSL_INSTALLED=$(pwd)
cd ../../../..

cd work/dropbear
cd $(ls -d *)

MUSL_INSTALLED_ESCAPED=$(echo \"$MUSL_INSTALLED\" |sed 's/\//\\\//g')

if [ ! -x config.status ]; then
  test -x configure || autoreconf -ivf
  LDFLAGS="-Wl,--gc-sections" \
  CFLAGS="${CFLAGS} -fno-stack-protector -ffunction-sections -fdata-sections -U_FORTIFY_SOURCE" \
  ./configure --prefix=/usr --libdir=/usr/lib$LIBDIRSUFFIX \
    --sysconfdir=/etc --mandir=/usr/man --infodir=/usr/info \
    --disable-loginfunc --disable-zlib \
    --build=$TARCH-slackware-linux --host=$TARCH-minimal-linux
  sed 's/2016\.[0-9][0-9]/2016.76/' -i sysoptions.h
fi

make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" -j $(grep ^processor /proc/cpuinfo |wc -l)
make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" strip
make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" DESTDIR=_install install

cd ../../..
