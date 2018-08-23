#!/bin/sh -e

. ./.config

cd work/musl || exit 1
cd $(ls -d *)
cd musl_installed
MUSL_INSTALLED=$(pwd)
cd ../../../..

cd work
rm -rf rootfs

cd busybox
cd $(ls -d *)
cp -R _install ../../rootfs

cd ../../dropbear
cd $(ls -d *)
cp -R _install/* ../../rootfs

cd ../../rootfs
rm -f linuxrc

ln -s dbclient usr/bin/ssh

mkdir dev
mkdir -p etc/rc.d
mkdir -p etc/skel
mkdir home
mkdir lib$LIBDIRSUFFIX
mkdir proc
mkdir root
mkdir run
mkdir sys
mkdir tmp
mkdir -p var/log
ln -s ../run var/run
touch var/log/btmp
touch var/log/critical
touch var/log/faillog
touch var/log/lastlog
touch var/log/messages
touch var/log/syslog
touch var/log/wtmp
touch run/utmp
chmod 1777 tmp

cd etc
cat >rc.d/README <<EOF

 As a convention, files here with extension ".sh" should be treated as
 system scripts, hence we need not invoke them manually.

EOF

cat >rc.d/rc.bootstrap.sh <<EOF
#!/bin/sh

dmesg -n 1
mount -t devtmpfs devtmpfs /dev
mkdir -p /dev/pts
mount -t devpts devpts /dev/pts
mount -t proc proc /proc
mount -t sysfs sysfs /sys

dmesg >/var/log/dmesg
syslogd -D -f /etc/syslog.conf

for DEVICE in /sys/class/net/* ; do
  ip link set \${DEVICE##*/} up
  if [ \${DEVICE##*/} != "lo" ]; then
    udhcpc -b -S -i \${DEVICE##*/} -s /etc/rc.d/rc.udhcpc.sh >/dev/null 2>&1
  fi
done

test -x /etc/rc.d/rc.dropbeard && /etc/rc.d/rc.dropbeard start

EOF
chmod +x rc.d/rc.bootstrap.sh

cat >inittab <<EOF
::ctrlaltdel:/sbin/reboot
::once:cat /etc/welcome.txt
::respawn:/bin/cttyhack /bin/sh -l
::restart:/sbin/init
::sysinit:/etc/rc.d/rc.bootstrap.sh
tty2::once:cat /etc/welcome.txt
tty2::respawn:/bin/sh -l
tty3::once:cat /etc/welcome.txt
tty3::respawn:/bin/sh -l
tty4::once:cat /etc/welcome.txt
tty4::respawn:/bin/sh -l

EOF

cat >rc.d/rc.udhcpc.sh <<EOF
#!/bin/sh

ip addr add \$ip/\$mask dev \$interface

if [ "\$dns" ]; then
  echo -n >/etc/resolv.conf
  [ "\$domain" ] && echo domain \$domain >>/etc/resolv.conf
  for nameserver in \$dns; do
    echo nameserver \$nameserver >>/etc/resolv.conf
  done
fi

if [ "\$router" ]; then
  ip route add default via \$router dev \$interface
fi

EOF
chmod +x rc.d/rc.udhcpc.sh

mkdir -p dropbear
../usr/bin/dropbearkey -t dss -f dropbear/dropbear_dss_host_key
../usr/bin/dropbearkey -t ecdsa -f dropbear/dropbear_ecdsa_host_key -s 521
../usr/bin/dropbearkey -t rsa -f dropbear/dropbear_rsa_host_key -s 1024
echo "root:x:0:" >group
echo "root:AprZpdBUhZXss:0:0:Minimal Root,,,:/root:/bin/sh" >passwd

cat >rc.d/rc.dropbeard <<EOF
#!/bin/sh

DAEMON=/usr/sbin/dropbear
DAEMON_OPTS="-p 22"
test -x \$DAEMON || exit

start() {
  echo "Starting secure shell server:" \$DAEMON
  exec \$DAEMON \$DAEMON_OPTS
}

stop() {
  echo "Stopping secure shell server:" \$DAEMON
  killall \$DAEMON >/dev/null 2>&1
}

case \$1 in
  start)
    start
    ;;
  restart)
    stop
    sleep 1
    start
    ;;
  stop)
    stop
    ;;
  *)
    echo "usage: \${0##*/} [start|restart|stop]"
    exit 1
