const exec = require('./utils').exec

exports.rootfs = function () {
  exec([
    'cd tmp',
    'rm -f rootfs.cpio.gz',
    'cd rootfs',
    'mv .kernel ../kernel.bz',
    '(find . |cpio -R root:root -H newc -o |gzip -9 >../rootfs.gz)'
  ])
}

exports.iso = function () {
  exec([
    'cd tmp',
    'mkdir -p iso',
    'cd iso',
    'cp /usr/share/syslinux/isolinux.bin .',
    'cp /usr/share/syslinux/ldlinux.c32 .',
    'mv ../rootfs.gz .',
    'mv ../kernel.bz .',
    '(echo "default kernel.bz initrd=rootfs.gz rdinit=/sbin/init quiet video=-16" > isolinux.cfg)',
    'xorrisofs -f -l -D -J -joliet-long -r -o ../build.iso -A "Operating System" -V "${OS_PROP} ${OS_VERSION}-$(uname -m)" -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table ./',
    '(isohybrid ../build.iso /dev/null 2>&1 || true)'
  ])
}
