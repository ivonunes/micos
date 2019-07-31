#!/bin/sh -e

cd $WORK_DIR
cd $(ls -d *)

ROOTFS_ESCAPED=$(echo \"$ROOTFS_DIR\" |sed 's/\//\\\//g')

[ "$MARCH" = "" ] && MARCH=$(uname -m)
case $MARCH in
  i[4-6]86)
    TARCH=i486
    ;;
  [Xx]86[_-]64)
    TARCH=x86_64
    ;;
  *)
    echo "Unsupported architecture -- $MARCH"
    exit 1
esac

if [ ! -x config.status ]; then
  test -x configure || autoreconf -ivf
  LDFLAGS="-Wl,--gc-sections" \
  CFLAGS="${CFLAGS} -fno-stack-protector -ffunction-sections -fdata-sections -U_FORTIFY_SOURCE" \
  ./configure --prefix=/usr --libdir=/usr/lib \
    --sysconfdir=/etc --mandir=/usr/man --infodir=/usr/info \
    --disable-loginfunc --disable-zlib \
    --build=$TARCH-slackware-linux --host=$TARCH-minimal-linux
  sed 's/2016\.[0-9][0-9]/2016.76/' -i sysoptions.h
fi

make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" -j $(grep ^processor /proc/cpuinfo |wc -l)
make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" strip
