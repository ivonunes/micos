#!/bin/sh -e

. ./.config

cd work/kernel || exit 1
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

rm -f *.iso
rm -rf work/isoimage

mkdir work/isoimage
cd work/isoimage

for i in lib lib64 share end ; do
    if [ -f /usr/$i/syslinux/isolinux.bin ]; then
        cp /usr/$i/syslinux/isolinux.bin .
        if [ -f /usr/$i/syslinux/ldlinux.c32 ]; then
            cp /usr/$i/syslinux/ldlinux.c32 .
        fi
        break
    fi
    if [ $i = end ]; then
        echo "can't find -- isolinux.bin, ldlinux.c32; is syslinux installed?"
        exit 1
    fi
done

cp $WORK_KERNEL_DIR/arch/x86/boot/bzImage kernel.bz
cp ../rootfs.cpio.gz rootfs.gz

echo 'default kernel.bz initrd=rootfs.gz quiet video=-16' >isolinux.cfg

#${DISTRO_NAME}_${KERNEL_NAME}-${KERNEL_VERSION}-${TARCH}
xorrisofs -f -l -D -J -joliet-long -r \
    -o ../build.iso \
    -A "Live GNU/Linux Operating System" -V "${DISTRO_PROP} ${KERNEL_VERSION}-$(uname -m)" \
    -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table ./

isohybrid ../build.iso /dev/null 2>&1 || true
echo "Created work/build.iso"

/bin/sh

cd ../..