esac

EOF
chmod +x rc.d/rc.dropbeard

cat >resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 8.8.4.4

EOF

cat >syslog.conf <<EOF
# /etc/syslog.conf

kern,user.*                                 /var/log/messages	# all messages of kern and user facilities
kern.!err                                   /var/log/critical	# all messages of kern facility with priorities lower than err (warn, notice ...)
*.*;auth,authpriv.none                      /var/log/noauth	# all messages except ones with auth and authpriv facilities
kern,user.*;kern.!=notice;*.err;syslog.none /var/log/OMG	# some whicked rule just as an example =)
*.*                                         /dev/null		# this prevents from logging to default log file (-O FILE or /var/log/messages)

EOF

cat >welcome.txt <<EOF
[H[2J ##############$(echo "${DISTRO_PROP}_${KERNEL_PROP}_${KERNEL_VERSION}_${TARCH}" |tr [A-Z-a-z0-9_.] "#")#########
#              $(echo "${DISTRO_PROP}_${KERNEL_PROP}_${KERNEL_VERSION}_${TARCH}" |tr [A-Z-a-z0-9_.] " ")        #
#  Welcome to "${DISTRO_PROP}      ${KERNEL_PROP}-${KERNEL_VERSION}-${TARCH}"  #
#              $(echo "${DISTRO_PROP}_${KERNEL_PROP}_${KERNEL_VERSION}_${TARCH}" |tr [A-Z-a-z0-9_.] " ")        #
###############$(echo "${DISTRO_PROP}_${KERNEL_PROP}_${KERNEL_VERSION}_${TARCH}" |tr [A-Z-a-z0-9_.] "#")########

EOF

cd ..

cat >init <<EOF
#!/bin/sh

exec /sbin/init

EOF
chmod +x init

cp $MUSL_INSTALLED/lib/*.so* ./lib$LIBDIRSUFFIX

cat >./etc/hosts <<EOF
# $Local: etc/hosts,v 1.73 2013/05/18 05:50:04 bsd Exp $
#
# Do not remove the following line, or various programs that require
# network functionality will fail.
127.0.0.1	localhost		localhost.localdomain

# This next entry is technically wrong, but good enough to get TCP/IP
# to quiet apps complaining that they can't verify the hostname on a
# loopback-only Linux box.
127.0.0.1	$DISTRO_NAME.example.net $DISTRO_NAME
EOF
cp /etc/services ./etc

cat >./root/.profile <<EOF
alias ..='cd ..'
alias cls='clear'
alias cp='cp -ip'
alias del='rm -i'
alias dir='ls -FA --color=auto'
alias l.='ls -Fd .* --color=auto'
alias la='ls -laF --color=auto'
alias ll='ls -lF --color=auto'
alias ls='ls -xF --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias vdir='ls -lFA --color=auto'

if [ -d /etc/profile.d ]; then
  for y in /etc/profile.d/*.sh ; do [ -x $y ] && . $y; done; unset y
fi

PS1='[\[\033[01;31m\]\u@\h:\[\033[01;33m\]\W\[\033[00m\]]\\$ '
PS2='> '

HOME=/root; export HOME; cd

EOF
sed '1,18!d' < ./root/.profile >etc/skel/.profile
cat >>etc/skel/.profile <<EOF
PS1='[\[\033[01;36m\]\u@\h:\[\033[01;33m\]\W\[\033[00m\]]\\$ '
PS2='> '

EOF
touch ./root/.ash_history
ln -s root/.ash_history .
ln -s root/.profile .

if [ -n "$LIBDIRSUFFIX" ]; then
  ln -s lib64 lib
fi

cd ../..

